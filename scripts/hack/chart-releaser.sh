#!/usr/bin/env bash
# Source: https://github.com/helm/chart-releaser-action/blob/3e001cb8c68933439c7e721650f20a07a1a5c61e/cr.sh#L1

# Copyright The Helm Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

DEFAULT_CHART_RELEASER_VERSION=v1.7.0

show_help() {
    cat <<EOF
Usage: $(basename "$0") <options>

    -h, --help                    Display help
    -v, --version                 The chart-releaser version to use (default: $DEFAULT_CHART_RELEASER_VERSION)"
        --config                  The path to the chart-releaser config file
    -d, --charts-dir              The charts directory (default: charts)
    -o, --owner                   The repo owner
    -r, --repo                    The repo name
        --pages-branch            The repo pages branch
    -n, --install-dir             The Path to install the cr tool
    -i, --install-only            Just install the cr tool
    -s, --skip-packaging          Skip the packaging step (run your own packaging before using the releaser)
        --skip-existing           Skip package upload if release exists
        --skip-upload             Skip package upload, just create the release. Not needed in case of OCI upload.
    -l, --mark-as-latest          Mark the created GitHub release as 'latest' (default: true)
        --packages-with-index     Upload chart packages directly into publishing branch
        --use-arm                 Use ARM64 binary (default: false)
EOF
}

main() {
    local version="$DEFAULT_CHART_RELEASER_VERSION"
    local config=
    local charts_dir=charts
    local owner=
    local repo=
    local install_dir=
    local install_only=
    local skip_packaging=
    local skip_existing=
    local skip_upload=
    local mark_as_latest=true
    local packages_with_index=false
    local pages_branch=
    local use_arm=false

    parse_command_line "$@"

    : "${CR_TOKEN:?Environment variable CR_TOKEN must be set}"

    local repo_root
    repo_root=$(git rev-parse --show-toplevel)
    pushd "$repo_root" >/dev/null

    if [[ -z "$skip_packaging" ]]; then
        echo 'Looking up latest tag...'
        local latest_tag
        latest_tag=$(lookup_latest_tag)

        echo "Discovering changed charts since '$latest_tag'..."
        local changed_charts=()
        readarray -t changed_charts <<<"$(lookup_changed_charts "$latest_tag")"

        if [[ -n "${changed_charts[*]}" ]]; then
            install_chart_releaser

            rm -rf .cr-release-packages
            mkdir -p .cr-release-packages

            rm -rf .cr-index
            mkdir -p .cr-index

            for chart in "${changed_charts[@]}"; do
                if [[ -d "$chart" ]]; then
                    package_chart "$chart"
                else
                    echo "Nothing to do. No chart changes detected."
                fi
            done

            release_charts
            update_index
            echo "changed_charts=$(
                IFS=,
                echo "${changed_charts[*]}"
            )" >changed_charts.txt

            echo "chart_version=${latest_tag}" >chart_version.txt
        else
            echo "Nothing to do. No chart changes detected."
            echo "changed_charts=" >changed_charts.txt
            echo "chart_version=" >chart_version.txt
        fi
    else
        install_chart_releaser
        rm -rf .cr-index
        mkdir -p .cr-index
        release_charts
        update_index
    fi

    popd >/dev/null
}

parse_command_line() {
    while :; do
        case "${1:-}" in
        -h | --help)
            show_help
            exit
            ;;
        --config)
            if [[ -n "${2:-}" ]]; then
                config="$2"
                shift
            else
                echo "ERROR: '--config' cannot be empty." >&2
                show_help
                exit 1
            fi
            ;;
        -v | --version)
            if [[ -n "${2:-}" ]]; then
                version="$2"
                shift
            else
                echo "ERROR: '-v|--version' cannot be empty." >&2
                show_help
                exit 1
            fi
            ;;
        -d | --charts-dir)
            if [[ -n "${2:-}" ]]; then
                charts_dir="$2"
                shift
            else
                echo "ERROR: '-d|--charts-dir' cannot be empty." >&2
                show_help
                exit 1
            fi
            ;;
        -o | --owner)
            if [[ -n "${2:-}" ]]; then
                owner="$2"
                shift
            else
                echo "ERROR: '--owner' cannot be empty." >&2
                show_help
                exit 1
            fi
            ;;
        -r | --repo)
            if [[ -n "${2:-}" ]]; then
                repo="$2"
                shift
            else
                echo "ERROR: '--repo' cannot be empty." >&2
                show_help
                exit 1
            fi
            ;;
        --pages-branch)
            if [[ -n "${2:-}" ]]; then
                pages_branch="$2"
                shift
            fi
            ;;
        -n | --install-dir)
            if [[ -n "${2:-}" ]]; then
                install_dir="$2"
                shift
            fi
            ;;
        -i | --install-only)
            if [[ -n "${2:-}" ]]; then
                install_only="$2"
                shift
            fi
            ;;
        -s | --skip-packaging)
            if [[ -n "${2:-}" ]]; then
                skip_packaging="$2"
                shift
            fi
            ;;
        --skip-existing)
            if [[ -n "${2:-}" ]]; then
                skip_existing="$2"
                shift
            fi
            ;;
        --skip-upload)
            if [[ -n "${2:-}" ]]; then
                skip_upload="$2"
                shift
            fi
            ;;
        -l | --mark-as-latest)
            if [[ -n "${2:-}" ]]; then
                mark_as_latest="$2"
                shift
            fi
            ;;
        --packages-with-index)
            if [[ -n "${2:-}" ]]; then
                packages_with_index="$2"
                shift
            fi
            ;;
        --use-arm)
            if [[ -n "${2:-}" ]]; then
                use_arm="$2"
                shift
            fi
            ;;
        *)
            break
            ;;
        esac

        shift
    done

    if [[ -z "$owner" ]]; then
        echo "ERROR: '-o|--owner' is required." >&2
        show_help
        exit 1
    fi

    if [[ -z "$repo" ]]; then
        echo "ERROR: '-r|--repo' is required." >&2
        show_help
        exit 1
    fi

    if [[ -z "$install_dir" ]]; then
        local arch
        arch=$(uname -m)
        install_dir="$RUNNER_TOOL_CACHE/cr/$version/$arch"
    fi

    if [[ -n "$install_only" ]]; then
        echo "Will install cr tool and not run it..."
        install_chart_releaser
        exit 0
    fi
}

install_chart_releaser() {
    if [[ ! -d "$RUNNER_TOOL_CACHE" ]]; then
        echo "Cache directory '$RUNNER_TOOL_CACHE' does not exist" >&2
        exit 1
    fi

    if [[ ! -d "$install_dir" ]]; then
        mkdir -p "$install_dir"
        architecture=linux_amd64
        if [[ "$use_arm" = true ]]; then
            architecture=linux_arm64
        fi
        echo "Installing chart-releaser on $install_dir..."

        git clone https://github.com/helm/chart-releaser
        pushd chart-releaser
        go mod download
        go install ./...
        popd
        cp /home/runner/go/bin/cr $install_dir/cr
    fi

    echo 'Adding cr directory to PATH...'
    export PATH="$install_dir:$PATH"
}

lookup_latest_tag() {
    git fetch --tags

    # Find if there are any tags in the repo, if there are then use the latest one.
    if git tag -l --sort=-creatordate | head -n 1 >/dev/null; then
        git tag -l --sort=-creatordate | head -n 1
    elif ! git describe --tags --abbrev=0 HEAD~; then
        git rev-list --max-parents=0 --first-parent HEAD
    fi
}

filter_charts() {
    while read -r chart; do
        [[ ! -d "$chart" ]] && continue
        local file="$chart/Chart.yaml"
        if [[ -f "$file" ]]; then
            echo "$chart"
        else
            echo "WARNING: $file is missing, assuming that '$chart' is not a Helm chart. Skipping." 1>&2
        fi
    done
}

lookup_changed_charts() {
    local commit="$1"

    local changed_files
    changed_files=$(git diff --find-renames --name-only "$commit" -- "$charts_dir")

    local depth=$(($(tr "/" "\n" <<<"$charts_dir" | sed '/^\(\.\)*$/d' | wc -l) + 1))
    local fields="1-${depth}"

    cut -d '/' -f "$fields" <<<"$changed_files" | uniq | filter_charts
}

package_chart() {
    local chart="$1"

    local args=("$chart" --package-path .cr-release-packages)
    if [[ -n "$config" ]]; then
        args+=(--config "$config")
    fi

    echo "Packaging chart '$chart'..."
    cr package "${args[@]}"
}

release_charts() {
    local args=(-o "$owner" -r "$repo" -c "$(git rev-parse HEAD)")
    if [[ -n "$config" ]]; then
        args+=(--config "$config")
    fi
    if [[ "$packages_with_index" = true ]]; then
        args+=(--packages-with-index --push --skip-existing)
    elif [[ -n "$skip_existing" ]]; then
        args+=(--skip-existing)
    fi
    if [[ "$mark_as_latest" = false ]]; then
        args+=(--make-release-latest=false)
    fi
    if [[ -n "$pages_branch" ]]; then
        args+=(--pages-branch "$pages_branch")
    fi

    echo 'Releasing charts...'
    cr upload "${args[@]}"
}

update_index() {
    if [[ -n "$skip_upload" ]]; then
        echo "Skipping index upload..."
        return
    fi

    local args=(-o "$owner" -r "$repo" --push)
    if [[ -n "$config" ]]; then
        args+=(--config "$config")
    fi
    if [[ "$packages_with_index" = true ]]; then
        args+=(--packages-with-index --index-path .)
    fi
    if [[ -n "$pages_branch" ]]; then
        args+=(--pages-branch "$pages_branch")
    fi

    echo 'Updating charts repo index...'
    cr index "${args[@]}"
}

main "$@"

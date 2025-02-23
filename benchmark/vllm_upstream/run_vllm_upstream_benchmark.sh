#!/usr/bin/env bash

set -euo pipefail

# Check if the DEBUG env var is set to true
if [ "${DEBUG:-false}" = "true" ]; then
  set -x
fi

function ensure_sharegpt_downloaded() {
  FILE=$(basename $SHARE_GPT_FILE)
  if [ ! -f "$SHARE_GPT_FILE" ]; then
    curl -L -o $SHARE_GPT_FILE https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/$FILE
  else
    echo "$FILE already exists."
  fi
}

function check_hf_token() {
  # check if HF_TOKEN is available and valid
  if [[ -z "$HF_TOKEN" ]]; then
    echo "Error: HF_TOKEN is not set."
    exit 1
  elif [[ ! "$HF_TOKEN" =~ ^hf_ ]]; then
    echo "Error: HF_TOKEN does not start with 'hf_'."
    exit 1
  else
    echo "HF_TOKEN is set and valid."
  fi
}

function download_benchmark_src() {
  if [ -d "$VLLM_CODE" ]; then
    echo "VLLM code already exists."
    return
  fi

  TMP_DIR=$(mktemp -d)
  pushd $TMP_DIR
  curl -LO "https://github.com/vllm-project/vllm/releases/download/v${VLLM_VERSION}/vllm-${VLLM_VERSION}.tar.gz"
  tar -xvzf "vllm-${VLLM_VERSION}.tar.gz"
  rm "vllm-${VLLM_VERSION}.tar.gz"
  mv vllm-* $VLLM_CODE
  popd
  rm -rf $TMP_DIR
}

function install_dependencies() {
  (which jq) || (apt-get update && apt-get -y install jq)
  pip install tabulate pandas datasets
}

function run_serving_tests() {
  test_name="serving_llama70B_tp2_pp2_sharegpt"
  qps_list=(1 4 16 inf)
  echo "Running over qps list $qps_list"

  # iterate over different QPS
  for qps in "${qps_list[@]}"; do
    new_test_name=$test_name"_qps_"$qps

    pushd $VLLM_BENCHMARK_CODE
    client_command="python3 benchmark_serving.py \
        --save-result \
        --base-url ${TEST_SERVER_URL} \
        --result-dir ${RESULTS_FOLDER} \
        --result-filename ${new_test_name}.json \
        --request-rate $qps \
        --model=${MODEL_NAME} \
        --backend=vllm \
        --dataset-name=sharegpt \
        --dataset-path=${SHARE_GPT_FILE} \
        --num-prompts=200"

    echo "Running test case $test_name with qps $qps"
    echo "Client command: $client_command"

    bash -c "$client_command"
    popd

    # record the benchmarking commands
    jq_output=$(jq -n \
      --arg client "$client_command" \
      '{
          client_command: $client,
        }')
    echo "$jq_output" >"$RESULTS_FOLDER/${new_test_name}.commands"

  done

}

VLLM_CODE="/root/vllm"
VLLM_BENCHMARK_CODE="${VLLM_CODE}/benchmarks"
QUICK_BENCHMARK_ROOT="${VLLM_CODE}/.buildkite/nightly-benchmarks/"
SHARE_GPT_FILE="/root/ShareGPT_V3_unfiltered_cleaned_split.json"

RESULTS_FOLDER="/root/results/"
mkdir -p $RESULTS_FOLDER

# prepare for benchmarking
check_hf_token
ensure_sharegpt_downloaded
download_benchmark_src
install_dependencies

# benchmarking
run_serving_tests

python3 $QUICK_BENCHMARK_ROOT/scripts/convert-results-json-to-markdown.py

#!/usr/bin/env bash

set -euo pipefail
set -x

GOLANG_VERSION="1.23.4"
KIND_VERSION="v0.26.0"
K8S_VERSION="v1.33"
export DEBIAN_FRONTEND=noninteractive

function install_prereq_packages() {
    sudo apt update || true
    sudo apt install -y \
        jq bat hwinfo ubuntu-drivers-common \
        make apt-transport-https \
        ca-certificates curl gnupg net-tools nload

    pushd $(mktemp -d)
    curl -LO https://raw.githubusercontent.com/surajssd/dotfiles/refs/heads/master/local-bin/pullgo.sh
    chmod +x ./pullgo.sh
    sudo mv pullgo.sh /usr/local/bin/pullgo.sh
    pullgo.sh "${GOLANG_VERSION}"
    popd
}

function install_docker() {
    # Install Docker
    # Instructions inspired from: https://docs.docker.com/engine/install/ubuntu/

    # Add Docker's official GPG key:
    sudo apt-get update || true
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update || true

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo docker run hello-world
    sudo usermod -aG docker $USER
}

function install_kind() {
    # Install Kind
    # Instructions inspired from: https://kind.sigs.k8s.io/docs/user/quick-start/#installation

    # For AMD64 / x86_64
    pushd $(mktemp -d)
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    popd
}

function install_kube_binaries() {
    # Install kubectl
    # Instructions inspired from: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management

    # If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/Release.key" | sudo gpg --dearmor | sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.gpg >/dev/null
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

    # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list # helps tools such as command-not-found to work correctly

    sudo apt-get update || true
    sudo apt-get install -y kubelet kubeadm kubectl
}

function install_helm() {
    # Install Helm
    # Instructions inspired from: https://helm.sh/docs/intro/install/#from-apt-debianubuntu

    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg >/dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update || true
    sudo apt-get install -y helm
}

function install_nvidia_toolkit() {
    # Installing the NVIDIA Container Toolkit
    # Instructions inspired from: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg >/dev/null &&
        curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update || true
    sudo apt-get install -y nvidia-container-toolkit

    sudo nvidia-ctk runtime configure --runtime=docker --set-as-default --cdi.enabled
    sudo nvidia-ctk config --set accept-nvidia-visible-devices-as-volume-mounts=true --in-place
    sudo systemctl restart docker

    sudo docker run -v /dev/null:/var/run/nvidia-container-devices/all ubuntu:20.04 nvidia-smi -L
}

function install_nvkind() {
    pushd ${HOME}
    [ -d nvkind ] || git clone https://github.com/NVIDIA/nvkind
    pushd nvkind
    export PATH="$PATH:/usr/local/go/bin/"
    make
    sudo cp ./nvkind /usr/local/bin
    popd
    popd
}

function install_dotfiles() {
    pushd "${HOME}"
    [ -d dotfiles ] || git clone https://github.com/surajssd/dotfiles
    pushd dotfiles
    make install-all || true
    source ~/.bashrc || true
    update-git-prompt
    source ~/.bashrc || true
    popd
    popd
}

function check_driver_installation() {
    tail -f /var/log/azure/nvidia-vmext-status
}

PARAM="${1:-all}"
case $PARAM in
install_docker)
    install_docker
    ;;
install_kind)
    install_kind
    ;;
install_kube_binaries)
    install_kube_binaries
    ;;
install_helm)
    install_helm
    ;;
install_nvidia_toolkit)
    install_nvidia_toolkit
    ;;
install_nvkind)
    install_nvkind
    ;;
install_dotfiles)
    install_dotfiles
    ;;
install_prereq_packages)
    install_prereq_packages
    ;;
check_driver_installation)
    check_driver_installation
    ;;
all)
    install_prereq_packages
    install_docker
    install_kind
    install_kube_binaries
    install_helm
    install_nvidia_toolkit
    install_nvkind
    ;;
help)
    set +x
    echo "Usage: $0 [install_docker | install_kind | install_kube_binaries"
    echo " | install_helm | install_nvidia_toolkit | all"
    echo " | install_nvkind | install_dotfiles | help"
    echo " | install_prereq_packages | check_driver_installation ]"
    exit 0
    ;;
esac

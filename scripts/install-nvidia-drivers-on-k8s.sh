#!/usr/bin/env bash

set -euo pipefail
set -x

function install_gpu_operator() {

  kubectl create ns gpu-operator || true
  kubectl label --overwrite ns gpu-operator pod-security.kubernetes.io/enforce=privileged

  helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
  helm repo update

  helm upgrade -i \
    --wait \
    -n gpu-operator \
    --create-namespace \
    gpu-operator \
    nvidia/gpu-operator

  # Wait until the output of the command "cat foo" is empty
  while [ ! "$(kubectl get pods -n gpu-operator | grep Completed)" ]; do
    echo "Waiting for pods to be ready..."
    sleep 5
  done

  kubectl get nodes -o json | jq -r '.items[] | select(.metadata.name | test("-worker[0-9]*$")) | {name: .metadata.name, "nvidia.com/gpu": .status.allocatable["nvidia.com/gpu"]}'
}

install_gpu_operator

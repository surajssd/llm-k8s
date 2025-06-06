#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
NETWORK_OPERATOR_NS="network-operator"

function deploy_aks() {
    az group create \
        --name "${AZURE_RESOURCE_GROUP}" \
        --location "${AZURE_REGION}"

    az aks create \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --name "${CLUSTER_NAME}" \
        --enable-oidc-issuer \
        --enable-workload-identity \
        --enable-managed-identity \
        --node-count 1 \
        --location "${AZURE_REGION}" \
        --generate-ssh-keys \
        --admin-username "${USER_NAME}" \
        --os-sku Ubuntu
}

function add_nodepool() {
    aks_infiniband_support="az feature show \
        --namespace "Microsoft.ContainerService" \
        --name AKSInfinibandSupport -o tsv --query 'properties.state'"

    # Until the output of the above command is not "Registered", keep running the command.
    while [[ "$(eval $aks_infiniband_support)" != "Registered" ]]; do
        az feature register --name AKSInfinibandSupport --namespace Microsoft.ContainerService
        echo "⏳ Waiting for the feature 'AKSInfinibandSupport' to be registered..."
        sleep 10
    done

    az aks nodepool add \
        --name "${NODE_POOL_NAME}" \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --cluster-name "${CLUSTER_NAME}" \
        --node-count "${NODE_POOL_NODE_COUNT}" \
        --node-vm-size "${NODE_POOL_VM_SIZE}" \
        --node-osdisk-size "${NODE_POOL_VM_DISK_SIZE}" "$@"
}

function download_aks_credentials() {
    az aks get-credentials \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --name "${CLUSTER_NAME}" \
        --overwrite-existing
}

function install_grafana_dashboards() {
    DASHBOARD_DIR="${SCRIPT_DIR}/monitoring/dashboards"
    mkdir -p "${DASHBOARD_DIR}"
    pushd "${DASHBOARD_DIR}"

    # TODO: There are issues with loading the dashboards from the files.
    # The dashboards are not being loaded correctly.

    # Download vLLM dashboard
    [ -f vllm.json ] || curl -o vllm.json -L https://raw.githubusercontent.com/vllm-project/vllm/refs/heads/main/examples/online_serving/prometheus_grafana/grafana.json

    # Download Ray dashboards
    # More about the dashboards here:
    # https://github.com/ray-project/kuberay/tree/master/config/grafana
    # https://docs.ray.io/en/master/cluster/kubernetes/k8s-ecosystem/prometheus-grafana.html#kuberay-prometheus-grafana
    [ -f default_grafana_dashboard.json ] || curl -LO https://raw.githubusercontent.com/ray-project/kuberay/refs/heads/master/config/grafana/default_grafana_dashboard.json
    [ -f serve_grafana_dashboard.json ] || curl -LO https://raw.githubusercontent.com/ray-project/kuberay/refs/heads/master/config/grafana/serve_grafana_dashboard.json

    # Nvidia dashboards
    # https://github.com/NVIDIA/dcgm-exporter/tree/main/grafana
    [ -f dcgm-exporter-dashboard.json ] || curl -o dcgm-exporter-dashboard.json -L https://raw.githubusercontent.com/NVIDIA/dcgm-exporter/refs/heads/main/grafana/dcgm-exporter-dashboard.json

    # Iterate over the files in the directory and print them
    for file in $(ls); do
        # Removes the suffix of .json from the file name, converts the _ to - and makes it lowercase
        CM_NAME="$(echo "${file}" | sed 's/\.json//g' | tr '_' '-' | tr '[:upper:]' '[:lower:]')"
        kubectl -n monitoring create cm --dry-run=client -o yaml "${CM_NAME}" --from-file "${file}" | kubectl apply -f -
        kubectl -n monitoring label cm "${CM_NAME}" grafana_dashboard=1
    done

    popd
}

function install_kube_prometheus() {
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    kube_prometheus_install="helm upgrade -i \
        --wait \
        -n monitoring \
        --create-namespace \
        kube-prometheus \
        prometheus-community/kube-prometheus-stack \
        --set prometheus.prometheusSpec.maximumStartupDurationSeconds=60"

    # If you don't retry then it could fail with errors like:
    # Error: create: failed to create: Post "https://foobar.southcentralus.azmk8s.io:443/api/v1/namespaces/monitoring/secrets": remote error: tls: bad record MAC
    until ${kube_prometheus_install}; do
        echo "⏳ Waiting for kube-prometheus to be installed..."
        sleep 5
    done

    kubectl apply -f ${SCRIPT_DIR}/monitoring/rbac.yaml
    install_grafana_dashboards
}

function install_gpu_operator() {
    gpu_operator_ns="gpu-operator"
    kubectl create ns "${gpu_operator_ns}" || true
    kubectl label --overwrite ns "${gpu_operator_ns}" pod-security.kubernetes.io/enforce=privileged

    helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
    helm repo update

    # See if NFD is already deployed. This means that the network operator was deployed before.
    NFD_PODS_COUNT="$(kubectl get pods \
        -A -l app.kubernetes.io/name=node-feature-discovery \
        --no-headers | wc -l)"

    HELM_CHART_FLAGS=""
    if [[ "${NFD_PODS_COUNT}" -gt 0 ]]; then
        HELM_CHART_FLAGS="--set nfd.enabled=false --set driver.rdma.enabled=true"
    fi

    # Find latest version of the GPU operator: https://github.com/NVIDIA/gpu-operator/releases
    helm upgrade -i \
        --wait \
        -n "${gpu_operator_ns}" \
        --create-namespace \
        gpu-operator \
        nvidia/gpu-operator \
        --set dcgmExporter.serviceMonitor.enabled="true" ${HELM_CHART_FLAGS}

    cuda_validator_label="app=nvidia-cuda-validator"

    echo "⏳ Waiting for all pods with label $cuda_validator_label in namespace $gpu_operator_ns to complete..."
    while true; do
        pods_json=$(kubectl get pods -n "$gpu_operator_ns" -l "$cuda_validator_label" -o json)

        total=$(echo "${pods_json}" | jq '.items | length')
        succeeded=$(echo "${pods_json}" | jq '[.items[] | select(.status.phase == "Succeeded")] | length')

        if [ "${total}" -eq "${succeeded}" ] && [ "${total}" -ne 0 ]; then
            echo "✅ All ${total} pods have completed successfully."
            break
        else
            echo "⏳ Waiting for nvidia-cuda-validator, ${succeeded}/${total} pods completed..."
            sleep 5
        fi
    done

    echo -e '\n🤖 GPUs on nodes:\n'
    gpu_on_nodes_cmd="kubectl get nodes -o json | jq -r '.items[] | {name: .metadata.name, \"nvidia.com/gpu\": .status.allocatable[\"nvidia.com/gpu\"]}'"
    echo "$ ${gpu_on_nodes_cmd}"
    eval "${gpu_on_nodes_cmd}"
}

function install_network_operator() {
    kubectl create ns "${NETWORK_OPERATOR_NS}" || true
    kubectl label --overwrite ns "${NETWORK_OPERATOR_NS}" pod-security.kubernetes.io/enforce=privileged

    helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
    helm repo update

    # Find latest version of network operator: https://github.com/Mellanox/network-operator/releases
    helm upgrade -i \
        --wait \
        --create-namespace \
        -n "${NETWORK_OPERATOR_NS}" \
        network-operator \
        nvidia/network-operator \
        --set nfd.deployNodeFeatureRules=false

    kubectl apply -f ${SCRIPT_DIR}/network-operator/nfd-rule.yaml

    # Generated by running the following command:
    # kustomize build "https://github.com/Azure/aks-rdma-infiniband/configs/nicclusterpolicy/rdma-shared-device-plugin?ref=0a6f526966bfdbcfcb2876f354d658e67834a92b"
    kubectl apply -f ${SCRIPT_DIR}/network-operator/nic-cluster-policy.yaml
    wait_until_mofed_is_ready
    wait_until_rdma_is_ready
}

function wait_until_mofed_is_ready() {
    mofed_label="nvidia.com/ofed-driver"

    # Wait until the number of nodes with label 'network.nvidia.com/operator.mofed.wait: "false"' is equal to the number of mofed pods.
    while true; do
        # Get the mofed pod count
        mofed_pods_count="$(kubectl get pods \
            -n ${NETWORK_OPERATOR_NS} \
            -l ${mofed_label} \
            --no-headers | wc -l)"

        # Get the number of nodes with label 'network.nvidia.com/operator.mofed.wait: "false"'
        nodes_with_mofed_wait_false="$(kubectl get nodes \
            -l "network.nvidia.com/operator.mofed.wait=false" \
            --no-headers | wc -l)"

        if [[ "${mofed_pods_count}" -gt 0 && "${mofed_pods_count}" -eq "${nodes_with_mofed_wait_false}" ]]; then
            echo "✅ MOFED driver is successfully installed on all nodes."
            break
        fi

        [[ "${mofed_pods_count}" -eq 0 ]] && echo "⏳ Waiting for mofed pods to show up..."
        echo "⏳ Waiting for all nodes to be labeled 'network.nvidia.com/operator.mofed.wait=false' ..."
        sleep 2
    done
}

function wait_until_rdma_is_ready() {
    rdma_label="app=rdma-shared-dp"

    echo "⏳ Waiting for all rdma-shared-dp pods in namespace ${NETWORK_OPERATOR_NS} to be in 'Running' phase..."

    while true; do
        pods_json=$(kubectl get pods -n "${NETWORK_OPERATOR_NS}" -l "${rdma_label}" -o json)

        total=$(echo "${pods_json}" | jq '.items | length')
        running=$(echo "${pods_json}" | jq '[.items[] | select(.status.phase == "Running")] | length')

        if [ "${total}" -eq "${running}" ] && [ "${total}" -ne 0 ]; then
            echo "✅ All rdma-shared-dp ${total} pods are in 'Running' state."
            break
        else
            echo "⏳ Waiting for rdma-shared-dp, ${running}/${total} pods running..."
            sleep 5
        fi
    done

    echo -e '\nRDMA Shared IB devices on nodes:\n'
    rdma_ib_on_nodes_cmd="kubectl get nodes -o json | jq -r '.items[] | {name: .metadata.name, \"rdma/shared_ib\": .status.allocatable[\"rdma/shared_ib\"]}'"
    echo "$ ${rdma_ib_on_nodes_cmd}"
    eval "${rdma_ib_on_nodes_cmd}"
}

function install_lws_controller() {
    # Find the latest version here: https://github.com/kubernetes-sigs/lws/releases
    VERSION=v0.6.0
    kubectl apply --server-side -f https://github.com/kubernetes-sigs/lws/releases/download/$VERSION/manifests.yaml

}

PARAM="${1:-all}"
case $PARAM in
deploy_aks)
    deploy_aks
    ;;
add_nodepool)
    add_nodepool "${@:2}"
    ;;
download_aks_credentials)
    download_aks_credentials
    ;;
install_kube_prometheus)
    install_kube_prometheus
    ;;
install_gpu_operator)
    install_gpu_operator
    ;;
install_network_operator)
    install_network_operator
    ;;
install_lws_controller)
    install_lws_controller
    ;;
all)
    deploy_aks
    download_aks_credentials
    add_nodepool --gpu-driver=none
    install_kube_prometheus
    install_lws_controller

    # Install prometheus stack before installing GPU operator, as GPU operator
    # also installs service monitors CR and those are only available after
    # prometheus stack is installed.
    install_gpu_operator
    ;;
# Show help when using help or -h or --help
help | -h | --help)
    echo "Usage: $0 [deploy_aks|add_nodepool|download_aks_credentials|install_kube_prometheus|install_gpu_operator|install_network_operator|install_lws_controller|all|help]"
    ;;
esac

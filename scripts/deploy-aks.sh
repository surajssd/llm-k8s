#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

function deploy_aks() {
    az group create \
        --name "${AZURE_RESOURCE_GROUP}" \
        --location "${AZURE_REGION}"

    az extension add --name aks-preview || true
    az extension update --name aks-preview || true

    az aks create \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --node-resource-group "${AKS_RG}" \
        --name "${CLUSTER_NAME}" \
        --enable-oidc-issuer \
        --enable-workload-identity \
        --enable-managed-identity \
        --node-count 1 \
        --location "${AZURE_REGION}" \
        --ssh-key-value "${SSH_KEY}" \
        --admin-username "${USER_NAME}" \
        --os-sku Ubuntu
}

function add_nodepool() {
    az aks nodepool add \
        --name "${GPU_NODE_POOL_NAME}" \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --cluster-name "${CLUSTER_NAME}" \
        --node-count "${GPU_NODE_COUNT}" \
        --node-vm-size "${VM_SIZE}" \
        --skip-gpu-driver-install \
        --node-osdisk-size "${VM_DISK_SIZE}"
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

    # Download vLLM dashboard
    [ -f vllm.json ] || curl -o vllm.json -L https://raw.githubusercontent.com/vllm-project/vllm/refs/heads/main/examples/online_serving/prometheus_grafana/grafana.json

    # Download Ray dashboards
    # More about the dashboards here:
    # https://github.com/ray-project/kuberay/tree/master/config/grafana
    # https://docs.ray.io/en/master/cluster/kubernetes/k8s-ecosystem/prometheus-grafana.html#kuberay-prometheus-grafana
    [ -f data_grafana_dashboard.json ] || curl -LO https://raw.githubusercontent.com/ray-project/kuberay/refs/heads/master/config/grafana/data_grafana_dashboard.json
    [ -f default_grafana_dashboard.json ] || curl -LO https://raw.githubusercontent.com/ray-project/kuberay/refs/heads/master/config/grafana/default_grafana_dashboard.json
    [ -f serve_deployment_grafana_dashboard.json ] || curl -LO https://raw.githubusercontent.com/ray-project/kuberay/refs/heads/master/config/grafana/serve_deployment_grafana_dashboard.json
    [ -f serve_grafana_dashboard.json ] || curl -LO https://raw.githubusercontent.com/ray-project/kuberay/refs/heads/master/config/grafana/serve_grafana_dashboard.json

    # Nvidia dashboards
    # https://grafana.com/grafana/dashboards/12239-nvidia-dcgm-exporter-dashboard/
    [ -f nvidia-dcgm-exporter-dashboard.json ] || curl -o nvidia-dcgm-exporter-dashboard.json -L https://grafana.com/api/dashboards/12239/revisions/2/download
    # https://grafana.com/grafana/dashboards/15117-nvidia-dcgm-exporter/
    [ -f nvidia-dcgm-exporter.json ] || curl -o nvidia-dcgm-exporter.json -L https://grafana.com/api/dashboards/15117/revisions/2/download

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
    helm upgrade -i \
        --wait \
        -n monitoring \
        --create-namespace \
        kube-prometheus \
        prometheus-community/kube-prometheus-stack

    kubectl apply -f ${SCRIPT_DIR}/monitoring/rbac.yaml
    install_grafana_dashboards
}

function install_gpu_operator() {
    kubectl create ns gpu-operator || true
    kubectl label --overwrite ns gpu-operator pod-security.kubernetes.io/enforce=privileged

    helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
    helm repo update

    # See if NFD is already deployed. This means that the network operator was deployed before.
    NFD_PODS_COUNT="$(kubectl get pods \
        -A -l app.kubernetes.io/name=node-feature-discovery \
        --no-headers | wc -l)"

    HELM_CHART_FLAGS=""
    if [[ "${NFD_PODS_COUNT}" -gt 0 ]]; then
        HELM_CHART_FLAGS="--set nfd.enabled=false"
    fi

    helm upgrade -i \
        --wait \
        -n gpu-operator \
        --create-namespace \
        gpu-operator \
        nvidia/gpu-operator \
        --set dcgmExporter.serviceMonitor.enabled="true" ${HELM_CHART_FLAGS}

    # Wait until the output of the command "cat foo" is empty
    while [ ! "$(kubectl get pods -n gpu-operator | grep Completed)" ]; do
        echo "Waiting for pods to be ready..."
        sleep 5
    done

    echo -e '\nGPUs on nodes:\n'
    gpu_on_nodes_cmd="kubectl get nodes -o json | jq -r '.items[] | {name: .metadata.name, \"nvidia.com/gpu\": .status.allocatable[\"nvidia.com/gpu\"]}'"
    echo "$ ${gpu_on_nodes_cmd}"
    eval "${gpu_on_nodes_cmd}"
}

function install_network_operator() {
    helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
    helm repo update

    helm upgrade -i \
        --wait \
        --create-namespace \
        -n network-operator \
        network-operator \
        nvidia/network-operator \
        --set nfd.deployNodeFeatureRules=false

    kubectl apply -f ${SCRIPT_DIR}/network-operator/nfd-rule.yaml
    kubectl apply -f ${SCRIPT_DIR}/network-operator/nic-cluster-policy.yaml

    # Wait for the mofed pods to be ready
    NET_OP_NS="network-operator"
    MOFED_LABEL="nvidia.com/ofed-driver"

    # Wait until any MOFED pods show up.
    while true; do
        MOFED_PODS_COUNT="$(kubectl get pods \
            -n "${NET_OP_NS}" \
            -l "${MOFED_LABEL}" \
            --no-headers | wc -l)"
        if [[ "${MOFED_PODS_COUNT}" -gt 0 ]]; then
            break
        fi

        echo "Waiting for mofed pods to show up..."
        sleep 2
    done

    echo "Waiting for all mofed pods in namespace '${NET_OP_NS}' are ready (this may take 10 mins)..."
    while true; do
        MOFED_PODS_IN_READY_STATE="$(kubectl get pods \
            -n "${NET_OP_NS}" \
            -l "${MOFED_LABEL}" \
            -o jsonpath='{range .items[*]}{.status.containerStatuses[*].ready}{" "}{end}' | tr ' ' '\n' | grep -c true || true)"
        MOFED_PODS_IN_READY_STATE="${MOFED_PODS_IN_READY_STATE:-0}"

        MOFED_PODS_COUNT_NEEDED="$(kubectl get pods \
            -n "${NET_OP_NS}" \
            -l "${MOFED_LABEL}" \
            --no-headers | wc -l)"

        if [[ "${MOFED_PODS_IN_READY_STATE}" -eq "${MOFED_PODS_COUNT_NEEDED}" ]]; then
            sleep 15
            break
        fi

        echo "Not all mofed pods are ready yet... retrying in 5s (this may take 10 mins)"
        kubectl get pods -n "$NET_OP_NS" -l "${MOFED_LABEL}" -o wide
        sleep 5
    done

    NET_OP_RDMA_DS="rdma-shared-dp-ds"
    echo "Waiting for DaemonSet '${NET_OP_RDMA_DS}' in namespace '${NET_OP_NS}' to be fully ready..."
    kubectl -n ${NET_OP_NS} \
        wait --timeout=300s \
        --for=jsonpath='{.status.numberReady}'="$(kubectl -n ${NET_OP_NS} \
            get daemonset $NET_OP_RDMA_DS \
            -o jsonpath='{.status.desiredNumberScheduled}')" \
        "daemonset/${NET_OP_RDMA_DS}"

    kubectl apply -f ${SCRIPT_DIR}/network-operator/ipoib-network.yaml

    # Show the RDMA resources on the nodes
    rdma_on_nodes_cmd="kubectl get nodes -o json | jq -r '.items[] | {name: .metadata.name, \"capacity - rdma/rdma_shared_device_a\": .status.capacity.\"rdma/rdma_shared_device_a\", \"allocatable - rdma/rdma_shared_device_a\": .status.allocatable.\"rdma/rdma_shared_device_a\"}'"
    echo "$ ${rdma_on_nodes_cmd}"
    eval "${rdma_on_nodes_cmd}"
}

function install_lws_controller() {
    # Find the latest version here: https://github.com/kubernetes-sigs/lws/releases
    VERSION=v0.5.1
    kubectl apply --server-side -f https://github.com/kubernetes-sigs/lws/releases/download/$VERSION/manifests.yaml

}

PARAM="${1:-all}"
case $PARAM in
deploy_aks)
    deploy_aks
    ;;
add_nodepool)
    add_nodepool
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
    add_nodepool
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

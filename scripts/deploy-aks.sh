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
    az feature register --namespace 'Microsoft.ContainerService' --name 'GPUDedicatedVHDPreview' || true

    # Wait until the output of the following command is "Registered"
    cmd="az feature show \
        --namespace "Microsoft.ContainerService" \
        --name "GPUDedicatedVHDPreview" \
        -o tsv \
        --query='properties.state'"
    count=0
    while [ "$(eval ${cmd})" != "Registered" ]; do
        if [ $count -gt 10 ]; then
            echo "Feature registration timed out"
            break
        fi

        echo "Waiting for feature to be registered..."
        sleep 5

        # Increase the counter
        count=$((count + 1))
    done

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

function install_kube_prometheus() {
    [ -f kube-prometheus.zip ] || curl -o kube-prometheus.zip -L https://github.com/prometheus-operator/kube-prometheus/archive/main.zip
    [ -d kube-prometheus-main ] || unzip kube-prometheus.zip

    pushd kube-prometheus-main
    # Create the namespace and CRDs, and then wait for them to be available before creating the remaining resources
    kubectl create -f manifests/setup || true

    # Wait until the "servicemonitors" CRD is created. The message "No resources found" means success in this context.
    until kubectl get servicemonitors --all-namespaces; do
        date
        sleep 1
        echo ""
    done

    kubectl create -f manifests/ || true
    popd

    kubectl apply -f ${SCRIPT_DIR}/monitoring/rbac.yaml

}

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
        nvidia/gpu-operator \
        --set dcgmExporter.serviceMonitor.enabled="true"

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

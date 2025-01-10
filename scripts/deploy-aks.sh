#!/usr/bin/env bash

set -euo pipefail

function deploy_aks() {
    az group create \
        --name "${AZURE_RESOURCE_GROUP}" \
        --location "${AZURE_REGION}"

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
    az extension add --name aks-preview || true
    az extension update --name aks-preview || true
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
all)
    deploy_aks
    add_nodepool
    download_aks_credentials
    ;;
# Show help when using help or -h or --help
help | -h | --help)
    echo "Usage: $0 [deploy_aks|add_nodepool|download_aks_credentials|all|help]"
    ;;
esac

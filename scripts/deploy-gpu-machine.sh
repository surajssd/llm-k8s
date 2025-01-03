#!/usr/bin/env bash

set -euo pipefail

function deploy_vm() {
    az group create \
        --name "${AZURE_RESOURCE_GROUP}" \
        --location "${AZURE_REGION}"

    az vm create \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --size "${VM_SIZE}" \
        --name "${VM_NAME}" \
        --location "${AZURE_REGION}" \
        --admin-username "${USER_NAME}" \
        --ssh-key-values "${SSH_KEY}" \
        --authentication-type ssh \
        --image "${VM_IMAGE}" \
        --public-ip-address-dns-name "${VM_NAME}" \
        --os-disk-size-gb "${VM_DISK_SIZE}" \
        --security-type standard
}

function install_gpu_driver() {
    az vm extension set \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --vm-name "${VM_NAME}" \
        --name NvidiaGpuDriverLinux \
        --publisher Microsoft.HpcCompute \
        --settings '{ \
            "updateOS": "true" \
        }'
}

function ssh_direct() {
    exec ssh -i ${SSH_KEY%.pub} ${USER_NAME}@${VM_NAME}.${AZURE_REGION}.cloudapp.azure.com
}

function ssh_tailscale() {
    exec ssh -i ${SSH_KEY%.pub} "${USER_NAME}@${VM_NAME}.tail63200.ts.net"
}

function port_forward_tailscale() {
    ssh -L $1:localhost:$1 -i ${SSH_KEY%.pub} "${USER_NAME}@${VM_NAME}.tail63200.ts.net"
}

function install_tailscale() {
    ssh -oStrictHostKeyChecking=no -i ${SSH_KEY%.pub} ${USER_NAME}@${VM_NAME}.${AZURE_REGION}.cloudapp.azure.com <<EOF
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
logout
EOF
}

PARAM="${1:-all}"

set -x

case $PARAM in
deploy_vm)
    deploy_vm
    ;;
install_gpu_driver)
    install_gpu_driver
    ;;
ssh)
    ssh_direct
    ;;
ssh_tailscale)
    ssh_tailscale
    ;;
install_tailscale)
    install_tailscale
    ;;
all)
    deploy_vm
    install_gpu_driver
    ;;
all_tailscale)
    deploy_vm
    install_tailscale
    install_gpu_driver
    ;;
port_forward_tailscale)
    port_forward_tailscale $2
    ;;
help)
    set +x
    echo "Usage: $0 [deploy_vm | install_gpu_driver | install_tailscale"
    echo "| ssh | ssh_tailscale | port_forward_tailscale"
    echo "| all | all_tailscale | help]"
    ;;
esac

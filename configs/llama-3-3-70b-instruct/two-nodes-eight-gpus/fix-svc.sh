#!/usr/bin/env bash

set -euo pipefail

LWS_NAME="llama-3-3-70b-instruct"
LWS_LEADER_CMD="kubectl -n default get pods -l leaderworkerset.sigs.k8s.io/name=${LWS_NAME} -l role=leader"
while true; do
    TERMINATING_PODS=$(eval $LWS_LEADER_CMD | grep Terminating) || true
    if [ -z "$TERMINATING_PODS" ]; then
        echo "All Terminating pods have been removed."
        break
    fi

    echo "Waiting for the Terminating pods to be removed..."
    sleep 5
done

# Get the Infiniband IP address of the leader pod
IB_IP_CMD="${LWS_LEADER_CMD} -o json | jq -r '.items[0].metadata.annotations.\"k8s.v1.cni.cncf.io/network-status\" | fromjson | .[0].ips[0]'"
while true; do
    IB_IP=$(eval $IB_IP_CMD) || true
    if [ -n "$IB_IP" ]; then
        echo "Infiniband IP address: $IB_IP"
        break
    fi

    echo "Waiting for the Infiniband IP address to be assigned to the head pod..."
    sleep 5
done

# The patch should only proceed if there is a field subsets in the ep
# The headless service is created with same name as the LWS. Hence there is an EP with the same name as service.
SUBSETS_CMD="kubectl -n default get ep ${LWS_NAME} -o jsonpath='{.subsets}'"
while true; do
    SUBSETS=$(eval $SUBSETS_CMD) || true
    if [ -n "$SUBSETS" ]; then
        echo "The subsets field is available in the endpoint."
        break
    fi

    echo "Waiting for the subsets field to be available in the endpoint..."
    sleep 5
done

# Disable failing on error
set +e

# Patch the Service to use the Infiniband IP address
LEADER_POD_NAME="${LWS_NAME}-0"
EP_JSON_CMD="kubectl get endpoints ${LWS_NAME} -n default -o json"

# Trying multiple time to patch the EP, so that any updates to the EP by
# kubernetes api-server are not lost.
while true; do
    # Count how many LWS created STS are "not ready" (availableReplicas != replicas).
    # Once the pods become ready the EP will be updated again!
    not_ready=$(
        kubectl get sts -l leaderworkerset.sigs.k8s.io/name=${LWS_NAME} -o json | jq \
            '[.items[] | select(.status.availableReplicas != .status.replicas)] | length'
    )

    $EP_JSON_CMD | jq --arg host "$LEADER_POD_NAME" --arg ip "$IB_IP" '
  (
    .subsets[]?.addresses[]?
    | select(.hostname == $host)
  ).ip = $ip
' | kubectl apply -f - || not_ready=1

    $EP_JSON_CMD | jq --arg host "$LEADER_POD_NAME" --arg ip "$IB_IP" '
  (
    .subsets[]?.notReadyAddresses[]?
    | select(.hostname == $host)
  ).ip = $ip
' | kubectl apply -f - || not_ready=1

    if [[ "$not_ready" -eq 0 ]]; then
        echo "All StatefulSets are ready!"
        break
    fi

    echo "Some StatefulSets are not yet ready. Patching the EP again in 5s..."
    sleep 5
done

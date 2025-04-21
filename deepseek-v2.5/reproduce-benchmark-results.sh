# Benchmarking that actually spans on two machines.

# Scenario 1: Without IB
source .env
export NODE_POOL_VM_SIZE="Standard_ND96asr_v4"
export NODE_POOL_NODE_COUNT=2
export AZURE_REGION=southcentralus

# Step 1: Deploy the Infra
./scripts/deploy-aks.sh deploy_aks
./scripts/deploy-aks.sh download_aks_credentials
./scripts/deploy-aks.sh install_kube_prometheus
./scripts/deploy-aks.sh install_lws_controller
./scripts/deploy-aks.sh add_nodepool
./scripts/deploy-aks.sh install_gpu_operator

# Step 2: Deploy the model
# NOTE: Apply the diff at the bottom of this script
kubectl apply -f configs/deepseek-v2.5/k8s
kubectl port-forward svc/deepseek-v2-5-leader 8000
curl -X POST "http://localhost:8000/v1/chat/completions" \
    -H "Content-Type: application/json" \
    --data '{
  "model": "deepseek-ai/DeepSeek-V2.5",
  "messages": [
   {
    "role": "user",
    "content": "Explain the origin of Llama the animal?"
   }
  ]
 }' | jq

# Step 3: Deploy the benchmarking tool
kubectl create ns vllm-benchmark
kubectl -n vllm-benchmark create configmap benchmark-runner \
    --from-literal=TEST_SERVER_URL="http://deepseek-v2-5-leader.default:8000" \
    --from-literal=MODEL_NAME="deepseek-ai/DeepSeek-V2.5" \
    --from-literal=TENSOR_PARALLEL_SIZE=8 \
    --from-literal=PIPELINE_PARALLEL_SIZE=2 \
    --from-literal=GPU_VM_SKU="no-ib-${NODE_POOL_VM_SIZE}"
kubectl -n vllm-benchmark create secret generic hf-token-secret --from-literal token=${HF_TOKEN}
kubectl apply -f benchmark/vllm_upstream/k8s/
kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner

POD_NAME=$(kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner \
    --field-selector=status.phase=Running \
    -o jsonpath='{.items[].metadata.name}')

kubectl -n vllm-benchmark \
    exec -it $POD_NAME \
    -- bash /root/scripts/run_vllm_upstream_benchmark.sh

RESULTS_FILE=$(kubectl -n vllm-benchmark \
    exec -it $POD_NAME \
    -- bash -c "ls /root/results*.tar.gz" | tr -d '\r')

kubectl -n vllm-benchmark \
    cp "${POD_NAME}:${RESULTS_FILE}" "./$(basename ${RESULTS_FILE})"

# Clean up
kubectl delete ns vllm-benchmark
kubectl delete -f configs/llama-3-3-70b-instruct/one-node-four-gpus/k8s/

# -----------------------------------------------------------------
# Scenario 2: With IB

# Step 1: Deploy the Infra
./scripts/deploy-aks.sh install_network_operator
./scripts/deploy-aks.sh install_gpu_operator

# Step 2: Deploy the model
kubectl apply -f configs/deepseek-v2.5/k8s
kubectl port-forward svc/deepseek-v2-5-leader 8000
curl -X POST "http://localhost:8000/v1/chat/completions" \
    -H "Content-Type: application/json" \
    --data '{
  "model": "deepseek-ai/DeepSeek-V2.5",
  "messages": [
   {
    "role": "user",
    "content": "Explain the origin of Llama the animal?"
   }
  ]
 }' | jq

# Step 3: Deploy the benchmarking tool
kubectl create ns vllm-benchmark
kubectl -n vllm-benchmark create configmap benchmark-runner \
    --from-literal=TEST_SERVER_URL="http://deepseek-v2-5-leader.default:8000" \
    --from-literal=MODEL_NAME="deepseek-ai/DeepSeek-V2.5" \
    --from-literal=TENSOR_PARALLEL_SIZE=8 \
    --from-literal=PIPELINE_PARALLEL_SIZE=2 \
    --from-literal=GPU_VM_SKU="ib-${NODE_POOL_VM_SIZE}"
kubectl -n vllm-benchmark create secret generic hf-token-secret --from-literal token=${HF_TOKEN}
kubectl apply -f benchmark/vllm_upstream/k8s/
kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner

POD_NAME=$(kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner \
    --field-selector=status.phase=Running \
    -o jsonpath='{.items[].metadata.name}')

kubectl -n vllm-benchmark \
    exec -it $POD_NAME \
    -- bash /root/scripts/run_vllm_upstream_benchmark.sh

RESULTS_FILE=$(kubectl -n vllm-benchmark \
    exec -it $POD_NAME \
    -- bash -c "ls /root/results*.tar.gz" | tr -d '\r')

kubectl -n vllm-benchmark \
    cp "${POD_NAME}:${RESULTS_FILE}" "./$(basename ${RESULTS_FILE})"

# Clean up
kubectl delete ns vllm-benchmark

# -----------------------------------------------------------------

cat <<EOF | git apply
diff --git configs/deepseek-v2.5/k8s/lws.yaml configs/deepseek-v2.5/k8s/lws.yaml
index fce5e04..3bb0d7d 100644
--- configs/deepseek-v2.5/k8s/lws.yaml
+++ configs/deepseek-v2.5/k8s/lws.yaml
@@ -21,7 +21,6 @@ spec:
           - sh
           - -c
           - "set -x;
-            sleep inf;
             bash /vllm-workspace/examples/online_serving/multi-node-serving.sh leader
             --ray_cluster_size=$LWS_GROUP_SIZE
             --dashboard-host=0.0.0.0
@@ -38,10 +37,6 @@ spec:
           env:
           - name: NCCL_DEBUG
             value: INFO
-          - name: NCCL_NET_GDR_LEVEL
-            value: SYS
-          - name: NCCL_IB_DISABLE
-            value: "0"
           readinessProbe:
             httpGet:
               path: /health
@@ -61,13 +56,8 @@ spec:
           resources:
             limits:
               nvidia.com/gpu: "8"
-              rdma/shared_ib: 1
             requests:
               nvidia.com/gpu: "8"
-              rdma/shared_ib: 1
-          securityContext:
-            capabilities:
-              add: [ "IPC_LOCK" ]
           volumeMounts:
           - name: shm
             mountPath: /dev/shm
@@ -105,10 +95,6 @@ spec:
           env:
           - name: NCCL_DEBUG
             value: INFO
-          - name: NCCL_NET_GDR_LEVEL
-            value: SYS
-          - name: NCCL_IB_DISABLE
-            value: "0"
           ports:
           # VLLM port
           - containerPort: 8000
@@ -117,13 +103,8 @@ spec:
           resources:
             limits:
               nvidia.com/gpu: "8"
-              rdma/shared_ib: 1
             requests:
               nvidia.com/gpu: "8"
-              rdma/shared_ib: 1
-          securityContext:
-            capabilities:
-              add: [ "IPC_LOCK" ]
           volumeMounts:
           - name: shm
             mountPath: /dev/shm
EOF

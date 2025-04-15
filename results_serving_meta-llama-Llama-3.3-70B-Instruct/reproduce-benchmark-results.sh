# Benchmarking

# Scenario 1: Deploy Model on 1 Machine using deployment.
source .env
export NODE_POOL_VM_SIZE="Standard_ND96asr_v4"
export NODE_POOL_NODE_COUNT=1
export AZURE_REGION=southcentralus

# Step 1: Deploy the Infra
./scripts/deploy-aks.sh deploy_aks
./scripts/deploy-aks.sh download_aks_credentials
./scripts/deploy-aks.sh install_kube_prometheus
./scripts/deploy-aks.sh add_nodepool
./scripts/deploy-aks.sh install_gpu_operator

# Step 2: Deploy the model
export HF_TOKEN=""
kubectl create secret generic hf-token-secret --from-literal token=${HF_TOKEN}
kubectl apply -f configs/llama-3-3-70b-instruct/one-node-four-gpus/k8s/
kubectl port-forward svc/llama-3-3-70b-instruct 8000
curl -X POST "http://localhost:8000/v1/chat/completions" \
    -H "Content-Type: application/json" \
    --data '{
  "model": "meta-llama/Llama-3.3-70B-Instruct",
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
    --from-literal=TEST_SERVER_URL="http://llama-3-3-70b-instruct.default:8000" \
    --from-literal=MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct" \
    --from-literal=TENSOR_PARALLEL_SIZE=8 \
    --from-literal=PIPELINE_PARALLEL_SIZE="${NODE_POOL_NODE_COUNT}" \
    --from-literal=GPU_VM_SKU="${NODE_POOL_VM_SIZE}"
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

# Scenario 2: Deploy Model on 2 Machines using LWS but no IB

# Step 1: Deploy the Infra
./scripts/deploy-aks.sh install_lws_controller
az aks nodepool scale \
    --resource-group "${AZURE_RESOURCE_GROUP}" \
    --cluster-name "${CLUSTER_NAME}" \
    --name "${NODE_POOL_NAME}" \
    --node-count 2

# Step 2: Deploy the model
kubectl apply -f configs/llama-3-3-70b-instruct/two-nodes-eight-gpus/k8s/
kubectl port-forward svc/llama-3-3-70b-instruct-leader 8000
curl -X POST "http://localhost:8000/v1/chat/completions" \
    -H "Content-Type: application/json" \
    --data '{
  "model": "meta-llama/Llama-3.3-70B-Instruct",
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
    --from-literal=TEST_SERVER_URL="http://llama-3-3-70b-instruct-leader.default:8000" \
    --from-literal=MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct" \
    --from-literal=TENSOR_PARALLEL_SIZE=4 \
    --from-literal=PIPELINE_PARALLEL_SIZE=2 \
    --from-literal=GPU_VM_SKU="${NODE_POOL_VM_SIZE}"
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
kubectl delete -f configs/llama-3-3-70b-instruct/two-nodes-eight-gpus/k8s/
# -----------------------------------------------------------------
# Scenario 3: Deploy Model on 2 Machines using LWS with IB

# Step 1: Deploy the Infra
./scripts/deploy-aks.sh install_network_operator
./scripts/deploy-aks.sh install_gpu_operator

# Step 2: Deploy the model
kubectl apply -f configs/llama-3-3-70b-instruct/two-nodes-eight-gpus/k8s/
kubectl port-forward svc/llama-3-3-70b-instruct-leader 8000
curl -X POST "http://localhost:8000/v1/chat/completions" \
    -H "Content-Type: application/json" \
    --data '{
  "model": "meta-llama/Llama-3.3-70B-Instruct",
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
    --from-literal=TEST_SERVER_URL="http://llama-3-3-70b-instruct-leader.default:8000" \
    --from-literal=MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct" \
    --from-literal=TENSOR_PARALLEL_SIZE=4 \
    --from-literal=PIPELINE_PARALLEL_SIZE=2 \
    --from-literal=GPU_VM_SKU="${NODE_POOL_VM_SIZE}-GPUDirect-RDMA-Infiniband"

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

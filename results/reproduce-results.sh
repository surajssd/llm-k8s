# Benchmarking that actually spans on two machines using inference perf

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
    -- bash

# once inside the pod
cd
git clone https://github.com/kubernetes-sigs/inference-perf
cd inference-perf/
pip install virtualenv
virtualenv venv
source venv/bin/activate
pip install -e .
pip install git+https://github.com/neuralmagic/guidellm.git

# Run inference-perf tests
cat <<EOF >config.yaml
data:
  type: shareGPT
load:
  type: constant
  rate: 280
  duration: 30
vllm:
  api: chat
  model_name: deepseek-ai/DeepSeek-V2.5
  url: http://deepseek-v2-5-leader.default:8000
EOF

inference-perf --config_file config.yaml

# Run guidellm tests

guidellm benchmark \
    --target "http://deepseek-v2-5-leader.default:8000" \
    --model "deepseek-ai/DeepSeek-V2.5" \
    --rate-type sweep \
    --max-seconds 30 \
    --display-scheduler-stats \
    --data "prompt_tokens=256,output_tokens=128" \
    --output-extras '{"tag": "no-infiniband", "metadata": {"infiniband": "not-supported"}}'

# --------------------------------------------------------------

# Scenario 2: With IB
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
./scripts/deploy-aks.sh install_network_operator
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
    -- bash

# inside the pod
cd
git clone https://github.com/kubernetes-sigs/inference-perf
cd inference-perf/
pip install virtualenv
virtualenv venv
source venv/bin/activate
pip install -e .
pip install git+https://github.com/neuralmagic/guidellm.git

# Run inference-perf tests
cat <<EOF >config.yaml
data:
  type: shareGPT
load:
  type: constant
  rate: 32
  duration: 30
vllm:
  api: chat
  model_name: ${MODEL_NAME}
  url: ${TEST_SERVER_URL}
EOF

inference-perf --config_file config.yaml

# Run guidellm tests

guidellm benchmark \
    --target "http://deepseek-v2-5-leader.default:8000" \
    --model "deepseek-ai/DeepSeek-V2.5" \
    --rate-type sweep \
    --max-seconds 30 \
    --display-scheduler-stats \
    --data "prompt_tokens=256,output_tokens=128" \
    --output-extras '{"tag": "infiniband", "metadata": {"infiniband": "supported"}}'

# ----------------------------------------------------

cat <<EOF >diff
diff --git configs/deepseek-v2.5/k8s/lws.yaml configs/deepseek-v2.5/k8s/lws.yaml
index 10813c9..bd6a292 100644
--- configs/deepseek-v2.5/k8s/lws.yaml
+++ configs/deepseek-v2.5/k8s/lws.yaml
@@ -60,13 +60,8 @@ spec:
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
@@ -104,10 +99,6 @@ spec:
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
@@ -116,13 +107,8 @@ spec:
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

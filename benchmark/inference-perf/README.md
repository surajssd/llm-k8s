# Kubernetes WG Serving Inference Perf

## Deploy Benchmark Runner

First create the namespace:

```bash
kubectl create ns vllm-benchmark
```

Let's create a Kubernetes secret with hugging token. First get the token by going [here](https://huggingface.co/settings/tokens). You only need a "Read" token. Copy and export the token as an environment variable:

```bash
export HF_TOKEN=""
```

Now create a secret in Kubernetes:

```bash
kubectl -n vllm-benchmark create secret generic hf-token-secret --from-literal token=${HF_TOKEN}
```

Deploy the benchmark runner:

```bash
kubectl apply -f benchmark/vllm_upstream/k8s/
```

See if the pods are running by running the following command:

```bash
kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner
```

## Run Benchmarks

### Get access to the benchmark pod

Find the VLLM benchmark pod:

```bash
POD_NAME=$(kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner \
    --field-selector=status.phase=Running \
    -o jsonpath='{.items[].metadata.name}')
```

Run the benchmark tests:

```bash
kubectl -n vllm-benchmark \
    exec -it $POD_NAME \
    -- bash
```

### Start Benchmark Tests

Once inside the pod, export the following environment variables:

```bash
export TEST_SERVER_URL="http://gemma-3-27b.default:8000"
export MODEL_NAME="google/gemma-3-27b-it"
```

Test if you can access the model:

```bash
curl -X POST "${TEST_SERVER_URL}/v1/chat/completions"   -H "Content-Type: application/json"   --data '{
  "model": "'"${MODEL_NAME}"'",
  "messages": [
   {
    "role": "user",
    "content": "Explain the origin of Llama the animal?"
   }
  ]
 }' | jq
```

Create a config file for inference-perf:

```bash
export BENCHMARK_DATA_PATH="/root/benchmark-data/gemma-3-27b-a100-80gb-vllm"
```

Run the following command to create the config file:

```yaml
cat <<EOF > /tmp/config.yaml
api:
  type: completion
  streaming: true
data:
  type: shareGPT
  path: /root/sharegpt.json
load:
  type: constant
  sweep:
    type: linear
    timeout: 120
    num_stages: 5
    stage_duration: 180
    saturation_percentile: 95
server:
  type: vllm
  model_name: ${MODEL_NAME}
  base_url: ${TEST_SERVER_URL}
  ignore_eos: true
report:
  request_lifecycle:
    summary: true
    per_stage: true
    per_request: false
storage:
  local_storage:
    path: ${BENCHMARK_DATA_PATH}
EOF
```

Start the benchmark run:

```bash
inference-perf --config_file /tmp/config.yaml && \
  inference-perf --analyze ${BENCHMARK_DATA_PATH}
```

## Jupyter Notebook

Port forward the Jupyter Notebook port:

```bash
kubectl -n vllm-benchmark port-forward pod/${POD_NAME} 8888
```

Now you can access the Jupyter Notebook at [http://127.0.0.1:8888/tree](http://127.0.0.1:8888/tree).

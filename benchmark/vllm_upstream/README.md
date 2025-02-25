# VLLM Benchmark Suite (Upstream)

## Deploy Benchmark Runner

First create the namespace:

```bash
kubectl create ns vllm-benchmark
```

Now create the configmap with [run_vllm_upstream_benchmark.sh](run_vllm_upstream_benchmark.sh) and other values in it:

```bash
kubectl -n vllm-benchmark create configmap benchmark-runner \
    --from-file=benchmark/vllm_upstream/run_vllm_upstream_benchmark.sh \
    --from-literal=TEST_SERVER_URL="http://llama-3-3-70b-instruct-leader.default:8000" \
    --from-literal=MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct" \
    --from-literal=TENSOR_PARALLEL_SIZE=2 \
    --from-literal=PIPELINE_PARALLEL_SIZE="${GPU_NODE_COUNT}" \
    --from-literal=GPU_VM_SKU="${VM_SIZE}"
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
    -- bash /root/benchmark/run_vllm_upstream_benchmark.sh
```

Get the benchmark results:

```bash
RESULTS_FILE=$(kubectl -n vllm-benchmark \
    exec -it $POD_NAME \
    -- bash -c "ls /root/results*.tar.gz" | tr -d '\r')

kubectl -n vllm-benchmark \
    cp "${POD_NAME}:${RESULTS_FILE}" "./$(basename ${RESULTS_FILE})"
```

## Update Configmap

To update any of the values from before run the following command:

```bash
kubectl -n vllm-benchmark create configmap benchmark-runner \
    --from-file=benchmark/vllm_upstream/run_vllm_upstream_benchmark.sh \
    --from-literal=TEST_SERVER_URL="http://llama-3-3-70b-instruct-leader.default:8000" \
    --from-literal=MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct" \
    --from-literal=TENSOR_PARALLEL_SIZE=2 \
    --from-literal=PIPELINE_PARALLEL_SIZE="${GPU_NODE_COUNT}" \
    --from-literal=GPU_VM_SKU="${VM_SIZE}" \
    --dry-run=client -o yaml \
    | kubectl apply -f -
```

Restart the benchmark runner:

```bash
kubectl -n vllm-benchmark rollout restart deployment benchmark-runner
```

See if the pods are running by running the following command:

```bash
kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner
```

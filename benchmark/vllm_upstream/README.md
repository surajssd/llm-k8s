# VLLM Benchmark Suite (Upstream)

## Deploy Benchmark Runner

First create the namespace:

```bash
kubectl create ns vllm-benchmark
```

Now create the configmap with [run_vllm_upstream_benchmark.sh](run_vllm_upstream_benchmark.sh) and other values in it:

```bash
kubectl -n vllm-benchmark create configmap benchmark-runner \
    --from-literal=TEST_SERVER_URL="http://llama-3-3-70b-instruct-leader.default:8000" \
    --from-literal=MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct" \
    --from-literal=TENSOR_PARALLEL_SIZE=2 \
    --from-literal=PIPELINE_PARALLEL_SIZE="${NODE_POOL_NODE_COUNT}" \
    --from-literal=GPU_VM_SKU="${NODE_POOL_VM_SIZE}"
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
    -- bash /root/scripts/run_vllm_upstream_benchmark.sh
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
    --from-literal=TEST_SERVER_URL="http://llama-3-3-70b-instruct-leader.default:8000" \
    --from-literal=MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct" \
    --from-literal=TENSOR_PARALLEL_SIZE=2 \
    --from-literal=PIPELINE_PARALLEL_SIZE="${NODE_POOL_NODE_COUNT}" \
    --from-literal=GPU_VM_SKU="${NODE_POOL_VM_SIZE}" \
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

## Benchmark Results

Here are some of the benchmark results with vLLM as the serving platform. For distributed inference, non-infiniband VMs have been used, with Ray to do the distributed inference:

- [results-serving_meta-llama-Llama-3.3-70B-Instruct_tp2_pp2_sharegpt](https://gist.github.com/surajssd/9e99362736af03575a8c34b46ac8e1bc)
- [results-serving_meta-llama-Llama-3.3-70B-Instruct_tp4_pp1_sharegpt](https://gist.github.com/surajssd/eef8ebf83cadd690f6fb4ee87b30fe1a)
- [results-serving_microsoft-phi-4_tp1_pp1_sharegpt](https://gist.github.com/surajssd/a1e546da84999df665cd9131f5ab64e0)
- Infiniband [results-serving_meta-llama-Llama-3.3-70B-Instruct_tp4_pp2_sharegpt](https://gist.github.com/surajssd/c8bbcb244b210a3607ad952a7bdda759#file-benchmark_results-md)

The results are named as follows: `results-serving_${MODEL_NAME}_tp${TENSOR_PARALLEL_SIZE}_pp${PIPELINE_PARALLEL_SIZE}_sharegpt`. Where `TENSOR_PARALLEL_SIZE` signifies the number of GPUs on a single node and `PIPELINE_PARALLEL_SIZE` signifies the number of nodes.

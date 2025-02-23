# VLLM Benchmark Suite (Upstream)

## Deploy Benchmark Runner

First create the namespace:

```bash
kubectl create ns vllm-benchmark
```

Now create the configmap with [run_vllm_upstream_benchmark.sh](run_vllm_upstream_benchmark.sh) and other values in it:

```bash
kubectl -n vllm-benchmark create configmap benchmark-runner \
    --from-file=run_vllm_upstream_benchmark.sh \
    --from-literal=VLLM_VERSION="0.7.3" \
    --from-literal=TEST_SERVER_URL="http://llama-3-3-70b-instruct-leader.default:8000" \
    --from-literal=MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct"
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
kubectl apply -f k8s/
```

See if the pods are running by running the following command:

```bash
kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner
```

## Run Benchmarks

Start the benchmark tests:

```bash
POD_NAME=$(kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner \
    -o jsonpath='{.items[].metadata.name}')

kubectl -n vllm-benchmark \
    exec -it $POD_NAME \
    -- bash /root/benchmark/run_vllm_upstream_benchmark.sh
```

## Update Configmap

To update any of the values from before run the following command:

```bash
kubectl -n vllm-benchmark create configmap benchmark-runner \
    --dry-run=client -o yaml \
    --from-file=run_vllm_upstream_benchmark.sh \
    --from-literal=VLLM_VERSION="0.7.3" \
    --from-literal=TEST_SERVER_URL="http://llama-3-3-70b-instruct-leader.default:8000" \
    --from-literal=MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct" \
    | kubectl apply -f -
```

Restart the benchmark runner:

```bash
kubectl -n vllm-benchmark rollout restart deployment benchmark-runner
```

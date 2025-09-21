# vLLM Becnhmark using GuideLLM

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

Find the VLLM benchmark pod:

```bash
POD_NAME=$(kubectl -n vllm-benchmark \
    get pods \
    -l app=benchmark-runner \
    --field-selector=status.phase=Running \
    -o jsonpath='{.items[].metadata.name}')
```

Get access to the pod:

```bash
kubectl -n vllm-benchmark \
    exec -it $POD_NAME -- bash
```

Run the benchmark tests:

```bash
guidellm benchmark \
  --target "http://llama-3-3-70b-instruct.default:8000" \
  --model "meta-llama/Llama-3.3-70B-Instruct" \
  --rate-type sweep \
  --max-seconds 30 \
  --display-scheduler-stats \
  --data "prompt_tokens=256,output_tokens=128"
```

## Using LMCache Benchmarks

Install:

```bash
cd
pip install virtualenv
virtualenv venv
source venv/bin/activate
git clone https://github.com/LMCache/LMCache
cd LMCache/benchmarks/multi-round-qa
pip install -r requirements.txt
```

Run:

```bash
bash prepare_sharegpt_data.sh 1
python3 multi-round-qa.py \
    --num-users 10 \
    --num-rounds 5 \
    --qps 0.5 \
    --shared-system-prompt 1000 \
    --user-history-prompt 2000 \
    --answer-len 100 \
    --sharegpt \
    --model meta-llama/Llama-3.3-70B-Instruct \
    --base-url http://llama-3-3-70b-instruct.default:8000/v1
```

## Using the original

```bash
export TEST_SERVER_URL="http://llama-3-3-70b-instruct.default:8000"
export MODEL_NAME="meta-llama/Llama-3.3-70B-Instruct"
export TENSOR_PARALLEL_SIZE=4
export PIPELINE_PARALLEL_SIZE="1"
export GPU_VM_SKU="lmcache"

bash /root/scripts/run_vllm_upstream_benchmark.sh
```

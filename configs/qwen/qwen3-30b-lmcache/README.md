# Qwen 3 30B on vLLM

Here we will deploy the [Qwen 3 30B A3B Instruct](https://huggingface.co/Qwen/Qwen3-30B-A3B-Instruct-2507) model using vLLM on Azure Kubernetes Service (AKS).

## Deploy Infra: Using AKS

Make necesary changes to the `.env` file as you see fit:

```bash
source .env
export NODE_POOL_VM_SIZE="Standard_ND96amsr_A100_v4"
export NODE_POOL_NODE_COUNT=1
```

Now run the following command to deploy AKS:

```bash
./scripts/deploy-aks.sh
```

## Deploy LLM

### Deploy the model

Deploy Kubernetes configs to run the model:

```bash
helm upgrade -i qwen-3-30b-lmcache \
  --values configs/qwen/qwen3-30b-lmcache/values.yaml \
  ./configs/chart
```

### Access the model

### Testing the model using OpenWebUI

Create a port-forward so that you can access the openwebui locally:

```bash
kubectl port-forward svc/qwen-3-30b-lmcache 8080
```

Then open your browser and go to [http://localhost:8080](http://localhost:8080).

### Testing the model using curl

Create a port-forward so that you can access the model locally:

```bash
kubectl port-forward svc/qwen-3-30b-lmcache 8000
```

Text-only input:

```bash
curl -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Content-Type: application/json" \
  --data '{
  "model": "Qwen/Qwen3-30B-A3B-Instruct-2507",
  "messages": [
   {
    "role": "user",
    "content": "Explain the origin of Llama the animal?"
   }
  ]
 }' | jq
```

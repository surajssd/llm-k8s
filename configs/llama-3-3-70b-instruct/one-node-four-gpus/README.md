# Llama-3.3-70B-Instruct

## Deploy Infra: Using AKS

Make necesary changes to the `.env` file as you see fit:

```bash
source .env
export NODE_POOL_VM_SIZE="Standard_NC96ads_A100_v4"
export NODE_POOL_NODE_COUNT=1
```

Now run the following command to deploy AKS:

```bash
./scripts/deploy-aks.sh all_fast
```

## Deploy LLM

### Permission to use the model

Get access to the model by accepting the terms here: <https://huggingface.co/meta-llama/Llama-3.3-70B-Instruct>

### Huggingface Secret

Before we can deploy the model create a secret to access the model from Huggingface. You can create a token for Huggingface by going [here](https://huggingface.co/settings/tokens). You only need a "Read" token. Copy and export the token as an environment variable:

```bash
export HF_TOKEN=""
```

Now create a secret in Kubernetes:

```bash
kubectl create secret generic hf-token-secret --from-literal token=${HF_TOKEN}
```

### Deploy the model

Now deploy other Kubernetes configs to run the model:

```bash
helm upgrade -i llama-3-3-70b-instruct \
  --values configs/llama-3-3-70b-instruct/one-node-four-gpus/values.yaml \
  ./configs/chart
```

## Access the model

### Testing the model using OpenWebUI

Create a port-forward so that you can access the openwebui locally:

```bash
kubectl port-forward svc/llama-3-3-70b-instruct 8080
```

Then open your browser and go to [http://localhost:8080](http://localhost:8080).

### Testing the model using curl

Create a port-forward so that you can access the model locally:

```bash
kubectl port-forward svc/llama-3-3-70b-instruct 8000
```

Now run this sample query to check if it is working fine:

```bash
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
```

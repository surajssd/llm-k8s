# Google Gemma 3 27B on vLLM

Here we will deploy the [Google Gemma 3 27B](https://huggingface.co/google/gemma-3-27b-it) model using vLLM on Azure Kubernetes Service (AKS).

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

### Permission to use the model

Get access to the model by accepting the terms here: <https://huggingface.co/meta-llama/Llama-4-Maverick-17B-128E-Instruct>

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

Deploy Kubernetes configs to run the model:

```bash
helm upgrade -i gemma-3-27b \
  --values configs/gemma3-27b/values.yaml \
  ./configs/chart
```

### Access the model

### Testing the model using OpenWebUI

Create a port-forward so that you can access the openwebui locally:

```bash
kubectl port-forward svc/gemma-3-27b 8080
```

Then open your browser and go to [http://localhost:8080](http://localhost:8080).

### Testing the model using curl

Create a port-forward so that you can access the model locally:

```bash
kubectl port-forward svc/gemma-3-27b 8000
```

Text-only input:

```bash
curl -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Content-Type: application/json" \
  --data '{
  "model": "google/gemma-3-27b-it",
  "messages": [
   {
    "role": "user",
    "content": "Explain the origin of Llama the animal?"
   }
  ]
 }' | jq
```

Image input:

```bash
curl -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Content-Type: application/json" \
  --data '{
  "model": "google/gemma-3-27b-it",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "What is in this image?"
        },
        {
          "type": "image_url",
          "image_url": {
            "url": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg"
          }
        }
      ]
    }
  ]
}' | jq
```

# Microsoft Phi-4

## Deploy Infra: Using AKS

Make necesary changes to the `.env` file as you see fit:

```bash
source .env
export NODE_POOL_VM_SIZE="Standard_NC24ads_A100_v4"
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
helm upgrade -i phi-4 \
  --values configs/phi-4/values.yaml \
  ./configs/chart
```

### Access the model

Create a port-forward so that you can access the model locally:

```bash
kubectl port-forward svc/phi-4 8000
```

Now run this sample query to check if it is working fine:

```bash
curl -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Content-Type: application/json" \
  --data '{
  "model": "microsoft/phi-4",
  "messages": [
   {
    "role": "user",
    "content": "Explain the origin of Llama the animal?"
   }
  ]
 }' | jq
```

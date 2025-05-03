# DeepSeek v2.5

These instructions are using the Leaderworkerset to deploy model in a distributed fashion. The model is deployed on two nodes with eight GPUs each.

The machine type `Standard_ND96asr_v4` has only 40GB of memory per GPU. But the machine supports infiniband network, so in this set up we will also use the infiniband network to do distributed inference.

## Deploy Infra: Using AKS

Make necesary changes to the `.env` file as you see fit:

```bash
source .env
export NODE_POOL_VM_SIZE="Standard_ND96asr_v4"
export NODE_POOL_NODE_COUNT=2
export AZURE_REGION=southcentralus
```

Now run the following commands to deploy AKS and related components:

```bash
./scripts/deploy-aks.sh deploy_aks
./scripts/deploy-aks.sh download_aks_credentials
./scripts/deploy-aks.sh install_kube_prometheus
./scripts/deploy-aks.sh install_lws_controller
./scripts/deploy-aks.sh add_nodepool
./scripts/deploy-aks.sh install_network_operator
./scripts/deploy-aks.sh install_gpu_operator
```

## Deploy LLM

### Deploy the model

Now deploy other Kubernetes configs to run the model:

```bash
helm upgrade -i deepseek-v2-5 \
  --values configs/deepseek-v2.5/values.yaml \
  ./configs/chart
```

## Access the model

Create a port-forward so that you can access the model locally:

```bash
kubectl port-forward svc/deepseek-v2-5-leader 8000
```

Now run this sample query to check if it is working fine:

```bash
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
```

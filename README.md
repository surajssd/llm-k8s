# Llama on Kubernetes

This has instructions to run Llama on Kubernetes on Azure.

## Deploy Infra: Option 1: Using AKS

Make necesary changes to the `.env` file as you see fit and then run the following command to deploy AKS:

```bash
source .env
./scripts/deploy-aks.sh
```

## Deploy Infra: Option 2: Single Node VM

Follow the series of steps in [this document](docs/single-node-gpu-vm-setup.md) to deploy a single node VM with GPUs and then deploy Kubernetes on it.

## Prepare Kubernetes for LLM deployment

### Install NVIDIA drivers on Kubernetes

Now run this script to install NVIDIA drivers on Kubernetes:

```bash
./scripts/install-nvidia-drivers-on-k8s.sh
```

## Deploy LLM

### 1. Deploy Llama-3.3-70B-Instruct on Kubernetes

**Permission to use the model:**

Get access to the model by accepting the terms here: <https://huggingface.co/meta-llama/Llama-3.3-70B-Instruct>

**Huggingface Secret:**

Before we can deploy the model create a secret to access the model from Huggingface. You can create a token for Huggingface by going [here](https://huggingface.co/settings/tokens). You only need a "Read" token. Copy and export the token as an environment variable:

```bash
export HF_TOKEN=""
```

Now create a secret in Kubernetes:

```bash
kubectl create secret generic hf-token-secret --from-literal token=${HF_TOKEN}
```

**Deploy the model:**

Now deploy other Kubernetes configs to run the model:

```bash
kubectl apply -f configs/llama-3-3-70b-instruct
```

**Access the model:**

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

### 2. Deploy Microsoft Phi4 on Kubernetes

**Deploy the model:**

Deploy Kubernetes configs to run the model:

```bash
kubectl apply -f configs/phi-4/
```

**Access the model:**

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

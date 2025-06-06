# LLMs on Kubernetes

This repository has instructions and configurations to deploy various open-weight LLMs to AKS. Follow the steps in the [`configs`](./configs) directory to deploy the respective LLMs.

There are instructions to use the following models:

- [Llama-3.3-70B-Instruct](./configs/llama-3-3-70b-instruct)
- [Microsoft Phi-4](./configs/phi-4)

## Use Helm Chart

```bash
helm repo add llm-k8s https://surajssd.github.io/llm-k8s
helm repo update

helm upgrade -i <model name> \
  --values <path to values file> \
  llm-k8s/llm-k8s
```

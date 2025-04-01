# Llama-3.3-70B-Instruct

These instructions are using the Leaderworkerset API to deploy model in a distributed fashion. The model is deployed on two nodes with eight GPUs each but we will use only four GPU per pod.

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
kubectl apply -f configs/llama-3-3-70b-instruct/two-nodes-eight-gpus/k8s/
```

> [!NOTE]
> Every time the model serving pods created by the LWS are coming up, please run the `./configs/llama-3-3-70b-instruct/two-nodes-eight-gpus/fix-svc.sh` script in the background so that the worker pod can reach the right leader pod. This script is resonsible for patching the endpoint of the leader pod. The leader pod's endpoint points at the leader pod's default internal IP address. But we want to use the leader pod's secondary IP assigned by the multus CNI plugin. This script will patch the leader pod's endpoint to use the secondary IP address. The address is usually in the range of `192.168.0.0/16` instead of the default `10.0.0.0/8` range.

## Access the model

Create a port-forward so that you can access the model locally:

```bash
kubectl port-forward svc/llama-3-3-70b-instruct-leader 8000
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

## Troubleshooting

Sometimes a pod may be stuck in `ContainerCreating` state for a really long time, and if you see the events you may see an event like this:

```bash
$ kubectl get events -w -A
NAMESPACE          LAST SEEN   TYPE      REASON                   OBJECT                                    MESSAGE
...
vllm-benchmark     97s         Warning   FailedCreatePodSandBox   pod/benchmark-runner-56c7bdd696-jh4x9     (combined from similar events): Failed to create pod sandbox: rpc error: code = Unknown desc = failed to setup network for sandbox "52d5beb4ca7aefc63364e0abfcee022b36ce90931438cc86cb3c9f920e97b58a": plugin type="multus" name="multus-cni-network" failed (add): Multus: [vllm-benchmark/benchmark-runner-56c7bdd696-jh4x9/80fca786-427c-4e12-a7e9-be0703cc2d8a]: error waiting for pod: Unauthorized
...
```

The error says that the multus-cni cannot access the Kubernetes api-server: `plugin type="multus" name="multus-cni-network" failed (add): Multus: [vllm-benchmark/benchmark-runner]: error waiting for pod: Unauthorized`.

To fix this simply kill all the pods in the `network-operator` namespace by running the following command:

```bash
kubectl -n network-operator delete pods --all
```

> [!NOTE]
> I know this is not an elegant solution, but it works! To fix this the network-operator installation has to be fixed. AFAIK the multus plugin needs to have "thick" installation to fix this problem.

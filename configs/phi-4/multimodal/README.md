# Microsoft Phi-4 Multimodal

Here we will deploy the [Microsoft Phi-4 Multimodal](https://huggingface.co/microsoft/Phi-4-multimodal-instruct) model using vLLM on Azure Kubernetes Service (AKS).

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
helm upgrade -i phi-4-multimodal \
  --values configs/phi-4/multimodal/values.yaml \
  ./configs/chart
```

### Access the model

### Testing the model using OpenWebUI

Create a port-forward so that you can access the openwebui locally:

```bash
kubectl port-forward svc/phi-4-multimodal 8080
```

Then open your browser and go to [http://localhost:8080](http://localhost:8080).

### Testing the model using curl

Create a port-forward so that you can access the model locally:

```bash
kubectl port-forward svc/phi-4-multimodal 8000
```

Text-only input:

```bash
curl -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Content-Type: application/json" \
  --data '{
  "model": "microsoft/Phi-4-multimodal-instruct",
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
  "model": "microsoft/Phi-4-multimodal-instruct",
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

Audio input:

```bash
curl -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Content-Type: application/json" \
  --data '{
  "model": "microsoft/Phi-4-multimodal-instruct",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "What is in this audio?"
        },
        {
          "type": "audio_url",
          "audio_url": {
            "url": "https://ia800303.us.archive.org/28/items/HindSwaraj-Speech-03-1/tryst.mp3"
          }
        }
      ]
    }
  ]
}' | jq
```

Video input:

> [!NOTE]
> This doesn't work just yet. Because vLLM doesn't support video input for Phi-4 multimodal. See [this page](https://docs.vllm.ai/en/latest/models/supported_models.html#id2) for updates if vLLM adds support for video. Right now you will see an error like this:
> `TypeError: Unknown video model type: phi4mm`.

```bash
curl -X POST "http://localhost:8000/v1/chat/completions" \
  -H "Content-Type: application/json" \
  --data '{
  "model": "microsoft/Phi-4-multimodal-instruct",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "What is in this video?"
        },
        {
          "type": "video_url",
          "video_url": {
            "url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"
          }
        }
      ]
    }
  ]
}' | jq
```

### Testing the model using Python

Run the script [`openai_chat_completion_client_for_multimodal.py`](https://docs.vllm.ai/en/latest/getting_started/examples/openai_chat_completion_client_for_multimodal.html) either here locally or from within the pod.

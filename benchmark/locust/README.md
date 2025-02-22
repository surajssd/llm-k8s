# Locust

## Deploy Locust

First, create the namespace:

```bash
kubectl create ns locust
```

Now create the configmap of the [locustfile.py](locustfile.py):

```bash
kubectl -n locust create configmap locust-config \
    --dry-run=client -o yaml \
    --from-literal=MODEL_NAME=meta-llama/Llama-3.3-70B-Instruct \
    --from-file=locustfile.py | kubectl apply -f -
```

Deploy locust application:

```bash
kubectl apply -f locust/
```

To access the locust dashboard, create a port-forward:

```bash
kubectl -n locust port-forward svc/locust 8089
```

Now open the URL <http://localhost:8089>.

## Run Locust

To start benchmarking select the number of users and ramp up for users. And enter the end point of the model server: for example: <http://llama-3-3-70b-instruct-leader.default:8000>.

## Update Locustfile

To update the locustfile, update the [locustfile.py](locustfile.py) and then update the configmap:

```bash
kubectl -n locust create configmap locust-config \
    --dry-run=client -o yaml \
    --from-literal=MODEL_NAME=meta-llama/Llama-3.3-70B-Instruct \
    --from-file=locustfile.py | kubectl apply -f -
```

Restart the locust deployment:

```bash
kubectl -n locust rollout restart deployment locust
```

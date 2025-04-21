# Monitoring

## Prometheus

To access the Prometheus dashboard, run the following command:

```bash
kubectl -n monitoring port-forward svc/prometheus-operated 9090
```

Go to <http://127.0.0.1:9090> to access the Prometheus dashboard.

## Grafana

To access the Grafana dashboard, run the following command:

```bash
kubectl -n monitoring port-forward svc/kube-proemetheus-grafana 3000:80
```

Go to <http://127.0.0.1:3000/dashboards> and enter username as `admin` and password as `prom-operator`.

## Ray Dashboard

To access the Ray dashboard, run the following command:

```bash
kubectl port-forward svc/$(kubectl get service | grep ray | awk '{print $1}') 8265:8265
```

Go to <http://127.0.0.1:8265> to access the Ray dashboard.

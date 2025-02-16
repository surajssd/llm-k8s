# Monitoring

To access the Prometheus dashboard, run the following command:

```bash
kubectl -n monitoring port-forward svc/prometheus-k8s 9090
```

To access the Grafana dashboard, run the following command:

```bash
kubectl -n monitoring port-forward svc/grafana 3000
```

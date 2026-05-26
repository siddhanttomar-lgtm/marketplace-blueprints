# Prometheus

E2E's Kubernetes deployment of [Prometheus](https://prometheus.io) — the open-source systems monitoring and alerting toolkit. Scrape metrics from your workloads, store time-series data, and query with PromQL.

## Architecture

```
  Prometheus Server → Scrape targets (pods, nodes, kube-state-metrics)
       └→ PVC (8Gi metrics storage)
  Node Exporter (DaemonSet) → Node-level metrics
  Pushgateway (optional) → Push metrics endpoint
```

## Prerequisites

- Kubernetes cluster (1 vCPU, 512 MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs
- RBAC enabled (ClusterRole is created for metric scraping)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install prometheus blueprints/prometheus \
  --set server.service.type=NodePort
```

Using a values file:

```bash
cp blueprints/prometheus/values.example.yaml my-values.yaml
helm install prometheus blueprints/prometheus -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc prometheus-server -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:$NODE_PORT in your browser

# Or via port-forward:
kubectl port-forward svc/prometheus-server 9090:80
# Open http://localhost:9090
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `server.service.type` | `ClusterIP` | Set `NodePort` for browser access |
| `server.persistentVolume.enabled` | `true` | Persist metrics data |
| `server.persistentVolume.size` | `8Gi` | PVC size |
| `server.retention` | `15d` | How long to keep metrics |
| `server.resources.requests.memory` | `512Mi` | Memory for Prometheus server |
| `prometheus-pushgateway.enabled` | `true` | Disable if not needed |
| `prometheus-node-exporter.enabled` | `true` | Node-level metrics via DaemonSet |

## Persistence

One PVC is created for the Prometheus server (default 8Gi for time-series data).

## Ports

| Port | Service | Notes |
|------|---------|-------|
| 80 | prometheus-server | Web UI and API |
| 9091 | prometheus-pushgateway | Push metrics endpoint (if enabled) |
| 9100 | prometheus-node-exporter | Node metrics (DaemonSet) |

## Troubleshooting

**Targets all DOWN** — verify ClusterRole was created: `kubectl get clusterrole prometheus-server`

**Out of disk** — increase `server.persistentVolume.size` or reduce `server.retention`

**pushgateway crash** — set `prometheus-pushgateway.enabled: false` if not needed

## License

Apache 2.0. Prometheus is licensed under the [Apache License 2.0](https://github.com/prometheus/prometheus/blob/main/LICENSE).

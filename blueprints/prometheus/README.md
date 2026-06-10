# Prometheus

E2E's Kubernetes deployment of [Prometheus](https://prometheus.io) — the open-source systems monitoring and alerting toolkit for scraping, storing, and querying time-series metrics.

## What You Get After Deployment

The E2E Marketplace provisions Prometheus and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| Prometheus UI | 80 | Web interface and PromQL query console |
| Pushgateway | 9091 | Push metrics endpoint (if enabled) |

Open `http://<deployment-url>` in your browser to access the Prometheus query interface.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `server.persistentVolume.size` | No | PVC size for time-series data. Default: `8Gi`. |
| `server.retention` | No | How long to keep metrics. Default: `15d`. |
| `server.resources.requests.memory` | No | Memory for the Prometheus server. Default: `512Mi`. |
| `prometheus-pushgateway.enabled` | No | Enable push metrics endpoint. Default: `true`. |
| `prometheus-node-exporter.enabled` | No | Enable node-level metrics via DaemonSet. Default: `true`. |

## Ports

| Port | Service | Description |
|------|---------|-------------|
| 80 | prometheus-server | Web UI and API |
| 9091 | prometheus-pushgateway | Push metrics endpoint (if enabled) |
| 9100 | prometheus-node-exporter | Node metrics (DaemonSet, internal) |

## Troubleshooting

**Targets all DOWN** — RBAC permissions may not have been created. Contact E2E support to verify the ClusterRole was applied correctly.

**Out of disk** — increase `server.persistentVolume.size` or reduce `server.retention` in your deployment configuration.

**pushgateway crash** — set `prometheus-pushgateway.enabled: false` if you don't need to push metrics.

## License

Apache 2.0. Prometheus is licensed under the [Apache License 2.0](https://github.com/prometheus/prometheus/blob/main/LICENSE).

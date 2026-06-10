# Grafana

E2E's Kubernetes deployment of [Grafana](https://grafana.com) — the open-source analytics and observability platform for building dashboards and alerts from your data sources.

## What You Get After Deployment

The E2E Marketplace provisions Grafana and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| Grafana UI | 3000 | Web interface |

Open `http://<deployment-url>:3000` in your browser and log in with username `admin` and the password you set.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `admin.password` | Yes | Admin account password. |
| `admin.user` | No | Admin username. Default: `admin`. |
| `persistence.size` | No | PVC size for dashboards and settings. Default: `10Gi`. |
| `grafana.plugins` | No | Comma-separated list of Grafana plugins to install on startup. |

## Ports

| Port | Description |
|------|-------------|
| 3000 | Grafana web interface |

## Troubleshooting

**Blank dashboard / login loop** — the pod may still be initialising. Allow 2–3 minutes after deployment and refresh the page.

**Plugin install fails** — plugin installation requires outbound internet access from the pod at startup. Verify your cluster allows outbound traffic.

## License

Apache 2.0. Grafana is licensed under the [GNU AGPL v3](https://github.com/grafana/grafana/blob/main/LICENSE).

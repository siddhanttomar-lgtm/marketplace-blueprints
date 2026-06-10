# Uptime Monitor

E2E's Kubernetes deployment for website uptime, response time, and SSL certificate monitoring. Combines Prometheus Blackbox Exporter (probing), Prometheus (metrics), and Grafana (dashboards) behind a single Nginx proxy.

## What You Get After Deployment

The E2E Marketplace provisions the full monitoring stack and shows the access URL in the dashboard.

| Path | Description |
|------|-------------|
| `http://<deployment-url>/` | Landing page with links to dashboards |
| `http://<deployment-url>/grafana/` | Grafana dashboards — uptime, response time, SSL expiry |
| `http://<deployment-url>/prometheus/` | Prometheus query interface |

Log in to Grafana using the admin credentials you set at deployment.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `probe.url1` | Yes | First URL to monitor (e.g. `https://your-site.com`). |
| `probe.url2` | No | Second URL to monitor. |
| `probe.url3` | No | Third URL to monitor. |
| `probe.interval` | No | How often to probe each URL. Default: `30s`. |
| `probe.timeout` | No | Probe timeout per request. Default: `10s`. |
| `grafana.adminUser` | Yes | Grafana admin username. |
| `grafana.adminPassword` | Yes | Grafana admin password. |
| `prometheus.retention` | No | How long Prometheus retains metrics. Default: `15d`. |
| `storage.prometheus.size` | No | Prometheus PVC size. Default: `5Gi`. |
| `storage.grafana.size` | No | Grafana PVC size. Default: `1Gi`. |

## Ports

| Service | Port | Description |
|---------|------|-------------|
| Nginx (main) | 80 | Landing page and reverse proxy |
| Grafana | 3000 | Dashboards (internal, proxied via `/grafana/`) |
| Prometheus | 9090 | Metrics store (internal, proxied via `/prometheus/`) |
| Blackbox Exporter | 9115 | HTTP/SSL prober (internal only) |

## Troubleshooting

**Probe showing DOWN** — verify the URL entered in `probe.url1` is publicly reachable over the internet.

**Grafana not loading dashboards** — wait 2–3 minutes after deployment for Prometheus to complete the first scrape cycle.

**SSL certificate alerts** — the Blackbox Exporter tracks SSL expiry. Check the "SSL Expiry" panel in the Grafana dashboard.

**No data in Grafana** — confirm `probe.url1` is set correctly and Prometheus data source is configured to `http://localhost:9090/prometheus`.

## License

Apache 2.0. [Prometheus](https://github.com/prometheus/prometheus/blob/main/LICENSE), [Grafana](https://github.com/grafana/grafana/blob/main/LICENSE), and [Blackbox Exporter](https://github.com/prometheus/blackbox_exporter/blob/master/LICENSE) are all Apache 2.0.

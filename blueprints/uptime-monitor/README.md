# Uptime Monitor

E2E's Kubernetes deployment for website uptime, response time, and SSL certificate monitoring. Combines Prometheus Blackbox Exporter for probing, Prometheus for metric collection, and Grafana for dashboards — all accessible through a single Nginx proxy.

## Architecture

```
  Browser
    │
  ┌─▼──────────────────────────────────────┐
  │  Nginx (port 80)                         │
  │   /          → landing page              │
  │   /grafana/  → Grafana (:3000)           │
  │   /prometheus/ → Prometheus (:9090)      │
  └──────────────────────────────────────────┘
         │              │
  ┌──────▼──────┐  ┌────▼────────────┐
  │  Grafana    │  │  Prometheus     │
  │  dashboards │  │  scrapes probes │
  └─────────────┘  └────────┬────────┘
                             │ scrapes
                    ┌────────▼────────┐
                    │ Blackbox        │
                    │ Exporter        │
                    │ probes URLs     │
                    └─────────────────┘
```

## Prerequisites

- Kubernetes cluster (250m CPU, 450Mi RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs
- Up to 3 HTTP/HTTPS URLs to monitor

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install uptime-monitor blueprints/uptime-monitor \
  --set probe.url1=https://your-site.com \
  --set probe.url2=https://api.your-site.com \
  --set grafana.adminUser=admin \
  --set grafana.adminPassword=YOUR-GRAFANA-PASSWORD
```

Using a values file:

```bash
cp blueprints/uptime-monitor/values.example.yaml my-values.yaml
helm install uptime-monitor blueprints/uptime-monitor -f my-values.yaml
```

## Accessing

Open the deployment URL shown in the E2E Marketplace UI (Nginx on port 80).

**Grafana dashboards** — pre-loaded with uptime and response-time panels:
```
URL:      http://<deployment-url>/grafana/
Username: value of grafana.adminUser
Password: value of grafana.adminPassword
```

**Prometheus** — raw metrics and query interface:
```
URL: http://<deployment-url>/prometheus/
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `probe.url1` | `""` | First URL to monitor (required) |
| `probe.url2` | `""` | Second URL to monitor (optional) |
| `probe.url3` | `""` | Third URL to monitor (optional) |
| `probe.interval` | `30s` | How often to probe each URL |
| `probe.timeout` | `10s` | Probe timeout per request |
| `grafana.adminUser` | `""` | Grafana admin username |
| `grafana.adminPassword` | `""` | Grafana admin password |
| `prometheus.retention` | `15d` | How long Prometheus retains metrics |
| `storage.prometheus.size` | `5Gi` | Prometheus PVC size |
| `storage.grafana.size` | `1Gi` | Grafana PVC size |

## Ports

| Service | Port | Description |
|---------|------|-------------|
| Nginx (main) | 80 | Landing page and reverse proxy |
| Grafana | 3000 | Dashboards (internal, proxied via Nginx) |
| Prometheus | 9090 | Metrics store (internal, proxied via Nginx) |
| Blackbox Exporter | 9115 | HTTP/SSL prober (internal only) |

## Troubleshooting

**Probe showing `DOWN`** — verify the URL is reachable from inside the cluster: `kubectl exec -it <pod> -- curl -v <url>`

**Grafana not loading dashboards** — wait 2-3 minutes after install for Prometheus to collect the first scrape cycle.

**SSL certificate alerts** — Blackbox tracks `probe_ssl_earliest_cert_expiry`. Check the "SSL Expiry" panel in Grafana.

**No data in Grafana** — confirm `probe.url1` is set and the Prometheus data source is pointing to `http://localhost:9090/prometheus`.

## License

Apache 2.0. [Prometheus](https://github.com/prometheus/prometheus/blob/main/LICENSE) and [Grafana](https://github.com/grafana/grafana/blob/main/LICENSE) are Apache 2.0. [Blackbox Exporter](https://github.com/prometheus/blackbox_exporter/blob/master/LICENSE) is Apache 2.0.

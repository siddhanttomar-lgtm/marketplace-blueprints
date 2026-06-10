# Nginx

E2E's Kubernetes deployment of [Nginx](https://nginx.org) — the high-performance web server and reverse proxy for serving static files or proxying upstream services.

## What You Get After Deployment

The E2E Marketplace provisions an Nginx instance and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| HTTP | 8080 | Web server / proxy |
| HTTPS | 8443 | HTTPS (when TLS is configured) |

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `serverBlock` | No | Custom Nginx server block configuration. Leave empty for the default static file server. |
| `replicaCount` | No | Number of Nginx replicas. Default: `1`. |
| `resources.requests.cpu` | No | CPU request. Default: `10m`. |
| `resources.requests.memory` | No | Memory request. Default: `128Mi`. |

## Ports

| Port | Description |
|------|-------------|
| 8080 | HTTP |
| 8443 | HTTPS |

## Troubleshooting

**502/503 when used as proxy** — verify the upstream service URL in your `serverBlock` is correct and reachable within the cluster.

**Static files not showing** — ensure your `serverBlock` points to the correct document root and your files are present.

## License

Apache 2.0. Nginx is licensed under the [2-clause BSD license](https://nginx.org/LICENSE).

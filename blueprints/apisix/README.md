# Apache APISIX

E2E's Kubernetes deployment of [Apache APISIX](https://apisix.apache.org) — a high-performance, cloud-native API gateway with a built-in Dashboard UI and etcd backend. Define routes, upstreams, and plugins through the UI without touching YAML.

## What You Get After Deployment

The E2E Marketplace provisions APISIX with etcd and the Dashboard, and shows the gateway URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| API Gateway | 9080 / 9443 | HTTP / HTTPS proxy endpoint |
| Dashboard UI | 80 | Route and plugin management |
| Admin API | 9180 | Internal only (ClusterIP) |

Open the Dashboard URL shown in the marketplace, log in with `admin` and the password you configured, then create your first route.

> **Security:** Change the dashboard admin password and Admin API keys immediately after first login. The Admin API runs on ClusterIP only — never expose port 9180 publicly.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `dashboard.adminPassword` | Yes | Dashboard login password. Change from the default. |
| `apisix.adminCredentials.admin` | No | Admin API key (MD5 or plain string). Replace the default. |
| `apisix.adminCredentials.viewer` | No | Viewer API key. Replace the default. |
| `etcd.storage.size` | No | PVC size for etcd route data. Default: `5Gi`. |
| `apisix.resources.requests.cpu` | No | CPU request for the gateway pod. Default: `100m`. |
| `apisix.resources.requests.memory` | No | Memory request for the gateway pod. Default: `256Mi`. |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 9080 | HTTP | Proxy — your API traffic endpoint |
| 9443 | HTTPS | Proxy — TLS endpoint |
| 80 | HTTP | Dashboard UI |
| 9180 | HTTP | Admin API (ClusterIP, internal only) |

## Quick Start

1. Open the Dashboard URL from the marketplace deployment page.
2. Log in with `admin` / your configured password.
3. Go to **Routes → Create** and add a route pointing to your upstream service.
4. Test the gateway: `curl http://<gateway-url>/` — a `404 Route Not Found` response confirms APISIX is running.

## Troubleshooting

**Blank plugin page in Dashboard** — the proxy sidecar handles two known Dashboard 3.0.1 bugs around `/apisix/admin/get_key` and `/apisix/admin/plugins/list`. If plugins still don't appear, check the proxy container logs: `kubectl logs -l app.kubernetes.io/name=apisix -c proxy`.

**etcd connection errors** — wait 60 seconds after deployment for etcd to initialize before configuring routes.

**Route not found after creation** — confirm the upstream host is reachable from within the cluster and the route path matches your request.

## License

Apache 2.0. See [Apache APISIX License](https://github.com/apache/apisix/blob/master/LICENSE).

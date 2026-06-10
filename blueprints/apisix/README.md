# Apache APISIX

E2E's Kubernetes deployment of [Apache APISIX](https://apisix.apache.org) — a high-performance, extensible API gateway with a built-in Dashboard UI, embedded etcd, and persistent route storage.

## What You Get After Deployment

The E2E Marketplace provisions APISIX and shows two access points in the dashboard:

| Service | Port | Description |
|---------|------|-------------|
| Gateway | 80 | Public API traffic endpoint — add routes before sending traffic |
| Dashboard UI | 9000 | Admin interface for configuring routes, upstreams, and plugins |

Open the Dashboard at `http://<deployment-host>:9000`, log in with username `admin` and the password you set, and change the password on first login.

**Gateway test:** Sending a request to the gateway before adding routes returns `{"error_msg":"404 Route Not Found"}` — this means the gateway is working correctly, just waiting for routes to be configured.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `dashboard.adminPassword` | Yes | Dashboard login password. Default is `Admin@12345` — change this. |
| `apisix.adminCredentials.admin` | No | Admin API key for the APISIX Admin API. Change the default before production. |
| `apisix.adminCredentials.viewer` | No | Viewer API key for read-only Admin API access. |
| `etcd.storage.size` | No | PVC size for etcd (stores all routes and config). Default: `5Gi`. |

## Ports

| Service | Port | Description |
|---------|------|-------------|
| Gateway | 80 (→ 9080) | Public API traffic |
| Dashboard | 9000 | Admin Dashboard UI |
| Admin API | 9180 | Route/plugin management API (internal — do not expose publicly) |
| etcd | 2379 | Internal config store (not exposed externally) |

## Troubleshooting

**Blank plugin page in Dashboard** — this is expected on the first load due to a known Dashboard 3.0.1 bug patched by the included OpenResty sidecar. Reload the page.

**`404 Route Not Found` on gateway** — no routes are configured yet. Use the Dashboard to add routes before sending traffic.

**etcd pending** — storage provisioning may be slow. Allow 2–3 minutes after deployment.

## License

Apache 2.0. See [Apache APISIX License](https://github.com/apache/apisix/blob/master/LICENSE).

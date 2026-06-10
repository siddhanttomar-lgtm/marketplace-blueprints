# Apache APISIX

E2E's Kubernetes deployment of [Apache APISIX](https://apisix.apache.org) — a high-performance, extensible API gateway with a built-in Dashboard UI. This chart deploys APISIX, embedded etcd, and the Dashboard in a single pod with persistent route storage.

## Architecture

```
  External Traffic
        │
  ┌─────▼──────────────────────────────────┐
  │   Service (ClusterIP / Platform Ingress) │
  │   port 80 → APISIX Gateway (:9080)      │
  │   port 9000 → Dashboard UI (:9000)      │
  └──────────────────────────────────────────┘
        │
  ┌─────▼──────────────────────────────────┐
  │         Single Pod                       │
  │  ┌────────────┐   ┌──────────────────┐  │
  │  │   APISIX   │   │  Dashboard 3.0.1 │  │
  │  │  :9080     │◄──│  :9000           │  │
  │  │  Admin:9180│   └──────────────────┘  │
  │  └────────────┘                         │
  │  ┌────────────┐   ┌──────────────────┐  │
  │  │    etcd    │   │  OpenResty proxy │  │
  │  │  :2379     │   │  (bug sidecar)   │  │
  │  └────────────┘   └──────────────────┘  │
  └──────────────────────────────────────────┘
        │
  ┌─────▼──────────┐
  │  etcd PVC (5Gi) │
  └─────────────────┘
```

## Prerequisites

- Kubernetes cluster (250m CPU, 450Mi RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install apisix blueprints/apisix \
  --set dashboard.adminPassword=YOUR-DASHBOARD-PASSWORD \
  --set apisix.adminCredentials.admin=YOUR-ADMIN-KEY
```

Using a values file:

```bash
cp blueprints/apisix/values.example.yaml my-values.yaml
helm install apisix blueprints/apisix -f my-values.yaml
```

## Accessing

**Gateway** (route traffic through here after adding routes):
```bash
curl http://<gateway-url>/
# {"error_msg":"404 Route Not Found"} — gateway running, no routes configured yet
```

**Dashboard UI** — configure routes, upstreams, and plugins:
```
URL:      http://<release-name>-dash.<cluster-ip>.sslip.io
Username: admin
Password: value of dashboard.adminPassword
```
Change the password on first login.

**Admin API** (internal only — never expose publicly):
```bash
curl -H "X-API-KEY: <apisix.adminCredentials.admin>" \
  http://<release-name>:9180/apisix/admin/routes
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `apisix.adminCredentials.admin` | `edd1c9f034...` | Admin API key — change before production |
| `apisix.adminCredentials.viewer` | `4054f7cf07...` | Viewer API key |
| `dashboard.adminUsername` | `admin` | Dashboard login username |
| `dashboard.adminPassword` | `Admin@12345` | Dashboard login password — change before production |
| `etcd.storage.size` | `5Gi` | PVC size for etcd (stores all routes and config) |
| `apisix.resources.requests.cpu` | `100m` | APISIX CPU request |
| `apisix.resources.requests.memory` | `256Mi` | APISIX memory request |

## Ports

| Service | Port | Description |
|---------|------|-------------|
| Gateway | 80 (→ 9080) | Public API traffic — add routes before using |
| Dashboard | 9000 | Admin Dashboard UI |
| Admin API | 9180 | Route/plugin management API (internal) |
| etcd | 2379 | Internal config store (not exposed externally) |

## Adding a Route (Quick Example)

```bash
curl -H "X-API-KEY: <admin-key>" -X PUT \
  http://<release-name>:9180/apisix/admin/routes/1 \
  -d '{"uri": "/api/*", "upstream": {"type": "roundrobin", "nodes": {"my-svc:80": 1}}}'
```

## Troubleshooting

**Blank plugin page in Dashboard** — expected; the OpenResty sidecar patches two known Dashboard 3.0.1 bugs. Reload the page if it appears blank after first load.

**`404 Route Not Found` on gateway** — no routes configured yet. Use the Dashboard or Admin API to add routes before sending traffic.

**etcd pod `Pending`** — check PVC binding: `kubectl get pvc` and available storage.

## License

Apache 2.0. See [Apache APISIX License](https://github.com/apache/apisix/blob/master/LICENSE).

# Mattermost

E2E's Kubernetes deployment of [Mattermost](https://mattermost.com) — the open-source team messaging platform. Channels, threads, direct messages, file sharing, and search, all self-hosted.

## Architecture

```
  Browser → Service (NodePort :8065) → Mattermost Pod → PVC (10Gi data)
                                                       └→ PostgreSQL Pod → PVC (10Gi)
```

## Prerequisites

- Kubernetes cluster (2 vCPU, 1.5 GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install mattermost blueprints/mattermost \
  --set postgresql.auth.password=YOUR-DB-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/mattermost/values.example.yaml my-values.yaml
# Edit my-values.yaml, then:
helm install mattermost blueprints/mattermost -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc mattermost -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:$NODE_PORT in your browser
# Create your admin account on first visit
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `service.type` | `ClusterIP` | Set `NodePort` for browser access |
| `service.port` | `8065` | Mattermost HTTP port |
| `siteUrl` | `""` | Public URL — required for correct link generation |
| `data.storageSize` | `10Gi` | PVC size for Mattermost attachments |
| `postgresql.auth.password` | `""` | Database password. Required. |
| `postgresql.primary.persistence.size` | `10Gi` | PostgreSQL PVC size |
| `resources.requests.cpu` | `250m` | CPU request |
| `resources.requests.memory` | `512Mi` | Memory request |

## Persistence

Two PVCs are created:
- **Mattermost data** (`data.storageSize`, default 10Gi) — file attachments and local storage
- **PostgreSQL data** (`postgresql.primary.persistence.size`, default 10Gi) — database

## Ports

| Port | Notes |
|------|-------|
| 8065 | Mattermost web UI and API |

## Troubleshooting

**Can't receive email notifications** — configure SMTP under System Console → Environment → SMTP

**First login slow** — Mattermost initialises the database on first boot (~30s)

**File uploads failing** — check PVC is bound: `kubectl get pvc`

## License

MIT. Mattermost is licensed under the [Mattermost License](https://github.com/mattermost/mattermost/blob/master/LICENSE.txt).

# Nextcloud

E2E's Kubernetes deployment of [Nextcloud](https://nextcloud.com) — the self-hosted productivity platform. File sync, sharing, calendar, contacts, and 400+ apps, all under your control.

## Architecture

```
  Browser → Service (NodePort :80) → Nextcloud Pod → PVC (10Gi files)
                                                    └→ MariaDB Pod → PVC (8Gi)
```

## Prerequisites

- Kubernetes cluster (1 vCPU, 1 GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install nextcloud blueprints/nextcloud \
  --set nextcloud.host=nextcloud.example.com \
  --set nextcloud.password=YOUR-ADMIN-PASSWORD \
  --set mariadb.auth.password=YOUR-DB-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/nextcloud/values.example.yaml my-values.yaml
helm install nextcloud blueprints/nextcloud -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc nextcloud -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:$NODE_PORT in your browser
# Login: admin / <your-password>
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `nextcloud.host` | `nextcloud.kube.home` | Hostname for Nextcloud (used in URLs and trusted domains) |
| `nextcloud.username` | `admin` | Admin username |
| `nextcloud.password` | `""` | Admin password. Required. |
| `service.type` | `ClusterIP` | Set `NodePort` for browser access |
| `persistence.enabled` | `true` | Persist user files |
| `persistence.size` | `10Gi` | PVC size for Nextcloud data |
| `mariadb.enabled` | `true` | Use bundled MariaDB (recommended) |
| `mariadb.auth.password` | `""` | MariaDB password. Required. |
| `redis.enabled` | `false` | Enable Redis for caching (improves performance) |

## Persistence

Two PVCs are created: Nextcloud files (default 10Gi) and MariaDB data (default 8Gi).

## Ports

| Port | Notes |
|------|-------|
| 80 | Nextcloud web interface |

## Troubleshooting

**"Access through untrusted domain"** — set `nextcloud.host` to match the hostname you're using to access

**Slow file operations** — enable Redis (`redis.enabled: true`) for file locking and caching

**Upgrade stuck** — Nextcloud runs maintenance mode during upgrades; check logs: `kubectl logs deploy/nextcloud`

## License

AGPL-3.0. Nextcloud is licensed under the [GNU Affero General Public License v3](https://github.com/nextcloud/server/blob/master/COPYING).

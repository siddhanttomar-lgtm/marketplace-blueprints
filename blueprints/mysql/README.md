# MySQL

E2E's Kubernetes deployment of [MySQL](https://www.mysql.com) — the world's most popular open-source relational database. Reliable, battle-tested, and ideal for web applications.

## Architecture

```
  Application → Service (NodePort :3306) → MySQL Pod → PVC (8Gi)
```

## Prerequisites

- Kubernetes cluster (250m CPU, 512 MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install mysql blueprints/mysql \
  --set auth.rootPassword=YOUR-ROOT-PASSWORD \
  --set auth.database=mydb \
  --set auth.username=myuser \
  --set auth.password=YOUR-USER-PASSWORD \
  --set primary.service.type=NodePort
```

Using a values file:

```bash
cp blueprints/mysql/values.example.yaml my-values.yaml
helm install mysql blueprints/mysql -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc mysql -o jsonpath='{.spec.ports[0].nodePort}')
mysql -h <node-ip> -P $NODE_PORT -u myuser -p mydb
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.rootPassword` | `""` | Root user password. Required. |
| `auth.database` | `""` | Default database to create |
| `auth.username` | `""` | Application user to create |
| `auth.password` | `""` | Application user password |
| `primary.service.type` | `ClusterIP` | Set `NodePort` for external access |
| `primary.persistence.enabled` | `true` | Persist data to PVC |
| `primary.persistence.size` | `8Gi` | PVC size |
| `architecture` | `standalone` | Set to `replication` for primary/replica HA |

## Persistence

One PVC is created for the primary node (default 8Gi). Replica nodes get separate PVCs when `architecture: replication`.

## Ports

| Port | Notes |
|------|-------|
| 3306 | MySQL client port |

## Troubleshooting

**Access denied** — verify `auth.password` matches; root access requires `auth.rootPassword`

**Data lost after pod restart** — check PVC is bound: `kubectl get pvc`

**Slow first start** — MySQL initialises the data directory on first boot (~30s)

## License

GPL-2.0. MySQL is licensed under the [GNU General Public License v2](https://www.mysql.com/about/legal/licensing/oem/).

# MariaDB

E2E's Kubernetes deployment of [MariaDB](https://mariadb.org) — the community-developed, open-source relational database and drop-in replacement for MySQL. Standalone instance with authentication and persistent storage.

## Architecture

```
  Your App → Service (NodePort :3306) → MariaDB Pod → PVC (8Gi)
```

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install mariadb blueprints/mariadb \
  --set auth.rootPassword=YOUR-ROOT-PASSWORD \
  --set primary.service.type=NodePort
```

Using a values file:

```bash
cp blueprints/mariadb/values.example.yaml my-values.yaml
helm install mariadb blueprints/mariadb -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc mariadb -o jsonpath='{.spec.ports[0].nodePort}')
mysql -h <node-ip> -P $NODE_PORT -u root -p
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.rootPassword` | `""` | Root password. Required. |
| `auth.database` | `""` | Database to create on first start |
| `auth.username` | `""` | Additional user to create |
| `auth.password` | `""` | Password for the additional user |
| `primary.service.type` | `ClusterIP` | Set `NodePort` for external access |
| `primary.persistence.size` | `8Gi` | PVC size |
| `primary.persistence.storageClass` | `""` | Leave empty for cluster default |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 3306 | ClusterIP | Set `primary.service.type=NodePort` or: `kubectl port-forward svc/mariadb 3306:3306` |

## Troubleshooting

**Pod crash-loops** — often a storage issue: `kubectl describe pod -l app.kubernetes.io/name=mariadb`

**Auth failure** — `kubectl get secret mariadb -o jsonpath='{.data.mariadb-root-password}' | base64 -d`

**Slow first start** — MariaDB initializes on first boot; allow 30-60 seconds

## License

Apache 2.0. MariaDB is licensed under the [GPLv2](https://mariadb.com/kb/en/mariadb-license/).

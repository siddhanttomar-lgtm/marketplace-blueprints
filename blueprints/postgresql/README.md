# PostgreSQL

E2E's Kubernetes deployment of [PostgreSQL](https://www.postgresql.org) — the world's most advanced open-source relational database. Standalone instance with authentication and persistent storage.

## Architecture

```
  Your App → Service (NodePort :5432) → PostgreSQL Pod → PVC (8Gi)
```

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install postgresql blueprints/postgresql \
  --set auth.postgresPassword=YOUR-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/postgresql/values.example.yaml my-values.yaml
helm install postgresql blueprints/postgresql -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc postgresql -o jsonpath='{.spec.ports[0].nodePort}')
psql -h <node-ip> -p $NODE_PORT -U postgres
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.postgresPassword` | `""` | Superuser password. Required. |
| `auth.database` | `""` | Database to create on first start |
| `auth.username` | `""` | Additional user to create |
| `auth.password` | `""` | Password for the additional user |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `primary.persistence.size` | `8Gi` | PVC size |
| `primary.persistence.storageClass` | `""` | Leave empty for cluster default |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 5432 | ClusterIP | Set `service.type=NodePort` or: `kubectl port-forward svc/postgresql 5432:5432` |

## Troubleshooting

**Pending pod** — `kubectl get pvc` and `kubectl describe nodes`

**Auth failure** — `kubectl get secret postgresql -o jsonpath='{.data.postgres-password}' | base64 -d`

**Can't connect remotely** — confirm `service.type=NodePort`

## License

Apache 2.0. PostgreSQL is licensed under the [PostgreSQL License](https://www.postgresql.org/about/licence/).

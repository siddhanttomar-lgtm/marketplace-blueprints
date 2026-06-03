# MongoDB

E2E's Kubernetes deployment of [MongoDB](https://www.mongodb.com) — the leading open-source document database. Standalone instance with authentication and persistent storage.

## Architecture

```
  Your App → Service (NodePort :27017) → MongoDB Pod → PVC (8Gi)
```

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install mongodb blueprints/mongodb \
  --set auth.rootPassword=YOUR-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/mongodb/values.example.yaml my-values.yaml
helm install mongodb blueprints/mongodb -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc mongodb -o jsonpath='{.spec.ports[0].nodePort}')
mongosh "mongodb://root:YOUR-PASSWORD@<node-ip>:$NODE_PORT"
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.enabled` | `true` | Enable MongoDB authentication |
| `auth.rootPassword` | `""` | Root user password. Required when auth is enabled. |
| `auth.rootUser` | `root` | Root username |
| `auth.database` | `""` | Database to create on first start |
| `auth.username` | `""` | Additional user to create |
| `auth.password` | `""` | Password for the additional user |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `persistence.size` | `8Gi` | PVC size |
| `persistence.storageClass` | `""` | Leave empty for cluster default |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 27017 | ClusterIP | Set `service.type=NodePort` or: `kubectl port-forward svc/mongodb 27017:27017` |

## Troubleshooting

**Pending pod** — `kubectl get pvc` and `kubectl describe nodes`

**Auth failure** — `kubectl get secret mongodb -o jsonpath='{.data.mongodb-root-password}' | base64 -d`

**Slow startup** — MongoDB initializes storage on first start; allow 30-60 seconds

## License

Apache 2.0. MongoDB Community Edition is licensed under the [SSPL](https://www.mongodb.com/licensing/server-side-public-license).

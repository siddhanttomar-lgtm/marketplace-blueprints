# Redis

E2E's Kubernetes-native deployment of [Redis](https://redis.io) — the open-source, in-memory data store used as a database, cache, and message broker. This chart deploys a standalone Redis instance with authentication and persistent storage using the official Docker Hub image.

## Architecture

```
           ┌─────────────────────────────┐
           │       Your Application      │
           └──────────────┬──────────────┘
                          │ redis-cli / SDK
           ┌──────────────▼──────────────┐
           │     Service (NodePort)       │
           │         port 6379            │
           └──────────────┬──────────────┘
                          │
           ┌──────────────▼──────────────┐
           │         Deployment           │
           │    redis:7.4.1-alpine        │
           │   --appendonly yes           │
           │   --requirepass <password>   │
           └──────────────┬──────────────┘
                          │
           ┌──────────────▼──────────────┐
           │   PersistentVolumeClaim      │
           │         /data (8Gi)          │
           └─────────────────────────────┘
```

## Requirements

- Kubernetes cluster (1 vCPU, 256MB RAM minimum)
- A StorageClass that supports `ReadWriteOnce` PVCs (most clusters have one by default)

## Quick Start

Install directly from source:

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install redis blueprints/redis \
  --set auth.password=YOUR-STRONG-PASSWORD
```

Using a values file (recommended):

```bash
cp blueprints/redis/values.example.yaml my-values.yaml
# edit my-values.yaml
helm install redis blueprints/redis -f my-values.yaml
```

Check pod status:

```bash
kubectl get pods -l app.kubernetes.io/name=redis
```

## Connecting

Get the NodePort and node IP after installation:

```bash
kubectl get svc redis-redis -o jsonpath='{.spec.ports[0].nodePort}'
kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}'
```

Connect with redis-cli:

```bash
redis-cli -h <node-ip> -p <nodeport> -a <your-password>
```

## Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.password` | `""` | Redis AUTH password. Leave empty to disable auth (not recommended for production) |
| `persistence.enabled` | `true` | Enable persistent storage for Redis data |
| `persistence.size` | `8Gi` | PVC size |
| `persistence.storageClass` | `""` | StorageClass name — leave empty to use cluster default |
| `persistence.accessMode` | `ReadWriteOnce` | PVC access mode |
| `service.type` | `NodePort` | Service type |
| `service.port` | `6379` | Redis port |
| `service.nodePort` | `""` | NodePort number — leave empty for auto-assignment |
| `resources.requests.cpu` | `100m` | CPU request |
| `resources.requests.memory` | `128Mi` | Memory request |
| `resources.limits.cpu` | `500m` | CPU limit |
| `resources.limits.memory` | `512Mi` | Memory limit |
| `image.repository` | `redis` | Container image repository |
| `image.tag` | `7.4.1-alpine` | Container image tag |
| `replicaCount` | `1` | Number of replicas (standalone mode — keep at 1) |

## Ports

| Service | Type | Port | Description |
|---------|------|------|-------------|
| Redis | NodePort | 6379 (auto-assigned NodePort) | Redis protocol |

The NodePort is auto-assigned by Kubernetes unless you set `service.nodePort` explicitly.

## Troubleshooting

**Pod stuck in `Pending`** — check PVC binding: `kubectl get pvc` and node resources: `kubectl describe nodes`

**`WRONGPASS` error** — verify the password matches what was set during install. To check: `kubectl get secret redis-redis -o jsonpath='{.data.password}' | base64 -d`

**`NOAUTH` error** — you set a password but are not passing `-a` to redis-cli. Always include `-a <password>` in the connection command.

**Data not persisting across restarts** — verify `persistence.enabled=true` and the PVC is bound: `kubectl get pvc redis-redis`

## Upgrading

```bash
helm upgrade redis blueprints/redis -f my-values.yaml
```

## Uninstalling

```bash
helm uninstall redis
```

> **Note:** The PVC is not deleted automatically. To delete data: `kubectl delete pvc redis-redis`

## License

Apache 2.0. Redis is licensed under the [Redis Source Available License (RSALv2)](https://redis.io/legal/rsalv2-agreement/) for versions 7.4+.

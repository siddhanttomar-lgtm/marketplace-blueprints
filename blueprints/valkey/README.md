# Valkey

E2E's Kubernetes deployment of [Valkey](https://valkey.io) — an open-source, high-performance key/value datastore (Redis-compatible). Use it for caching, session storage, queues, pub/sub, and leaderboards.

## Architecture

```
  Application → Service (NodePort) → Valkey Pod → PVC (8Gi)
```

## Prerequisites

- Kubernetes cluster (250m CPU, 256 MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install valkey blueprints/valkey \
  --set auth.password=YOUR-PASSWORD \
  --set primary.service.type=NodePort
```

Using a values file:

```bash
cp blueprints/valkey/values.example.yaml my-values.yaml
helm install valkey blueprints/valkey -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc valkey -o jsonpath='{.spec.ports[0].nodePort}')
redis-cli -h <node-ip> -p $NODE_PORT -a YOUR-PASSWORD ping
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.enabled` | `true` | Enable password authentication |
| `auth.password` | `""` | Auth password. Required when `auth.enabled=true`. |
| `primary.service.type` | `ClusterIP` | Set `NodePort` for external access |
| `primary.persistence.enabled` | `true` | Persist data to PVC |
| `primary.persistence.size` | `8Gi` | PVC size |
| `replica.replicaCount` | `1` | Number of read replicas (set to `0` for standalone) |

## Persistence

One PVC is created for the primary node (default 8Gi). Replicas also get their own PVCs if enabled.

## Ports

| Port | Notes |
|------|-------|
| 6379 | Valkey client port |

## Troubleshooting

**AUTH failed** — confirm `auth.password` matches what your client is using

**Data lost after pod restart** — check PVC is bound: `kubectl get pvc`

**Connection refused** — set `primary.service.type=NodePort` for external access

## License

BSD 3-Clause. Valkey is licensed under the [BSD 3-Clause License](https://github.com/valkey-io/valkey/blob/unstable/COPYING).

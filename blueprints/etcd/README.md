# etcd

E2E's Kubernetes deployment of [etcd](https://etcd.io) — the distributed, reliable key-value store used as the backing store for Kubernetes and other distributed systems. Standalone instance for application configuration and service discovery.

## Architecture

```
  Your App / Service Discovery → Service (NodePort :2379) → etcd Pod → PVC (8Gi)
```

## Requirements

- Kubernetes cluster (1 vCPU, 256MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install etcd blueprints/etcd \
  --set auth.rbac.create=false \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/etcd/values.example.yaml my-values.yaml
helm install etcd blueprints/etcd -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc etcd -o jsonpath='{.spec.ports[?(@.name=="client")].nodePort}')
etcdctl --endpoints=http://<node-ip>:$NODE_PORT put mykey myvalue
etcdctl --endpoints=http://<node-ip>:$NODE_PORT get mykey
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.rbac.create` | `true` | Enable RBAC authentication |
| `auth.rbac.rootPassword` | `""` | Root password when RBAC is enabled |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `persistence.size` | `8Gi` | PVC size |
| `persistence.storageClass` | `""` | Leave empty for cluster default |
| `replicaCount` | `1` | Number of etcd replicas (use 3 for HA) |

## Ports

| Port | Default Service Type | Description |
|------|---------------------|-------------|
| 2379 | ClusterIP | Client connections |
| 2380 | ClusterIP | Peer communication (internal) |

Set `service.type=NodePort` to expose port 2379 externally.

## Troubleshooting

**Cluster not forming** — single-node is `replicaCount=1`; check pod logs: `kubectl logs statefulset/etcd`

**Auth errors** — `kubectl get secret etcd -o jsonpath='{.data.etcd-root-password}' | base64 -d`

**Data loss on restart** — verify PVC is bound: `kubectl get pvc`

## License

Apache 2.0. etcd is licensed under the [Apache License 2.0](https://github.com/etcd-io/etcd/blob/main/LICENSE).

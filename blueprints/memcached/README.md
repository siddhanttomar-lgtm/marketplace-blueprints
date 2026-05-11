# Memcached

E2E's Kubernetes deployment of [Memcached](https://memcached.org) — the high-performance, distributed memory object caching system. Simple, stateless, and extremely fast for session caching and data caching use cases.

## Architecture

```
  Your App → Service (NodePort :11211) → Memcached Pod
```

## Requirements

- Kubernetes cluster (0.5 vCPU, 128MB RAM minimum)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install memcached blueprints/memcached \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/memcached/values.example.yaml my-values.yaml
helm install memcached blueprints/memcached -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc memcached -o jsonpath='{.spec.ports[0].nodePort}')
# Test connection (requires memcached-tool or telnet)
echo "stats" | nc <node-ip> $NODE_PORT
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.enabled` | `false` | Enable SASL authentication (requires clients that support it) |
| `auth.password` | `""` | SASL password (only used when `auth.enabled=true`) |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `resources.limits.memory` | `256Mi` | Maximum memory Memcached can use |
| `replicaCount` | `1` | Number of Memcached instances |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 11211 | ClusterIP | Set `service.type=NodePort` or: `kubectl port-forward svc/memcached 11211:11211` |

## Troubleshooting

**Connection refused** — verify pod is running: `kubectl get pods -l app.kubernetes.io/name=memcached`

**Out of memory errors in your app** — increase `resources.limits.memory`

## License

Apache 2.0. Memcached is licensed under the [BSD License](https://github.com/memcached/memcached/blob/master/LICENSE).

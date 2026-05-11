# NATS

E2E's Kubernetes deployment of [NATS](https://nats.io) — the cloud-native, high-performance messaging system. Supports pub/sub, request/reply, and queue groups with extremely low latency.

## Architecture

```
  Publishers/Subscribers → Service (NodePort :4222) → NATS Pod
  Monitoring             → Service (ClusterIP :8222) → NATS monitoring endpoint
```

## Requirements

- Kubernetes cluster (0.5 vCPU, 128MB RAM minimum)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install nats blueprints/nats \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/nats/values.example.yaml my-values.yaml
helm install nats blueprints/nats -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc nats -o jsonpath='{.spec.ports[?(@.name=="client")].nodePort}')
# Using nats CLI
nats pub -s nats://<node-ip>:$NODE_PORT test "hello"
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.enabled` | `true` | Enable token-based authentication |
| `auth.token` | `""` | Auth token (auto-generated if empty) |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `replicaCount` | `1` | Number of NATS server replicas |

## Ports

| Port | Default Service Type | Description |
|------|---------------------|-------------|
| 4222 | ClusterIP | Client connections |
| 6222 | ClusterIP | Cluster routing (internal) |
| 8222 | ClusterIP | HTTP monitoring endpoint |

Set `service.type=NodePort` to expose port 4222 externally.

## Troubleshooting

**Client connection refused** — verify `service.type=NodePort` and check pod status

**Auth token** — `kubectl get secret nats -o jsonpath='{.data.client-auth-token}' | base64 -d` (if secret exists)

## License

Apache 2.0. NATS is licensed under the [Apache License 2.0](https://github.com/nats-io/nats-server/blob/main/LICENSE).

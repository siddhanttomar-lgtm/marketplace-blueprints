# RabbitMQ

E2E's Kubernetes deployment of [RabbitMQ](https://www.rabbitmq.com) — the most widely deployed open-source message broker. Supports AMQP, MQTT, STOMP, and more with a built-in management UI.

## Architecture

```
  Producers/Consumers → Service (NodePort :5672)  → RabbitMQ Pod → PVC (8Gi)
  Browser (Mgmt UI)   → Service (NodePort :15672) ↗
```

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install rabbitmq blueprints/rabbitmq \
  --set auth.username=user \
  --set auth.password=YOUR-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/rabbitmq/values.example.yaml my-values.yaml
helm install rabbitmq blueprints/rabbitmq -f my-values.yaml
```

## Accessing

```bash
# AMQP port (for applications)
AMQP_PORT=$(kubectl get svc rabbitmq -o jsonpath='{.spec.ports[?(@.name=="amqp")].nodePort}')

# Management UI port (for browser)
MGMT_PORT=$(kubectl get svc rabbitmq -o jsonpath='{.spec.ports[?(@.name=="manager")].nodePort}')
# Open http://<node-ip>:$MGMT_PORT in your browser
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.username` | `user` | Default admin username |
| `auth.password` | `""` | Admin password. Required. |
| `auth.erlangCookie` | `""` | Erlang cookie (auto-generated if empty) |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `persistence.size` | `8Gi` | PVC size for message data |
| `persistence.storageClass` | `""` | Leave empty for cluster default |

## Ports

| Port | Protocol | Default Service Type | Notes |
|------|----------|---------------------|-------|
| 5672 | AMQP | ClusterIP | Application connections |
| 15672 | HTTP | ClusterIP | Management UI |

Set `service.type=NodePort` to expose both ports externally.

## Troubleshooting

**Pod not ready** — RabbitMQ can take 60-90s to start: `kubectl logs statefulset/rabbitmq`

**Can't reach management UI** — ensure `service.type=NodePort` or use: `kubectl port-forward svc/rabbitmq 15672:15672`

**Auth error** — `kubectl get secret rabbitmq -o jsonpath='{.data.rabbitmq-password}' | base64 -d`

## License

Apache 2.0. RabbitMQ is licensed under the [Mozilla Public License 2.0](https://www.rabbitmq.com/mpl.html).

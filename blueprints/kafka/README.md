# Apache Kafka

E2E's Kubernetes deployment of [Apache Kafka](https://kafka.apache.org) — the distributed event streaming platform. This chart deploys Kafka in KRaft mode (no ZooKeeper required) with persistent storage.

## Architecture

```
  Producers → Service (NodePort :9092) → Kafka Broker Pod → PVC (8Gi)
  Consumers ↗                            KRaft controller (embedded)
```

## Requirements

- Kubernetes cluster (2 vCPU, 1GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install kafka blueprints/kafka \
  --set service.type=NodePort \
  --set listeners.client.protocol=PLAINTEXT
```

Using a values file:

```bash
cp blueprints/kafka/values.example.yaml my-values.yaml
helm install kafka blueprints/kafka -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc kafka -o jsonpath='{.spec.ports[?(@.name=="client")].nodePort}')
kafka-console-producer.sh --bootstrap-server <node-ip>:$NODE_PORT --topic test
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `replicaCount` | `1` | Number of Kafka broker replicas |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `listeners.client.protocol` | `SASL_PLAINTEXT` | Set `PLAINTEXT` to disable auth for dev |
| `sasl.client.users` | `[user]` | SASL usernames |
| `sasl.client.passwords` | `""` | SASL passwords |
| `persistence.size` | `8Gi` | PVC size per broker |
| `persistence.storageClass` | `""` | Leave empty for cluster default |

## Ports

| Port | Default Type | Description |
|------|-------------|-------------|
| 9092 | ClusterIP | Client connections |
| 9093 | ClusterIP | Inter-broker communication |
| 9094 | ClusterIP | Controller |

## Troubleshooting

**Producer can't connect** — check `service.type=NodePort` and advertised listeners are set to node IP

**Auth errors** — set `listeners.client.protocol=PLAINTEXT` for dev/test environments

**Slow startup** — Kafka initializes storage on first boot; allow 60-90 seconds

## License

Apache 2.0. Apache Kafka is licensed under the [Apache License 2.0](https://kafka.apache.org/licensing.html).

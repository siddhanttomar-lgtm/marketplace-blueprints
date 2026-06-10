# Apache Kafka

E2E's Kubernetes deployment of [Apache Kafka](https://kafka.apache.org) — the distributed event streaming platform. Runs in KRaft mode (no ZooKeeper required) with persistent storage.

## What You Get After Deployment

The E2E Marketplace provisions a Kafka broker and shows the bootstrap server endpoint in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| Kafka Client | 9092 | Kafka protocol |

Connect producers and consumers using: `<deployment-host>:9092`

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `listeners.client.protocol` | No | Set `PLAINTEXT` for dev/test (no auth). Default: `SASL_PLAINTEXT`. |
| `sasl.client.passwords` | No | SASL password for client authentication. |
| `persistence.size` | No | PVC size per broker. Default: `8Gi`. |
| `replicaCount` | No | Number of Kafka broker replicas. Default: `1`. |

## Ports

| Port | Description |
|------|-------------|
| 9092 | Client connections |
| 9093 | Inter-broker communication (internal) |
| 9094 | Controller (internal) |

## Troubleshooting

**Producer can't connect** — verify your client is using the bootstrap server address shown in the marketplace dashboard.

**Auth errors** — if you set `listeners.client.protocol=PLAINTEXT`, your client must not send SASL credentials. If using `SASL_PLAINTEXT`, provide the username and password set at deployment.

**Slow startup** — Kafka initialises storage on first boot; allow 60–90 seconds.

## License

Apache 2.0. Apache Kafka is licensed under the [Apache License 2.0](https://kafka.apache.org/licensing.html).

# NATS

E2E's Kubernetes deployment of [NATS](https://nats.io) — the cloud-native, high-performance messaging system supporting pub/sub, request/reply, and queue groups.

## What You Get After Deployment

The E2E Marketplace provisions a NATS server and shows the client endpoint in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| NATS Client | 4222 | NATS protocol |

Connect clients using: `nats://<deployment-host>:4222`

If `auth.enabled=true`, use: `nats://TOKEN@<deployment-host>:4222`

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.enabled` | No | Enable token-based authentication. Default: `true`. |
| `auth.token` | No | Auth token (auto-generated if left empty). |
| `replicaCount` | No | Number of NATS server replicas. Default: `1`. |

## Ports

| Port | Description |
|------|-------------|
| 4222 | Client connections |
| 6222 | Cluster routing (internal) |
| 8222 | HTTP monitoring endpoint (internal) |

## Troubleshooting

**Client connection refused** — verify your client is using the connection string shown in the marketplace dashboard.

**Auth token** — if you did not set `auth.token`, it was auto-generated. Contact E2E support to retrieve deployment configuration details.

## License

Apache 2.0. NATS is licensed under the [Apache License 2.0](https://github.com/nats-io/nats-server/blob/main/LICENSE).

# Valkey

E2E's Kubernetes deployment of [Valkey](https://valkey.io) — an open-source, Redis-compatible, high-performance key/value datastore for caching, sessions, queues, and pub/sub.

## What You Get After Deployment

The E2E Marketplace provisions a Valkey instance and shows the connection endpoint in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| Valkey | 6379 | Redis protocol |

Connect your application using: `valkey://:PASSWORD@<deployment-host>:6379` (Redis-compatible clients work too).

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.password` | Yes | Auth password. Required when `auth.enabled=true`. |
| `auth.enabled` | No | Enable password authentication. Default: `true`. |
| `primary.persistence.size` | No | PVC size. Default: `8Gi`. |
| `replica.replicaCount` | No | Number of read replicas. Set to `0` for standalone. Default: `1`. |

## Ports

| Port | Description |
|------|-------------|
| 6379 | Valkey/Redis client port |

## Troubleshooting

**AUTH failed** — the password your application is using doesn't match what was set during deployment.

**Data lost after restart** — verify `primary.persistence.enabled` is `true` in your deployment configuration.

## License

BSD 3-Clause. Valkey is licensed under the [BSD 3-Clause License](https://github.com/valkey-io/valkey/blob/unstable/COPYING).

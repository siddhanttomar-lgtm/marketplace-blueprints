# Redis

E2E's Kubernetes deployment of [Redis](https://redis.io) — the open-source, in-memory data store for caching, sessions, and pub/sub.

## What You Get After Deployment

The E2E Marketplace provisions a standalone Redis instance and shows the connection endpoint in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| Redis | 6379 | Redis protocol |

Connect your application using: `redis://:YOUR-PASSWORD@<deployment-host>:6379`

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.password` | Yes | Redis AUTH password. Use a strong random value. |
| `persistence.size` | No | PVC size for data storage. Default: `8Gi`. |
| `resources.requests.cpu` | No | CPU request. Default: `100m`. |
| `resources.requests.memory` | No | Memory request. Default: `128Mi`. |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 6379 | Redis | Client connections |

## Troubleshooting

**WRONGPASS error** — the password your application is using doesn't match what was set during deployment. Redeploy with the correct password or update your application's connection string.

**NOAUTH error** — your application is connecting without a password. Add the password to the connection string.

**Data not persisting after restart** — verify `persistence.enabled` is `true` in your deployment configuration.

## License

Apache 2.0. Redis is licensed under the [Redis Source Available License (RSALv2)](https://redis.io/legal/rsalv2-agreement/) for versions 7.4+.

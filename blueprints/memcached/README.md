# Memcached

E2E's Kubernetes deployment of [Memcached](https://memcached.org) — the high-performance, distributed memory object caching system.

## What You Get After Deployment

The E2E Marketplace provisions a Memcached instance and shows the connection endpoint in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| Memcached | 11211 | Memcache protocol |

Connect your application using the host and port shown in the dashboard.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `resources.limits.memory` | No | Maximum memory Memcached can use. Default: `256Mi`. |
| `auth.enabled` | No | Enable SASL authentication. Default: `false`. |
| `auth.password` | No | SASL password (only used when `auth.enabled=true`). |
| `replicaCount` | No | Number of Memcached instances. Default: `1`. |

## Ports

| Port | Description |
|------|-------------|
| 11211 | Memcache protocol |

## Troubleshooting

**Out of memory errors in your app** — increase `resources.limits.memory` in the deployment configuration.

**Connection refused** — the pod may still be starting. Allow 30 seconds after deployment.

## License

Apache 2.0. Memcached is licensed under the [BSD License](https://github.com/memcached/memcached/blob/master/LICENSE).

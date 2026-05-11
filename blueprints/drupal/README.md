# Drupal

E2E's Kubernetes deployment of [Drupal](https://www.drupal.org) — the open-source CMS powering millions of websites. Includes a bundled MariaDB database.

## Architecture

```
  Browser → Service (NodePort :8080) → Drupal Pod → PVC (8Gi)
                                               └───→ MariaDB Pod → PVC (8Gi)
```

## Requirements

- Kubernetes cluster (2 vCPU, 1GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install drupal blueprints/drupal \
  --set drupalPassword=YOUR-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/drupal/values.example.yaml my-values.yaml
helm install drupal blueprints/drupal -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc drupal -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
# Open http://<node-ip>:$NODE_PORT
# Admin: http://<node-ip>:$NODE_PORT/user/login (user / <drupalPassword>)
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `drupalUsername` | `user` | Drupal admin username |
| `drupalPassword` | `""` | Drupal admin password. Required. |
| `drupalEmail` | `user@example.com` | Admin email |
| `service.type` | `LoadBalancer` | Set `NodePort` on bare-metal clusters |
| `persistence.drupal.size` | `8Gi` | PVC size for Drupal files |
| `mariadb.auth.rootPassword` | `""` | MariaDB root password |
| `mariadb.auth.password` | `""` | MariaDB Drupal user password |

## Ports

| Port | Default Type | Description |
|------|-------------|-------------|
| 8080 | LoadBalancer | HTTP — set `service.type=NodePort` on bare-metal |

## Troubleshooting

**Slow first start** — Drupal installs modules on first boot; allow 2-3 minutes

**`LoadBalancer` pending** — set `service.type=NodePort`

**Database connection error** — both `mariadb.auth.rootPassword` and `mariadb.auth.password` must be set

## License

Apache 2.0. Drupal is licensed under the [GPLv2+](https://www.drupal.org/about/licensing).

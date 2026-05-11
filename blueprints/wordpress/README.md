# WordPress

E2E's Kubernetes deployment of [WordPress](https://wordpress.org) — the world's most popular content management system. Power blogs, business sites, portfolios, and online stores. MariaDB is bundled as the database backend; Memcached is available as an optional cache layer.

## Architecture

```
  Browser → Service (LoadBalancer :80) → WordPress Pod → PVC
                                               │
                                         MariaDB Pod → PVC
```

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install wordpress blueprints/wordpress \
  --set wordpressPassword=YOUR-PASSWORD
```

Using a values file:

```bash
cp blueprints/wordpress/values.example.yaml my-values.yaml
helm install wordpress blueprints/wordpress -f my-values.yaml
```

## Connecting

```bash
# LoadBalancer — wait for external IP:
kubectl get svc wordpress --watch

# Or use NodePort:
NODE_PORT=$(kubectl get svc wordpress -o jsonpath='{.spec.ports[0].nodePort}')
# Site: http://<node-ip>:<NODE_PORT>
# Admin: http://<node-ip>:<NODE_PORT>/wp-admin
# Login: user / <your password>
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `wordpressUsername` | `user` | WordPress admin username |
| `wordpressPassword` | `""` | Admin password. Required. |
| `wordpressBlogName` | `User's Blog!` | Site title |
| `wordpressEmail` | `user@example.com` | Admin email |
| `service.type` | `LoadBalancer` | Set `NodePort` for non-cloud clusters |
| `mariadb.auth.rootPassword` | `""` | MariaDB root password |
| `mariadb.primary.persistence.size` | `8Gi` | MariaDB PVC size |
| `persistence.size` | `10Gi` | WordPress files PVC size |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 80 | LoadBalancer | WordPress HTTP |
| 443 | LoadBalancer | WordPress HTTPS |

## Troubleshooting

**Pod stuck in Pending** — check PVC binding: `kubectl get pvc`

**Login fails** — retrieve password from secret: `kubectl get secret wordpress -o jsonpath='{.data.wordpress-password}' | base64 -d`

**No external IP (LoadBalancer)** — switch to NodePort: `--set service.type=NodePort`

**White screen / 500 error** — check WordPress logs: `kubectl logs -l app.kubernetes.io/name=wordpress`

## Upgrading

```bash
helm upgrade wordpress blueprints/wordpress -f my-values.yaml
```

## License

Apache 2.0. WordPress is licensed under the [GNU General Public License v2](https://wordpress.org/about/license/).

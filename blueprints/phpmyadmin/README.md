# phpMyAdmin

E2E's Kubernetes deployment of [phpMyAdmin](https://www.phpmyadmin.net) — the web-based MySQL/MariaDB administration tool. Manage databases, run SQL queries, import/export data, and administer users through a browser interface. MariaDB is bundled as the default database backend.

## Architecture

```
  Browser → Service (NodePort :80) → phpMyAdmin Pod
                                           │
                                     MariaDB Pod → PVC
```

## Requirements

- Kubernetes cluster (1 vCPU, 256MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install phpmyadmin blueprints/phpmyadmin \
  --set db.bundleTestDB=true \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/phpmyadmin/values.example.yaml my-values.yaml
helm install phpmyadmin blueprints/phpmyadmin -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc phpmyadmin -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:<NODE_PORT> in your browser
# Login with your MariaDB root credentials
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `db.bundleTestDB` | `false` | Set `true` to deploy a bundled MariaDB instance |
| `db.host` | `""` | External database host (if not using bundled DB) |
| `db.port` | `3306` | Database port |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `mariadb.auth.rootPassword` | `""` | MariaDB root password (when bundled) |
| `mariadb.primary.persistence.size` | `8Gi` | MariaDB PVC size |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 80 | ClusterIP | phpMyAdmin web UI — set `service.type=NodePort` or use port-forward |

Port-forward alternative:

```bash
kubectl port-forward svc/phpmyadmin 8080:80
# Open http://localhost:8080
```

## Connecting to an External Database

To connect phpMyAdmin to an existing MySQL/MariaDB server instead of the bundled one:

```bash
helm install phpmyadmin blueprints/phpmyadmin \
  --set db.bundleTestDB=false \
  --set db.host=YOUR-DB-HOST \
  --set db.port=3306 \
  --set service.type=NodePort
```

## Troubleshooting

**Cannot connect to database** — verify `db.host` is reachable from the cluster and credentials are correct

**Pod stuck in Pending** — check PVC binding: `kubectl get pvc`

**MariaDB root password** — retrieve from secret: `kubectl get secret phpmyadmin-mariadb -o jsonpath='{.data.mariadb-root-password}' | base64 -d`

## Upgrading

```bash
helm upgrade phpmyadmin blueprints/phpmyadmin -f my-values.yaml
```

## License

Apache 2.0. phpMyAdmin is licensed under the [GNU General Public License v2](https://www.phpmyadmin.net/license/).

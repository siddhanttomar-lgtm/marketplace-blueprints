# Redmine

E2E's Kubernetes deployment of [Redmine](https://www.redmine.org) — the open-source project management and issue tracking tool. Manage projects, track bugs, plan sprints, and visualize timelines. MariaDB is bundled as the default database backend.

## Architecture

```
  Browser → Service (LoadBalancer :80) → Redmine Pod → PVC
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

helm install redmine blueprints/redmine \
  --set redminePassword=YOUR-PASSWORD
```

Using a values file:

```bash
cp blueprints/redmine/values.example.yaml my-values.yaml
helm install redmine blueprints/redmine -f my-values.yaml
```

## Connecting

```bash
# LoadBalancer — wait for external IP:
kubectl get svc redmine --watch

# Or use NodePort:
NODE_PORT=$(kubectl get svc redmine -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:<NODE_PORT> in your browser
# Login: user / <your password>
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `redmineUsername` | `user` | Admin username |
| `redminePassword` | `""` | Admin password. Required. |
| `redmineEmail` | `user@example.com` | Admin email |
| `service.type` | `LoadBalancer` | Set `NodePort` for non-cloud clusters |
| `mariadb.auth.rootPassword` | `""` | MariaDB root password |
| `mariadb.primary.persistence.size` | `8Gi` | MariaDB PVC size |
| `persistence.size` | `8Gi` | Redmine files PVC size |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 80 | LoadBalancer | Redmine web UI |

## Troubleshooting

**Pod stuck in Pending** — check PVC binding: `kubectl get pvc`

**Login fails** — retrieve password from secret: `kubectl get secret redmine -o jsonpath='{.data.redmine-password}' | base64 -d`

**No external IP (LoadBalancer)** — switch to NodePort: `--set service.type=NodePort`

## Upgrading

```bash
helm upgrade redmine blueprints/redmine -f my-values.yaml
```

## License

Apache 2.0. Redmine is licensed under the [GNU General Public License v2](https://www.redmine.org/projects/redmine/wiki/License).

# Gitea

E2E's Kubernetes deployment of [Gitea](https://gitea.io) — the lightweight self-hosted Git service. Full Git hosting with issues, pull requests, CI/CD integrations, and a web UI. Includes a bundled PostgreSQL database.

## Architecture

```
  Browser / git clone → Service (NodePort :3000 HTTP / :2222 SSH) → Gitea Pod → PVC (10Gi)
                                                                          └────→ PostgreSQL → PVC (8Gi)
```

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install gitea blueprints/gitea \
  --set gitea.admin.password=YOUR-ADMIN-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/gitea/values.example.yaml my-values.yaml
helm install gitea blueprints/gitea -f my-values.yaml
```

## Accessing

```bash
HTTP_PORT=$(kubectl get svc gitea -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
SSH_PORT=$(kubectl get svc gitea -o jsonpath='{.spec.ports[?(@.name=="ssh")].nodePort}')
# Web UI: http://<node-ip>:$HTTP_PORT (login: gitea_admin / <your-password>)
# Git SSH: git clone ssh://git@<node-ip>:$SSH_PORT/user/repo.git
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `gitea.admin.username` | `gitea_admin` | Admin username |
| `gitea.admin.password` | `""` | Admin password. Required. |
| `gitea.admin.email` | `gitea_admin@gitea.local` | Admin email |
| `service.type` | `LoadBalancer` | Set `NodePort` on bare-metal clusters |
| `persistence.size` | `10Gi` | PVC size for repositories and data |
| `postgresql.auth.password` | `""` | PostgreSQL password |

## Ports

| Port | Default Type | Description |
|------|-------------|-------------|
| 3000 | LoadBalancer | HTTP web UI and Git over HTTP |
| 2222 | LoadBalancer | Git over SSH |

## Troubleshooting

**Can't push via SSH** — verify SSH port NodePort is exposed and `gitea.config.server.SSH_PORT` matches

**`LoadBalancer` pending** — set `service.type=NodePort`

**Admin password forgotten** — `kubectl exec deploy/gitea -- gitea admin user change-password --username gitea_admin --password NEW-PASSWORD`

## License

Apache 2.0. Gitea is licensed under the [MIT License](https://github.com/go-gitea/gitea/blob/main/LICENSE).

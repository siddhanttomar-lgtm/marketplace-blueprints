# Gitea

E2E's Kubernetes deployment of [Gitea](https://gitea.io) — the lightweight self-hosted Git service with issues, pull requests, CI/CD integrations, and a web UI. Includes a bundled PostgreSQL database.

## What You Get After Deployment

The E2E Marketplace provisions Gitea and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| Web UI + Git HTTP | 3000 | Browser access and `git clone` over HTTP |
| Git SSH | 2222 | `git clone` over SSH |

Open `http://<deployment-url>:3000` and log in with username `gitea_admin` and the password you set.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `gitea.admin.password` | Yes | Admin account password. |
| `gitea.admin.username` | No | Admin username. Default: `gitea_admin`. |
| `gitea.admin.email` | No | Admin email. Default: `gitea_admin@gitea.local`. |
| `persistence.size` | No | PVC size for repositories and data. Default: `10Gi`. |
| `postgresql.auth.password` | No | PostgreSQL password (auto-generated if empty). |

## Ports

| Port | Description |
|------|-------------|
| 3000 | HTTP web UI and Git over HTTP |
| 2222 | Git over SSH |

## Troubleshooting

**Can't push via SSH** — ensure you are using port `2222` (not the standard SSH port 22) in your git remote URL: `ssh://git@<deployment-host>:2222/user/repo.git`

**Admin password forgotten** — contact E2E support. The admin password can be reset via the Gitea admin panel if you have access.

## License

Apache 2.0. Gitea is licensed under the [MIT License](https://github.com/go-gitea/gitea/blob/main/LICENSE).

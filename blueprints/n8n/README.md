# n8n

E2E's Kubernetes deployment of [n8n](https://n8n.io) — the fair-code workflow automation platform connecting 400+ apps and services with a visual editor or code nodes.

## What You Get After Deployment

The E2E Marketplace provisions n8n and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| n8n Web UI | 80 | Visual workflow editor |

Open `http://<deployment-url>` in your browser to access the n8n editor. Create your admin account on first launch.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `env.N8N_ENCRYPTION_KEY` | Yes | Encryption key for stored credentials. Set a strong random value and keep it safe — if lost, stored credentials cannot be decrypted. |
| `env.N8N_BASIC_AUTH_ACTIVE` | No | Enable basic auth on the UI. Default: `false`. |
| `env.N8N_BASIC_AUTH_USER` | No | Basic auth username (if auth enabled). |
| `env.N8N_BASIC_AUTH_PASSWORD` | No | Basic auth password (if auth enabled). |
| `persistence.size` | No | PVC size for workflow data. Default: `1Gi`. |

## Ports

| Port | Description |
|------|-------------|
| 80 | n8n web UI and API |

## Troubleshooting

**Workflows not saving** — the PVC may not be provisioned correctly. Contact E2E support if workflows disappear after restart.

**First run takes 60–90 seconds** — n8n initialises its SQLite database on first boot; this is normal.

**Credentials encrypted with wrong key** — if you change `N8N_ENCRYPTION_KEY` after deployment, all stored credentials become unreadable. Keep this key constant.

## License

Apache 2.0. n8n is licensed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md) (fair-code, source available).

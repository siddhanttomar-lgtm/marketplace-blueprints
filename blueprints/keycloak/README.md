# Keycloak

E2E's Kubernetes deployment of [Keycloak](https://www.keycloak.org) — the open-source Identity and Access Management solution for SSO, social login, MFA, and fine-grained authorization. PostgreSQL is bundled as the backend database.

## What You Get After Deployment

The E2E Marketplace provisions Keycloak and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| Keycloak HTTP | 80 | Web UI and admin console |

Open `http://<deployment-url>/admin` to access the admin console. Log in with the admin username and password you set.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.adminPassword` | Yes | Admin account password. |
| `auth.adminUser` | No | Admin username. Default: `user`. |
| `postgresql.auth.password` | No | PostgreSQL password (auto-generated if empty). |
| `postgresql.primary.persistence.size` | No | PostgreSQL PVC size. Default: `8Gi`. |

## Ports

| Port | Description |
|------|-------------|
| 80 | Keycloak HTTP |
| 443 | Keycloak HTTPS |

## Troubleshooting

**Pod stuck in Pending** — storage provisioning issue. Contact E2E support if the pod does not start within 5 minutes.

**Can't access admin console** — verify the deployment URL in the marketplace dashboard is correct. The admin console is at `<url>/admin`.

**Database not ready** — Keycloak starts after PostgreSQL is ready; allow 3–5 minutes after deployment.

## License

Apache 2.0. Keycloak is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

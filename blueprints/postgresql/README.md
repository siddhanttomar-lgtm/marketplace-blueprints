# PostgreSQL

E2E's Kubernetes deployment of [PostgreSQL](https://www.postgresql.org) — the world's most advanced open-source relational database.

## What You Get After Deployment

The E2E Marketplace provisions a standalone PostgreSQL instance and shows the connection endpoint in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| PostgreSQL | 5432 | PostgreSQL protocol |

Connect your application using: `postgresql://postgres:PASSWORD@<deployment-host>:5432/DATABASE`

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.postgresPassword` | Yes | Superuser (`postgres`) password. |
| `auth.database` | No | Database to create on first start. |
| `auth.username` | No | Additional user to create. |
| `auth.password` | No | Password for the additional user. |
| `primary.persistence.size` | No | PVC size. Default: `8Gi`. |

## Ports

| Port | Description |
|------|-------------|
| 5432 | PostgreSQL client connections |

## Troubleshooting

**Auth failure** — verify the password matches what was set at deployment time. The superuser name is `postgres`.

**Pending pod** — the storage volume may not be provisioning. Contact E2E support if the pod does not start within 5 minutes.

## License

Apache 2.0. PostgreSQL is licensed under the [PostgreSQL License](https://www.postgresql.org/about/licence/).

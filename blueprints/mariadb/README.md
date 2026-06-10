# MariaDB

E2E's Kubernetes deployment of [MariaDB](https://mariadb.org) — the community-developed, drop-in replacement for MySQL with persistent storage.

## What You Get After Deployment

The E2E Marketplace provisions a standalone MariaDB instance and shows the connection endpoint in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| MariaDB | 3306 | MySQL protocol |

Connect your application using: `mysql://USERNAME:PASSWORD@<deployment-host>:3306/DATABASE`

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.rootPassword` | Yes | Root user password. |
| `auth.database` | No | Database to create on first start. |
| `auth.username` | No | Additional user to create. |
| `auth.password` | No | Password for the additional user. |
| `primary.persistence.size` | No | PVC size. Default: `8Gi`. |

## Ports

| Port | Description |
|------|-------------|
| 3306 | MariaDB/MySQL client connections |

## Troubleshooting

**Auth failure** — verify your application is using the correct username and password set at deployment time.

**Slow first start** — MariaDB initialises its data directory on first boot; allow 30–60 seconds.

**Pod crash-loops** — often a storage provisioning issue. Contact E2E support if the pod does not start within 5 minutes.

## License

Apache 2.0. MariaDB is licensed under the [GPLv2](https://mariadb.com/kb/en/mariadb-license/).

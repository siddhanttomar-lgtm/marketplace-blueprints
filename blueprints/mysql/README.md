# MySQL

E2E's Kubernetes deployment of [MySQL](https://www.mysql.com) — the world's most popular open-source relational database.

## What You Get After Deployment

The E2E Marketplace provisions a standalone MySQL instance and shows the connection host and port in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| MySQL | 3306 | MySQL protocol |

Connect your application using: `mysql://USERNAME:PASSWORD@<deployment-host>:3306/DATABASE`

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.rootPassword` | Yes | Root user password. |
| `auth.database` | No | Database name to create on first start. |
| `auth.username` | No | Application user to create. |
| `auth.password` | No | Password for the application user. |
| `primary.persistence.size` | No | PVC size. Default: `8Gi`. |

## Ports

| Port | Description |
|------|-------------|
| 3306 | MySQL client connections |

## Troubleshooting

**Access denied** — verify the password matches what was set at deployment time. Root access requires the root password; application access requires the application user password.

**Slow first start** — MySQL initialises its data directory on first boot, which takes approximately 30 seconds.

**Connection refused** — the pod may still be starting. Allow 60 seconds after deployment before connecting.

## License

GPL-2.0. MySQL is licensed under the [GNU General Public License v2](https://www.mysql.com/about/legal/licensing/oem/).

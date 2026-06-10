# MongoDB

E2E's Kubernetes deployment of [MongoDB](https://www.mongodb.com) — the leading open-source document database.

## What You Get After Deployment

The E2E Marketplace provisions a standalone MongoDB instance and shows the connection endpoint in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| MongoDB | 27017 | MongoDB protocol |

Connect your application using: `mongodb://root:PASSWORD@<deployment-host>:27017`

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.rootPassword` | Yes | Root user password. Required when authentication is enabled. |
| `auth.rootUser` | No | Root username. Default: `root`. |
| `auth.database` | No | Database to create on first start. |
| `auth.username` | No | Additional user to create. |
| `auth.password` | No | Password for the additional user. |
| `persistence.size` | No | PVC size. Default: `8Gi`. |

## Ports

| Port | Description |
|------|-------------|
| 27017 | MongoDB client connections |

## Troubleshooting

**Auth failure** — verify root password and username match what was set during deployment.

**Slow startup** — MongoDB initialises storage on first boot; allow 30–60 seconds.

**Pending pod** — storage provisioning issue. Contact E2E support if the pod does not start within 5 minutes.

## License

Apache 2.0. MongoDB Community Edition is licensed under the [SSPL](https://www.mongodb.com/licensing/server-side-public-license).

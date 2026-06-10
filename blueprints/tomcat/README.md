# Apache Tomcat

E2E's Kubernetes deployment of [Apache Tomcat](https://tomcat.apache.org) — the open-source Java Servlet and JSP container for deploying WAR files and Java web applications.

## What You Get After Deployment

The E2E Marketplace provisions an Apache Tomcat instance and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| HTTP | 8080 | Tomcat web server and Manager UI |

Open the Manager UI at `http://<deployment-url>/manager` and log in with the username and password you set.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `tomcatPassword` | Yes | Tomcat Manager password. |
| `tomcatUsername` | No | Tomcat Manager username. Default: `user`. |
| `persistence.size` | No | PVC size for deployed webapps. Default: `8Gi`. |

## Ports

| Port | Description |
|------|-------------|
| 8080 | HTTP — Tomcat server and `/manager` UI |

## Troubleshooting

**Manager login fails** — verify the username and password match what was set during deployment.

**WAR deploy fails** — verify the Manager role is assigned to the `tomcatUsername` you set.

**Slow startup** — Tomcat with JVM initialisation takes 60–90 seconds on first boot.

## License

Apache 2.0. Apache Tomcat is licensed under the [Apache License 2.0](https://tomcat.apache.org/legal.html).

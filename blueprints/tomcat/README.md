# Apache Tomcat

E2E's Kubernetes deployment of [Apache Tomcat](https://tomcat.apache.org) — the open-source Java Servlet and JSP container. Deploy WAR files and Java web applications with a management UI.

## Architecture

```
  Browser / App → Service (NodePort :8080) → Tomcat Pod → PVC (8Gi)
```

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install tomcat blueprints/tomcat \
  --set service.type=NodePort \
  --set tomcatPassword=YOUR-MANAGER-PASSWORD
```

Using a values file:

```bash
cp blueprints/tomcat/values.example.yaml my-values.yaml
helm install tomcat blueprints/tomcat -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc tomcat -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
# Open http://<node-ip>:$NODE_PORT in your browser
# Manager UI: http://<node-ip>:$NODE_PORT/manager (login: user / <tomcatPassword>)
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `tomcatUsername` | `user` | Tomcat Manager username |
| `tomcatPassword` | `""` | Tomcat Manager password. Required. |
| `service.type` | `LoadBalancer` | Set `NodePort` on bare-metal clusters |
| `persistence.enabled` | `true` | Persist deployed webapps |
| `persistence.size` | `8Gi` | PVC size |
| `persistence.storageClass` | `""` | Leave empty for cluster default |

## Ports

| Port | Default Type | Description |
|------|-------------|-------------|
| 8080 | LoadBalancer | HTTP — set `service.type=NodePort` on bare-metal |

## Troubleshooting

**`LoadBalancer` pending** — set `service.type=NodePort`

**Manager login fails** — verify password: `kubectl get secret tomcat -o jsonpath='{.data.tomcat-password}' | base64 -d`

**WAR deploy fails** — check Manager role is assigned to `tomcatUsername`

## License

Apache 2.0. Apache Tomcat is licensed under the [Apache License 2.0](https://tomcat.apache.org/legal.html).

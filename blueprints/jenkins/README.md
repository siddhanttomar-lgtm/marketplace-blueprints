# Jenkins

E2E's Kubernetes deployment of [Jenkins](https://www.jenkins.io) — the leading open-source automation server for CI/CD pipelines. Pre-configured with persistent storage and plugin management.

## Architecture

```
  Browser        → Service (NodePort :8080) → Jenkins Controller Pod → PVC (10Gi)
  Build Agents   → Service (ClusterIP :50000) ↗  (JNLP agent port)
```

## Requirements

- Kubernetes cluster (2 vCPU, 2GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install jenkins blueprints/jenkins \
  --set jenkinsPassword=YOUR-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/jenkins/values.example.yaml my-values.yaml
helm install jenkins blueprints/jenkins -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc jenkins -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
# Open http://<node-ip>:$NODE_PORT
# Login: user / <jenkinsPassword>
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `jenkinsUsername` | `user` | Jenkins admin username |
| `jenkinsPassword` | `""` | Jenkins admin password. Required. |
| `service.type` | `LoadBalancer` | Set `NodePort` on bare-metal clusters |
| `persistence.size` | `10Gi` | PVC size for jobs and workspace |
| `persistence.storageClass` | `""` | Leave empty for cluster default |
| `plugins` | `[]` | List of Jenkins plugins to install on startup |

## Ports

| Port | Default Type | Description |
|------|-------------|-------------|
| 8080 | LoadBalancer | Web UI — set `service.type=NodePort` on bare-metal |
| 50000 | ClusterIP | JNLP agent connections (internal) |

## Troubleshooting

**Slow startup (3-5 min)** — Jenkins downloads plugins on first boot; this is normal

**`LoadBalancer` pending** — set `service.type=NodePort`

**Password forgotten** — `kubectl get secret jenkins -o jsonpath='{.data.jenkins-password}' | base64 -d`

**Agents can't connect** — verify port 50000 is reachable from agent pods

## License

Apache 2.0. Jenkins is licensed under the [MIT License](https://github.com/jenkinsci/jenkins/blob/master/LICENSE.txt).

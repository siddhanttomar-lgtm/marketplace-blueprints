# n8n

E2E's Kubernetes deployment of [n8n](https://n8n.io) — the fair-code workflow automation platform. Build automation workflows connecting 400+ apps and services with a visual editor or code nodes.

## Architecture

```
  Browser → Service (NodePort :80) → n8n Pod ─→ Valkey (in-cluster queue)
                                              └→ PVC (1Gi, SQLite data)
```

n8n ships with an embedded Valkey (Redis-compatible) instance for job queuing and a SQLite database by default.

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install n8n blueprints/n8n \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/n8n/values.example.yaml my-values.yaml
helm install n8n blueprints/n8n -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc n8n -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:$NODE_PORT in your browser
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `service.type` | `ClusterIP` | Set `NodePort` for browser access |
| `service.port` | `80` | Service port |
| `persistence.enabled` | `true` | Persist workflow data |
| `persistence.size` | `1Gi` | PVC size for n8n data |
| `env.N8N_ENCRYPTION_KEY` | `""` | Encryption key for credentials. Set a strong random value. |
| `env.N8N_BASIC_AUTH_ACTIVE` | `"false"` | Enable basic auth |
| `env.N8N_BASIC_AUTH_USER` | `""` | Basic auth username |
| `env.N8N_BASIC_AUTH_PASSWORD` | `""` | Basic auth password |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 80 | ClusterIP | n8n web UI and API — set `service.type=NodePort` or: `kubectl port-forward svc/n8n 5678:80` |

## Troubleshooting

**Workflows not saving** — verify PVC is bound: `kubectl get pvc`

**Can't access UI remotely** — set `service.type=NodePort`

**First run takes 60-90s** — n8n initializes its database on first boot

## License

Apache 2.0. n8n is licensed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md) (fair-code, source available).

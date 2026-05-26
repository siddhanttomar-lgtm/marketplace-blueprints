# Grafana

E2E's Kubernetes deployment of [Grafana](https://grafana.com) — the open-source analytics and observability platform. Connect your data sources, build dashboards, and set up alerts.

## Architecture

```
  Browser → Service (NodePort :3000) → Grafana Pod → PVC (10Gi)
```

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install grafana blueprints/grafana \
  --set admin.password=YOUR-ADMIN-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/grafana/values.example.yaml my-values.yaml
helm install grafana blueprints/grafana -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc grafana -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:$NODE_PORT in your browser
# Login: admin / <your-password>
```

Or via port-forward (if using ClusterIP default):

```bash
kubectl port-forward svc/grafana 3000:3000
# Open http://localhost:3000
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `admin.user` | `admin` | Admin username |
| `admin.password` | `""` | Admin password. Required. |
| `service.type` | `ClusterIP` | Set `NodePort` for browser access without port-forward |
| `persistence.enabled` | `true` | Persist dashboards and settings |
| `persistence.size` | `10Gi` | PVC size |
| `persistence.storageClass` | `""` | Leave empty for cluster default |
| `grafana.plugins` | `[]` | List of Grafana plugins to install on startup |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 3000 | ClusterIP | Set `service.type=NodePort` or: `kubectl port-forward svc/grafana 3000:3000` |

## Troubleshooting

**Blank dashboard / login loop** — check pod logs: `kubectl logs deploy/grafana`

**Forgot password** — reset via: `kubectl exec deploy/grafana -- grafana-cli admin reset-admin-password NEW-PASSWORD`

**Plugin install fails** — requires internet access from the pod at startup

## License

Apache 2.0. Grafana is licensed under the [GNU AGPL v3](https://github.com/grafana/grafana/blob/main/LICENSE).

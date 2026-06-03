# Keycloak

E2E's Kubernetes deployment of [Keycloak](https://www.keycloak.org) — the open-source Identity and Access Management solution. Provides single sign-on (SSO), social login, MFA, user federation, and fine-grained authorization. PostgreSQL is bundled as the backend database.

## Architecture

```
  Browser / App → Service (NodePort :80) → Keycloak Pod → PVC
                                                │
                                         PostgreSQL Pod → PVC
```

## Requirements

- Kubernetes cluster (1 vCPU, 1GB RAM minimum; 2 vCPU / 2GB recommended)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install keycloak blueprints/keycloak \
  --set auth.adminPassword=YOUR-ADMIN-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/keycloak/values.example.yaml my-values.yaml
helm install keycloak blueprints/keycloak -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc keycloak -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:<NODE_PORT> in your browser
# Admin console: http://<node-ip>:<NODE_PORT>/admin
# Login: user / <your password>
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.adminUser` | `user` | Keycloak admin username |
| `auth.adminPassword` | `""` | Admin password. Required. |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `postgresql.auth.password` | `""` | PostgreSQL password (auto-generated if empty) |
| `postgresql.primary.persistence.size` | `8Gi` | PostgreSQL PVC size |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 80 | ClusterIP | Keycloak HTTP — set `service.type=NodePort` or use port-forward |
| 443 | ClusterIP | Keycloak HTTPS |

Port-forward alternative:

```bash
kubectl port-forward svc/keycloak 8080:80
# Open http://localhost:8080/admin
```

## Troubleshooting

**Pod stuck in Pending** — check PVC binding: `kubectl get pvc`

**Can't access admin console** — verify `service.type=NodePort` and the node IP is reachable

**Password incorrect** — retrieve from secret: `kubectl get secret keycloak -o jsonpath='{.data.admin-password}' | base64 -d`

**Database not ready** — check PostgreSQL pod: `kubectl get pods -l app.kubernetes.io/name=postgresql`

## Upgrading

```bash
helm upgrade keycloak blueprints/keycloak -f my-values.yaml
```

## License

Apache 2.0. Keycloak is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

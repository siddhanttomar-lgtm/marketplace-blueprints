# Nginx

E2E's Kubernetes deployment of [Nginx](https://nginx.org) — the high-performance web server and reverse proxy. Use it to serve static files, act as a reverse proxy, or as a load balancer frontend.

## Architecture

```
  Browser → Service (NodePort :8080) → Nginx Pod → Static files / Proxy upstream
```

## Requirements

- Kubernetes cluster (0.5 vCPU, 64MB RAM minimum)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install nginx blueprints/nginx \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/nginx/values.example.yaml my-values.yaml
helm install nginx blueprints/nginx -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc nginx -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
curl http://<node-ip>:$NODE_PORT
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `service.type` | `LoadBalancer` | Set `NodePort` for bare-metal / non-cloud clusters |
| `serverBlock` | `""` | Custom Nginx server block configuration |
| `replicaCount` | `1` | Number of Nginx replicas |
| `resources.requests.cpu` | `10m` | CPU request |
| `resources.requests.memory` | `128Mi` | Memory request |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 8080 | LoadBalancer | HTTP — set `service.type=NodePort` on bare-metal clusters |
| 8443 | LoadBalancer | HTTPS |

## Troubleshooting

**`ErrImagePull`** — Bitnami Nginx image pull issue; check connectivity to Docker Hub

**502/503 when used as proxy** — verify upstream service is reachable from within the cluster

**`LoadBalancer` stuck in `Pending`** — your cluster has no load balancer provisioner; set `service.type=NodePort`

## License

Apache 2.0. Nginx is licensed under the [2-clause BSD license](https://nginx.org/LICENSE).

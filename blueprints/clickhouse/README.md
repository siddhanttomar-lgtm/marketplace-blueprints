# ClickHouse

E2E's Kubernetes deployment of [ClickHouse](https://clickhouse.com) — the open-source column-oriented OLAP database for real-time analytics. Handles billions of rows with sub-second query response times.

## Architecture

```
  Analytics Client → Service (NodePort :8123 HTTP / :9000 TCP) → ClickHouse Pod → PVC (8Gi)
```

## Requirements

- Kubernetes cluster (2 vCPU, 4GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install clickhouse blueprints/clickhouse \
  --set auth.password=YOUR-PASSWORD \
  --set service.type=NodePort
```

Using a values file:

```bash
cp blueprints/clickhouse/values.example.yaml my-values.yaml
helm install clickhouse blueprints/clickhouse -f my-values.yaml
```

## Connecting

```bash
HTTP_PORT=$(kubectl get svc clickhouse -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
# HTTP client
curl http://default:YOUR-PASSWORD@<node-ip>:$HTTP_PORT/?query=SELECT+version()

# clickhouse-client
clickhouse-client --host <node-ip> --port <tcp-nodeport> --user default --password YOUR-PASSWORD
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `auth.username` | `default` | ClickHouse admin username |
| `auth.password` | `""` | Admin password. Required. |
| `service.type` | `ClusterIP` | Set `NodePort` for external access |
| `persistence.size` | `8Gi` | PVC size for data storage |
| `persistence.storageClass` | `""` | Leave empty for cluster default |
| `shards` | `1` | Number of shards |
| `replicaCount` | `1` | Replicas per shard |

## Ports

| Port | Default Type | Description |
|------|-------------|-------------|
| 8123 | ClusterIP | HTTP interface |
| 9000 | ClusterIP | Native TCP protocol |
| 9004 | ClusterIP | MySQL wire protocol |

Set `service.type=NodePort` to expose all ports externally.

## Troubleshooting

**High memory usage** — ClickHouse is memory-hungry; set `resources.limits.memory` to at least 2Gi

**Query timeout** — increase `max_execution_time` in ClickHouse settings

**Pod crash on startup** — check available memory: `kubectl describe pod -l app.kubernetes.io/name=clickhouse`

## License

Apache 2.0. ClickHouse is licensed under the [Apache License 2.0](https://github.com/ClickHouse/ClickHouse/blob/master/LICENSE).

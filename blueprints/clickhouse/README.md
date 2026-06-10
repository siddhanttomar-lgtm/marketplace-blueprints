# ClickHouse

E2E's Kubernetes deployment of [ClickHouse](https://clickhouse.com) — the open-source column-oriented OLAP database for real-time analytics at scale.

## What You Get After Deployment

The E2E Marketplace provisions a standalone ClickHouse instance and shows the connection endpoints in the dashboard.

| Service | Port | Protocol |
|---------|------|----------|
| ClickHouse HTTP | 8123 | HTTP interface |
| ClickHouse TCP | 9000 | Native TCP protocol |

Connect via HTTP: `http://default:PASSWORD@<deployment-host>:8123`

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.password` | Yes | Admin password for the `default` user. |
| `auth.username` | No | Admin username. Default: `default`. |
| `persistence.size` | No | PVC size. Default: `8Gi`. |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 8123 | HTTP | HTTP query interface |
| 9000 | TCP | Native ClickHouse protocol |
| 9004 | TCP | MySQL wire protocol (for MySQL-compatible clients) |

## Troubleshooting

**High memory usage** — ClickHouse is memory-intensive. Ensure your deployment has at least 2Gi of memory available.

**Query timeout** — long-running queries may need `max_execution_time` increased in ClickHouse settings.

**Pod crash on startup** — insufficient memory. ClickHouse requires at least 4Gi RAM minimum.

## License

Apache 2.0. ClickHouse is licensed under the [Apache License 2.0](https://github.com/ClickHouse/ClickHouse/blob/master/LICENSE).

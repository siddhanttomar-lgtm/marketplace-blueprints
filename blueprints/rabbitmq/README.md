# RabbitMQ

E2E's Kubernetes deployment of [RabbitMQ](https://www.rabbitmq.com) — the widely deployed open-source message broker supporting AMQP, MQTT, STOMP, and more, with a built-in management UI.

## What You Get After Deployment

The E2E Marketplace provisions a RabbitMQ instance and shows two access points in the dashboard:

| Service | Port | Description |
|---------|------|-------------|
| AMQP | 5672 | Application message connections |
| Management UI | 15672 | Browser-based admin interface |

Open the Management UI at `http://<deployment-host>:15672` and log in with the username and password you set.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `auth.username` | No | Admin username. Default: `user`. |
| `auth.password` | Yes | Admin password. |
| `persistence.size` | No | PVC size for message data. Default: `8Gi`. |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 5672 | AMQP | Application connections |
| 15672 | HTTP | Management UI |

## Troubleshooting

**Pod not ready** — RabbitMQ takes 60–90 seconds to start on first boot.

**Auth error** — verify the username and password match what was set during deployment.

**Management UI blank** — wait for the pod to fully start (2–3 minutes), then refresh the page.

## License

Apache 2.0. RabbitMQ is licensed under the [Mozilla Public License 2.0](https://www.rabbitmq.com/mpl.html).

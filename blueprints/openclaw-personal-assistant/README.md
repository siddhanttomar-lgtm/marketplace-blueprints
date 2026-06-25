# OpenClaw Personal Assistant

E2E's Kubernetes deployment of a personal AI assistant powered by the E2E Networks TIR GenAI platform — a private, self-hosted conversational assistant that runs entirely on your own infrastructure with no data leaving your cluster.

## What You Get After Deployment

The E2E Marketplace provisions the OpenClaw assistant and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Control UI | 80 | Personal assistant chat interface |

Open the URL from the marketplace and authenticate with your gateway token. On first visit, the assistant will prompt you for your E2E TIR bearer token.

> **First boot:** Initialization takes 1–2 minutes.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `gateway.token` | Yes | Access token for the assistant. Change from the default before going live. |
| `e2e.bearerToken` | Yes | E2E TIR API bearer token. Get it from E2E Console → TIR → API Tokens. |
| `e2e.modelName` | No | GenAI model to use. Default: `gpt_oss_120b`. Switch models inside the UI at any time. |
| `persistence.size` | No | PVC size for conversation history. Default: `2Gi`. |

## Getting Your E2E TIR Bearer Token

1. Log in to the [E2E Console](https://console.e2enetworks.com).
2. Navigate to **TIR → API Tokens**.
3. Create a new token and copy it.
4. Set it as `e2e.bearerToken` in the deployment form, or paste it when prompted on first login.

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 80 | HTTP | OpenClaw Control UI |

## Troubleshooting

**Assistant not responding:**
```
kubectl logs -l app.kubernetes.io/component=openclaw -c gateway -n <namespace>
```

**"Unauthorized" when connecting to GenAI** — verify your E2E TIR bearer token is correct and the TIR project is active. Tokens can be rotated in E2E Console → TIR → API Tokens.

## License

Apache 2.0.

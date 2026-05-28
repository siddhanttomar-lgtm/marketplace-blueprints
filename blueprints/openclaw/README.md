# OpenClaw

E2E's Kubernetes deployment of [OpenClaw](https://github.com/openclaw/openclaw) — a self-hosted AI gateway with a built-in control UI. Route requests to Claude, GPT-4, Gemini, and other LLM providers through a single authenticated endpoint. Token auth keeps the gateway secure without exposing upstream API keys to end-users.

## Architecture

```
  Client → Service (NodePort :80) → OpenClaw Pod (port 18789) → PVC (2Gi)
                │                         │
            Bearer token              LLM providers
            required                  (Anthropic, OpenAI,
                                       Google, OpenRouter)
```

## Requirements

- Kubernetes cluster (1 vCPU, 512MB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs
- At least one upstream LLM API key

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install openclaw blueprints/openclaw \
  --set gateway.token=YOUR-GATEWAY-TOKEN \
  --set gateway.anthropicApiKey=YOUR-ANTHROPIC-KEY
```

Using a values file:

```bash
cp blueprints/openclaw/values.example.yaml my-values.yaml
helm install openclaw blueprints/openclaw -f my-values.yaml
```

## Connecting

The gateway listens on port 80 (NodePort). Get the assigned port:

```bash
NODE_PORT=$(kubectl get svc openclaw -o jsonpath='{.spec.ports[0].nodePort}')
```

Send a request using your gateway token:

```bash
curl http://<node-ip>:<NODE_PORT>/v1/chat/completions \
  -H "Authorization: Bearer YOUR-GATEWAY-TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"model": "claude-opus-4-5", "messages": [{"role": "user", "content": "Hello"}]}'
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `gateway.token` | `ChangeMe@Gateway123` | Bearer token for gateway access. **Change before production.** |
| `gateway.anthropicApiKey` | `""` | Anthropic API key (for Claude models) |
| `gateway.openaiApiKey` | `""` | OpenAI API key |
| `gateway.geminiApiKey` | `""` | Google Gemini API key |
| `gateway.openrouterApiKey` | `""` | OpenRouter API key |
| `persistence.size` | `2Gi` | PVC size for gateway data |
| `persistence.storageClass` | `""` | StorageClass — leave empty for cluster default |
| `resources.requests.memory` | `512Mi` | Memory request |
| `resources.limits.memory` | `2Gi` | Memory limit |

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 80 | NodePort | OpenClaw gateway HTTP |

The gateway process binds to port 18789 internally; the service maps 80 → 18789.

> **Note:** The gateway process takes ~90 seconds to start after the pod reports Running. The platform ingress becomes available once the process is up.

## Troubleshooting

**401 Unauthorized** — check that you are sending `Authorization: Bearer <token>` with the correct token

**502 / connection refused** — the gateway process may still be starting; wait 90s and retry

**Pod stuck in Pending** — check PVC binding: `kubectl get pvc`

**No models available** — verify at least one upstream API key is configured: `kubectl get secret openclaw -o yaml`

## Upgrading

```bash
helm upgrade openclaw blueprints/openclaw -f my-values.yaml
```

## License

Apache 2.0. OpenClaw is licensed under the [Apache License 2.0](https://github.com/openclaw/openclaw/blob/main/LICENSE).

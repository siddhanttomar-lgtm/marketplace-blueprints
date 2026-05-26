# Claw Analytics Agent

E2E's Kubernetes deployment of the AI Analytics Agent — a natural language interface for website analytics powered by [OpenClaw](https://github.com/openclaw/openclaw), [Umami](https://umami.is), and your choice of LLM. Ask questions about your traffic in plain English via Telegram, Slack, or the built-in web chat.

## Architecture

```
  Telegram/Web → OpenClaw AI Gateway → LLM (Anthropic/OpenAI/Groq)
                                    └→ Umami MCP → Umami → PostgreSQL
```

## Prerequisites

- Kubernetes cluster (2 vCPU, 2 GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs
- At least one LLM API key (Anthropic, OpenAI, or Groq)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install ai-analytics-agent blueprints/ai-analytics-agent \
  --set openclaw.gatewayToken=YOUR-GATEWAY-TOKEN \
  --set openclaw.anthropicApiKey=YOUR-ANTHROPIC-KEY \
  --set umami.adminPassword=YOUR-UMAMI-PASSWORD \
  --set umami.appSecret=$(openssl rand -base64 32) \
  --set postgresql.auth.password=YOUR-DB-PASSWORD \
  --set postgresql.auth.postgresPassword=YOUR-PG-ROOT-PASSWORD
```

Using a values file:

```bash
cp blueprints/ai-analytics-agent/values.example.yaml my-values.yaml
helm install ai-analytics-agent blueprints/ai-analytics-agent -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc ai-analytics-agent-openclaw -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:$NODE_PORT — OpenClaw web chat

# Umami analytics dashboard
kubectl port-forward svc/ai-analytics-agent-umami 3000:3000
# Open http://localhost:3000
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `openclaw.gatewayToken` | `""` | Auth token for the AI gateway. Required. |
| `openclaw.anthropicApiKey` | `""` | Anthropic Claude API key |
| `openclaw.openaiApiKey` | `""` | OpenAI API key |
| `openclaw.groqApiKey` | `""` | Groq API key |
| `telegram.botToken` | `""` | Optional Telegram bot token for chat access |
| `umami.adminPassword` | `""` | Umami dashboard admin password. Required. |
| `umami.appSecret` | `""` | Random secret for Umami sessions. Required. |
| `umami.websiteName` | `""` | Display name for tracked website |
| `umami.websiteDomain` | `""` | Domain to track (e.g. `example.com`) |
| `postgresql.auth.password` | `""` | Database password. Required. |

## Persistence

One PVC is created for PostgreSQL (default 8Gi).

## Troubleshooting

**No LLM responses** — confirm at least one API key is set and the key is valid

**Umami not tracking visits** — add the Umami script tag to your website HTML after deploy

**Telegram bot not responding** — verify `telegram.botToken` is correct and the bot is started

## License

Apache 2.0. Component licenses: OpenClaw (Apache 2.0), Umami (MIT), PostgreSQL (PostgreSQL License).

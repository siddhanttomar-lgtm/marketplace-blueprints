# Claw Sales Agent (B2B SDR)

E2E's Kubernetes deployment of the B2B SDR Agent — an AI-powered sales development representative built on [OpenClaw](https://github.com/openclaw/openclaw) and [Twenty CRM](https://twenty.com). Automate lead qualification, outreach, and CRM pipeline management.

## Architecture

```
  Telegram/Web → OpenClaw AI Gateway → LLM (Anthropic/OpenAI/Groq)
                                    └→ Twenty CRM → PostgreSQL
                                    └→ Redis (queue)
```

## Prerequisites

- Kubernetes cluster (2 vCPU, 2 GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs
- At least one LLM API key (Anthropic, OpenAI, or Groq)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install b2b-sdr-agent blueprints/b2b-sdr-agent \
  --set openclaw.gatewayToken=YOUR-GATEWAY-TOKEN \
  --set openclaw.anthropicApiKey=YOUR-ANTHROPIC-KEY \
  --set twenty.appSecret=$(openssl rand -hex 32) \
  --set postgres.password=YOUR-DB-PASSWORD
```

Using a values file:

```bash
cp blueprints/b2b-sdr-agent/values.example.yaml my-values.yaml
helm install b2b-sdr-agent blueprints/b2b-sdr-agent -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc b2b-sdr-agent-openclaw -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:$NODE_PORT — OpenClaw web chat / SDR interface

# Twenty CRM
kubectl port-forward svc/b2b-sdr-agent-twenty 3000:3000
# Open http://localhost:3000
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `openclaw.gatewayToken` | `""` | Auth token for the AI gateway. Required. |
| `openclaw.anthropicApiKey` | `""` | Anthropic Claude API key |
| `openclaw.openaiApiKey` | `""` | OpenAI API key |
| `openclaw.groqApiKey` | `""` | Groq API key |
| `openclaw.sdrName` | `Alex` | SDR persona name shown in conversations |
| `openclaw.companyName` | `""` | Your company name |
| `openclaw.gmailUser` | `""` | Gmail address for outbound emails |
| `openclaw.gmailAppPassword` | `""` | Gmail App Password (not your account password) |
| `twenty.appSecret` | `""` | 64-char hex secret for Twenty CRM. Required. |
| `twenty.serverUrl` | `""` | External URL for correct CRM links |
| `postgres.password` | `""` | Database password. Required. |
| `telegram.botToken` | `""` | Optional Telegram bot token |

## Persistence

Two PVCs: PostgreSQL data (default 10Gi), OpenClaw storage (default 5Gi).

## Troubleshooting

**Twenty CRM blank page** — set `twenty.serverUrl` to your external URL

**Emails not sending** — use a Gmail App Password, not your account password (myaccount.google.com/apppasswords)

**CRM migrations slow** — Twenty runs DB migrations on startup; allow 2-3 minutes on first boot

## License

Apache 2.0. Component licenses: OpenClaw (Apache 2.0), Twenty CRM (AGPL-3.0).

# OpenClaw Personal Assistant

E2E's Kubernetes deployment of the [OpenClaw](https://github.com/openclaw/openclaw) Personal Assistant — an AI agent that manages your Gmail, Google Calendar, Google Drive, Sheets, and Docs via natural language chat over Telegram or web.

## Architecture

```
  Telegram/Web → OpenClaw AI Gateway → LLM (Anthropic/OpenAI/Groq)
                                    └→ Google APIs (Gmail, Calendar, Drive, Sheets, Docs)
```

## Prerequisites

- Kubernetes cluster (1 vCPU, 1 GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs
- At least one LLM API key (Anthropic, OpenAI, or Groq)
- Google OAuth credentials (for Gmail/Calendar/Drive integration)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install ai-personal-assistant blueprints/ai-personal-assistant \
  --set openclaw.gatewayToken=YOUR-GATEWAY-TOKEN \
  --set openclaw.anthropicApiKey=YOUR-ANTHROPIC-KEY \
  --set openclaw.googleClientId=YOUR-CLIENT-ID \
  --set openclaw.googleClientSecret=YOUR-CLIENT-SECRET \
  --set openclaw.googleRefreshToken=YOUR-REFRESH-TOKEN \
  --set openclaw.gmailAddress=you@gmail.com
```

Using a values file:

```bash
cp blueprints/ai-personal-assistant/values.example.yaml my-values.yaml
helm install ai-personal-assistant blueprints/ai-personal-assistant -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc ai-personal-assistant-openclaw -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:$NODE_PORT — OpenClaw web chat
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `openclaw.gatewayToken` | `""` | Auth token for the AI gateway. Required. |
| `openclaw.anthropicApiKey` | `""` | Anthropic Claude API key |
| `openclaw.openaiApiKey` | `""` | OpenAI API key |
| `openclaw.groqApiKey` | `""` | Groq API key |
| `openclaw.googleClientId` | `""` | Google OAuth client ID |
| `openclaw.googleClientSecret` | `""` | Google OAuth client secret |
| `openclaw.googleRefreshToken` | `""` | Google OAuth refresh token |
| `openclaw.gmailAddress` | `""` | Gmail address to manage |
| `openclaw.gmailSendName` | `Assistant` | Display name for outbound emails |
| `openclaw.googleTranslateKey` | `""` | Optional Google Translate API key |
| `telegram.botToken` | `""` | Optional Telegram bot token |
| `openclaw.storage.size` | `5Gi` | PVC size for assistant data |

## Google OAuth Setup

1. Create OAuth credentials at [Google Cloud Console](https://console.cloud.google.com)
2. Enable: Gmail API, Calendar API, Drive API, Sheets API, Docs API
3. Get a refresh token via [OAuth Playground](https://developers.google.com/oauthplayground)

## Persistence

One PVC is created for OpenClaw data (default 5Gi).

## Troubleshooting

**Google API errors** — verify OAuth scopes include the required APIs and the refresh token is fresh

**Telegram bot not responding** — check `telegram.botToken` and ensure the bot is started via @BotFather

**No LLM response** — confirm at least one API key (`anthropicApiKey`, `openaiApiKey`, or `groqApiKey`) is set

## License

Apache 2.0. OpenClaw is licensed under [Apache 2.0](https://github.com/openclaw/openclaw/blob/main/LICENSE).

# OpenClaw

E2E's Kubernetes deployment of [OpenClaw](https://github.com/openclaw/openclaw) — a self-hosted AI gateway that routes requests to Claude, GPT-4, Gemini, and other LLM providers through a single authenticated endpoint.

## What You Get After Deployment

The E2E Marketplace provisions the OpenClaw gateway and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Gateway | 80 | HTTP API endpoint |

> **Note:** The gateway process takes approximately 90 seconds to start after the pod reports running. The endpoint becomes available once the process is up.

Send requests to: `http://<deployment-url>/v1/chat/completions`  
Include `Authorization: Bearer YOUR-GATEWAY-TOKEN` in every request.

## Before You Deploy — Getting Your Credentials

You need at least one LLM provider API key. Obtain whichever you plan to use:

### Anthropic API Key (for Claude models)
1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Sign up or log in
3. Navigate to **Settings → API Keys → Create Key**
4. Copy the key — it starts with `sk-ant-`

### OpenAI API Key (for GPT models)
1. Go to [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Sign in to your OpenAI account
3. Click **Create new secret key**
4. Copy the key — it starts with `sk-`

### Google Gemini API Key
1. Go to [aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click **Create API key**
4. Copy the key

### OpenRouter API Key (access to 200+ models)
1. Go to [openrouter.ai/settings/keys](https://openrouter.ai/settings/keys)
2. Create an account and click **Create Key**
3. Copy the key — it starts with `sk-or-`

### Gateway Token
This is a password you choose yourself. It protects your gateway from unauthorised use. Pick a strong random string (e.g. 32+ characters). You will use it as the `Authorization: Bearer` token when making API calls.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `gateway.token` | Yes | Bearer token for gateway access. Change the default `ChangeMe@Gateway123`. |
| `gateway.anthropicApiKey` | No | Anthropic API key (for Claude models). At least one LLM key is required. |
| `gateway.openaiApiKey` | No | OpenAI API key. |
| `gateway.geminiApiKey` | No | Google Gemini API key. |
| `gateway.openrouterApiKey` | No | OpenRouter API key. |
| `persistence.size` | No | PVC size for gateway data. Default: `2Gi`. |

## Ports

| Port | Description |
|------|-------------|
| 80 | OpenClaw gateway HTTP (maps to internal port 18789) |

## Troubleshooting

**401 Unauthorized** — verify your request includes `Authorization: Bearer <token>` with the exact token set at deployment.

**502 / connection refused** — the gateway process is still initialising. Wait 90 seconds after deployment and retry.

**No models available** — verify at least one upstream API key is correctly set in your deployment configuration.

## License

Apache 2.0. OpenClaw is licensed under the [Apache License 2.0](https://github.com/openclaw/openclaw/blob/main/LICENSE).

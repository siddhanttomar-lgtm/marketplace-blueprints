# Claw Analytics Agent

E2E's Kubernetes deployment of the AI Analytics Agent — a natural language interface for website analytics powered by [OpenClaw](https://github.com/openclaw/openclaw), [Umami](https://umami.is), and your choice of LLM. Ask questions about your traffic in plain English via Telegram or the built-in web chat.

## What You Get After Deployment

The E2E Marketplace provisions the full analytics stack and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Web Chat | 80 | AI chat interface for querying analytics |
| Umami Dashboard | 3000 | Website analytics dashboard |

Open the OpenClaw web chat at `http://<deployment-url>` and start asking questions like "How many visitors did I get last week?" or "What are my top pages this month?"

Open the Umami dashboard at `http://<deployment-url>:3000` to view raw analytics and add your tracking script to your website.

## Before You Deploy — Getting Your Credentials

### LLM API Key (required — choose one)

**Anthropic API Key** (recommended):
1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Sign up or log in → **Settings → API Keys → Create Key**
3. Copy the key (starts with `sk-ant-`)

**OpenAI API Key:**
1. Go to [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Sign in → **Create new secret key**
3. Copy the key (starts with `sk-`)

**Groq API Key** (fast and free tier available):
1. Go to [console.groq.com/keys](https://console.groq.com/keys)
2. Sign in → **Create API Key**
3. Copy the key

### Telegram Bot Token (optional — for Telegram chat access)
1. Open Telegram and search for **@BotFather**
2. Send `/newbot`
3. Choose a display name (e.g. "My Analytics Bot")
4. Choose a username ending in `bot` (e.g. `myanalytics_bot`)
5. BotFather replies with your token: `1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ`
6. Copy this token — you will need it at deployment

### Gateway Token
Choose a strong password for your AI gateway (32+ random characters). You will use it as the `Authorization: Bearer` token in API requests.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `openclaw.gatewayToken` | Yes | Auth token for the AI gateway. Choose a strong random value. |
| `openclaw.anthropicApiKey` | No | Anthropic Claude API key. At least one LLM key required. |
| `openclaw.openaiApiKey` | No | OpenAI API key. |
| `openclaw.groqApiKey` | No | Groq API key. |
| `telegram.botToken` | No | Telegram bot token from @BotFather (for Telegram chat access). |
| `umami.adminPassword` | Yes | Umami dashboard admin password. |
| `umami.appSecret` | Yes | Random secret for Umami sessions. Use a long random string. |
| `umami.websiteName` | No | Display name for the tracked website in Umami. |
| `umami.websiteDomain` | No | Domain to track (e.g. `example.com`). |
| `postgresql.auth.password` | Yes | Database password. |

## Ports

| Port | Description |
|------|-------------|
| 80 | OpenClaw web chat |
| 3000 | Umami analytics dashboard |

## Troubleshooting

**No LLM responses** — confirm at least one API key is set and the key is valid. Test the key directly with the provider's API.

**Umami not tracking visits** — after deployment, add the Umami tracking script to your website's HTML. Find the script in the Umami dashboard under **Settings → Websites → Get tracking code**.

**Telegram bot not responding** — verify `telegram.botToken` is correct. Open Telegram, find your bot, and send `/start` to activate it.

## License

Apache 2.0. Component licenses: OpenClaw (Apache 2.0), Umami (MIT), PostgreSQL (PostgreSQL License).

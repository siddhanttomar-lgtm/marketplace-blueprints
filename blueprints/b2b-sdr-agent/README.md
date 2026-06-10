# Claw Sales Agent (B2B SDR)

E2E's Kubernetes deployment of the B2B SDR Agent — an AI-powered sales development representative built on [OpenClaw](https://github.com/openclaw/openclaw) and [Twenty CRM](https://twenty.com). Automate lead qualification, outreach, and CRM pipeline management.

## What You Get After Deployment

The E2E Marketplace provisions the SDR agent and CRM and shows access URLs in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw SDR Interface | 80 | AI chat for SDR conversations and lead management |
| Twenty CRM | 3000 | CRM dashboard for managing contacts, companies, and pipeline |

Open the SDR interface at `http://<deployment-url>` to start qualifying leads and managing outreach. Open the CRM at `http://<deployment-url>:3000` to view your pipeline.

## Before You Deploy — Getting Your Credentials

### LLM API Key (required — choose one)

**Anthropic API Key** (recommended):
1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Sign up or log in → **Settings → API Keys → Create Key**
3. Copy the key (starts with `sk-ant-`)

**OpenAI API Key:**
1. Go to [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Sign in → **Create new secret key**, copy the key

**Groq API Key:**
1. Go to [console.groq.com/keys](https://console.groq.com/keys)
2. Sign in → **Create API Key**, copy the key

### Gmail App Password (required for outbound email)

A Gmail App Password lets the SDR agent send emails from your Gmail account without using your actual account password.

**Prerequisites:** Your Gmail account must have 2-Step Verification enabled.

1. Go to [myaccount.google.com](https://myaccount.google.com)
2. Click **Security** in the left menu
3. Under "How you sign in to Google", click **2-Step Verification** (enable it if not already on)
4. Scroll down and click **App passwords** (at the bottom of the 2-Step Verification page)
5. Under "Select app", choose **Mail**
6. Under "Select device", choose **Other (Custom name)** and type a name like `SDR Agent`
7. Click **Generate**
8. Copy the 16-character password shown (no spaces needed — ignore the spaces in the display)

> **Important:** This is not your Gmail account password. It is a separate app-specific password that can be revoked at any time.

### Telegram Bot Token (optional — for Telegram-based SDR interactions)
1. Open Telegram and search for **@BotFather**
2. Send `/newbot` → choose a name and username (must end in `bot`)
3. BotFather replies with your token: `1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ`
4. Copy this token

### Twenty CRM App Secret
Generate a random 64-character hex string to use as the Twenty CRM secret. You can use any password generator — it just needs to be long and random.

### Gateway Token
Choose a strong password for your AI gateway (32+ random characters).

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `openclaw.gatewayToken` | Yes | Auth token for the AI gateway. Choose a strong random value. |
| `openclaw.anthropicApiKey` | No | Anthropic Claude API key. At least one LLM key required. |
| `openclaw.openaiApiKey` | No | OpenAI API key. |
| `openclaw.groqApiKey` | No | Groq API key. |
| `openclaw.sdrName` | No | SDR persona name shown in conversations. Default: `Alex`. |
| `openclaw.companyName` | No | Your company name (shown in outreach emails). |
| `openclaw.gmailUser` | Yes | Gmail address to send outreach from (e.g. `you@gmail.com`). |
| `openclaw.gmailAppPassword` | Yes | Gmail App Password (16-character, from myaccount.google.com/apppasswords). |
| `twenty.appSecret` | Yes | 64-character random hex secret for Twenty CRM. |
| `twenty.serverUrl` | No | External URL of your deployment (for correct CRM links). |
| `postgres.password` | Yes | Database password. |
| `telegram.botToken` | No | Telegram bot token from @BotFather. |

## Ports

| Port | Description |
|------|-------------|
| 80 | OpenClaw SDR interface |
| 3000 | Twenty CRM dashboard |

## Troubleshooting

**Emails not sending** — verify you are using a Gmail App Password (16 characters), not your Gmail account password. App passwords are generated at myaccount.google.com/apppasswords.

**Twenty CRM blank page** — set `twenty.serverUrl` to the external URL of your deployment so CRM internal links resolve correctly.

**CRM migrations slow** — Twenty runs database migrations on first startup; allow 2–3 minutes before the CRM is accessible.

## License

Apache 2.0. Component licenses: OpenClaw (Apache 2.0), Twenty CRM (AGPL-3.0).

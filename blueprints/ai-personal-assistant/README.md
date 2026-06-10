# OpenClaw Personal Assistant

E2E's Kubernetes deployment of the [OpenClaw](https://github.com/openclaw/openclaw) Personal Assistant — an AI agent that manages your Gmail, Google Calendar, Google Drive, Sheets, and Docs via natural language chat over Telegram or the web UI.

## What You Get After Deployment

The E2E Marketplace provisions the personal assistant and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Web Chat | 80 | AI chat interface |

Open `http://<deployment-url>` and start chatting with your assistant. Example commands:
- "Check my Gmail for unread messages"
- "Schedule a meeting tomorrow at 3pm"
- "Create a Google Doc with the title 'Meeting Notes'"

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

### Google OAuth Credentials (required for Gmail/Calendar/Drive access)

**Step 1 — Create a Google Cloud project:**
1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Click **Select a project → New Project**, give it a name, click **Create**

**Step 2 — Enable the required APIs:**
1. Go to **APIs & Services → Library**
2. Search and enable each of these: **Gmail API**, **Google Calendar API**, **Google Drive API**, **Google Sheets API**, **Google Docs API**

**Step 3 — Create OAuth 2.0 credentials:**
1. Go to **APIs & Services → Credentials → Create Credentials → OAuth 2.0 Client ID**
2. If prompted, configure the OAuth consent screen first (External, add your email as a test user)
3. Application type: **Web application**
4. Under **Authorized redirect URIs**, add: `https://developers.google.com/oauthplayground`
5. Click **Create** — copy the **Client ID** and **Client Secret**

**Step 4 — Get a Refresh Token:**
1. Go to [developers.google.com/oauthplayground](https://developers.google.com/oauthplayground)
2. Click the gear icon (⚙) → check **Use your own OAuth credentials**
3. Enter your **Client ID** and **Client Secret**
4. In the left panel, find and select scopes for: Gmail, Google Calendar, Google Drive, Google Sheets, Google Docs
5. Click **Authorize APIs** → sign in with your Google account → allow all permissions
6. Click **Exchange authorization code for tokens**
7. Copy the **Refresh token** value

### Telegram Bot Token (optional — for Telegram access)
1. Open Telegram and search for **@BotFather**
2. Send `/newbot` → choose a name and username (must end in `bot`)
3. BotFather replies with your token: `1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ`
4. Copy this token

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
| `openclaw.googleClientId` | Yes | Google OAuth Client ID (from Google Cloud Console). |
| `openclaw.googleClientSecret` | Yes | Google OAuth Client Secret. |
| `openclaw.googleRefreshToken` | Yes | Google OAuth Refresh Token (from OAuth Playground). |
| `openclaw.gmailAddress` | Yes | Gmail address to manage (e.g. `you@gmail.com`). |
| `openclaw.gmailSendName` | No | Display name for outbound emails. Default: `Assistant`. |
| `openclaw.googleTranslateKey` | No | Google Translate API key (optional). |
| `telegram.botToken` | No | Telegram bot token from @BotFather. |
| `openclaw.storage.size` | No | PVC size for assistant data. Default: `5Gi`. |

## Ports

| Port | Description |
|------|-------------|
| 80 | OpenClaw web chat |

## Troubleshooting

**Google API errors** — verify all five APIs are enabled in your Google Cloud project (Gmail, Calendar, Drive, Sheets, Docs) and that the OAuth consent screen has your account listed as a test user.

**Refresh token expired** — Google refresh tokens for apps in "Testing" status expire after 7 days. Repeat Step 4 of the Google OAuth setup to generate a new one, then redeploy.

**Telegram bot not responding** — verify the token is correct and send `/start` to your bot in Telegram to activate it.

## License

Apache 2.0. OpenClaw is licensed under [Apache 2.0](https://github.com/openclaw/openclaw/blob/main/LICENSE).

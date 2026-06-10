# OpenClaw Project Manager

E2E's Kubernetes deployment of the OpenClaw AI Project Manager — an AI chat gateway connected to a [Plane](https://plane.so) project management backend. Create issues, manage sprints, and run standups through a conversational interface. Optionally integrates with Slack and Telegram.

## What You Get After Deployment

The E2E Marketplace provisions the project manager stack and shows the access URL in the dashboard.

> **Note:** Startup takes 3–5 minutes. Plane runs database migrations on first boot. Wait until the deployment is fully ready before opening the URL.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Gateway | 18789 | Primary AI chat interface |

Open `http://<deployment-url>:18789`, enter your gateway token when prompted, and select **AI Project Manager** from the agent list.

**Example commands:**
- "What projects do I have?"
- "Create an issue: fix the login bug, high priority, assign to alice@company.com"
- "Move issue PROJ-5 to In Progress"
- "Show me today's standup for my active project"
- "Create Sprint 1 starting June 1st and ending June 14th"

**First step after deployment:** Create your Plane workspace using the workspace slug you set in `plane.workspaceSlug`.

## Before You Deploy — Getting Your Credentials

### LLM API Key (required — choose one)

**Anthropic API Key** (recommended):
1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Sign up or log in → **Settings → API Keys → Create Key**
3. Copy the key (starts with `sk-ant-`)

**OpenAI API Key:**
1. Go to [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Sign in → **Create new secret key**, copy the key

**Google Gemini API Key:**
1. Go to [aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)
2. Sign in → **Create API key**, copy the key

**Groq API Key:**
1. Go to [console.groq.com/keys](https://console.groq.com/keys)
2. Sign in → **Create API Key**, copy the key

### Plane Secret Key
Choose a long random string (50+ characters) to use as the Plane Django secret key. This is used to sign session cookies and must remain constant — do not change it after deployment.

### Gateway Token
Choose a strong password for the OpenClaw gateway (32+ random characters). You will enter this when opening the chat interface.

### Slack Bot Token (optional — for standup notifications)
1. Go to [api.slack.com/apps](https://api.slack.com/apps) → **Create New App → From scratch**
2. Give your app a name and select your workspace
3. Go to **OAuth & Permissions → Bot Token Scopes** → add: `chat:write`, `channels:read`
4. Click **Install to Workspace** → copy the **Bot User OAuth Token** (starts with `xoxb-`)
5. Invite the bot to your standup channel: `/invite @your-bot-name` in Slack
6. Copy the channel ID (right-click the channel → **Copy link** — the ID is the last segment, e.g. `C1234567890`)

### Telegram Bot Token (optional — for Telegram-based access)
1. Open Telegram and search for **@BotFather**
2. Send `/newbot` → choose a name and username (must end in `bot`)
3. BotFather replies with your token: `1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ`
4. Copy this token

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `plane.adminEmail` | Yes | Plane admin account email address. |
| `plane.adminPassword` | Yes | Plane admin account password. |
| `plane.secretKey` | Yes | Django secret key — use a long random string. |
| `plane.workspaceSlug` | No | Plane workspace slug. Default: `my-team`. Must match the slug you create in Plane after deployment. |
| `openclaw.gatewayToken` | Yes | Token to authenticate with the OpenClaw gateway. Change the default `PMAgent@12345`. |
| `openclaw.pmName` | No | Display name for the AI agent. Default: `Alex`. |
| `openclaw.anthropicApiKey` | No | Anthropic API key. At least one LLM key required. |
| `openclaw.openaiApiKey` | No | OpenAI API key. |
| `openclaw.googleApiKey` | No | Google Gemini API key. |
| `openclaw.groqApiKey` | No | Groq API key. |
| `slack.botToken` | No | Slack bot token (`xoxb-...`) for standup notifications. |
| `slack.standupChannel` | No | Slack channel ID for standups (e.g. `C1234567890`). |
| `telegram.botToken` | No | Telegram bot token from @BotFather. |
| `postgres.password` | No | PostgreSQL password — auto-generated if left empty. |
| `redis.password` | No | Redis password — auto-generated if left empty. |
| `postgres.storage.size` | No | PostgreSQL PVC size. Default: `10Gi`. |

## Ports

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Gateway | 18789 | Primary user-facing endpoint |
| Plane API | 8000 | Plane REST backend (internal) |
| PostgreSQL | 5432 | Database (internal) |
| Redis | 6379 | Task queue (internal) |

## Troubleshooting

**Agent replies "I couldn't connect to Plane"** — verify `plane.workspaceSlug` in your deployment configuration exactly matches the workspace slug you created in Plane after deployment.

**OpenClaw shows no agents** — the container is still initialising. Wait 3–5 minutes after deployment and refresh.

**Wrong gateway token error** — the token entered in the UI must match `openclaw.gatewayToken` set at deployment.

**Slack not sending standups** — verify the bot has been invited to the standup channel (`/invite @your-bot-name` in Slack) and the channel ID is correct.

## License

Apache 2.0 (chart wrapper). [Plane](https://github.com/makeplane/plane/blob/preview/LICENSE) is AGPL-3.0.

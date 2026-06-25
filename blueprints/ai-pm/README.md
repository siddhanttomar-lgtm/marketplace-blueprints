# AI Project Manager

E2E's Kubernetes deployment of an AI project management assistant connected to [Zoho Sprints](https://www.zoho.com/sprints/) — create tasks, track sprints, generate standups, and log time through natural conversation.

## What You Get After Deployment

The E2E Marketplace provisions the OpenClaw-based PM agent and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Control UI | 80 | AI project manager chat interface |

Open the URL from the marketplace and authenticate with your gateway token.

> **First boot:** Takes 2–3 minutes to start.

## Prerequisites

- A Zoho Sprints workspace. Note your Workspace ID from the Sprints URL.
- Zoho OAuth credentials. Create a Self Client at [api-console.zoho.com](https://api-console.zoho.com/).

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `openclaw.gatewayToken` | Yes | Password to access the PM agent. Change from the default. |
| `zoho.clientId` | Yes | Zoho OAuth Client ID. |
| `zoho.clientSecret` | Yes | Zoho OAuth Client Secret. |
| `zoho.refreshToken` | Yes | Long-lived Zoho OAuth refresh token. |
| `zoho.workspaceId` | Yes | Zoho Sprints Workspace ID. |
| `e2e.bearerToken` | No | E2E TIR bearer token. Can be set in the UI after first login. |
| `slack.botToken` | No | Slack bot token for posting standups to a channel. |
| `slack.standupChannel` | No | Slack channel name for daily standup posts (e.g. `#engineering`). |
| `telegram.botToken` | No | Telegram bot token from @BotFather. |
| `telegram.allowedUserIds` | No | Comma-separated Telegram user IDs allowed to use the bot. |
| `openclaw.pmName` | No | Display name for the PM agent. Default: `Alex`. |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 80 | HTTP | OpenClaw Control UI |

## Example Queries

- "What projects do I have?"
- "Show the active sprint for the backend project"
- "Create a task: fix login bug, high priority, assign to alice@company.com"
- "Move the login bug to the next sprint"
- "Generate today's standup"
- "Log 2 hours on the payment task"
- "Post today's standup to #engineering" *(requires Slack)*

## Troubleshooting

**Agent not responding after 3 minutes:**
```
kubectl logs -l app.kubernetes.io/component=openclaw -c gateway -n <namespace>
```

**Zoho auth errors** — verify `zoho.clientId`, `zoho.clientSecret`, and `zoho.refreshToken` are correct. Refresh tokens may expire if unused for 30 days; regenerate from [api-console.zoho.com](https://api-console.zoho.com/).

## License

Apache 2.0.

# B2B SDR Agent

E2E's Kubernetes deployment of an autonomous B2B Sales Development Representative agent — qualifies inbound leads through chat, scores prospects, drafts personalized outreach emails, and syncs contacts to HubSpot CRM.

## What You Get After Deployment

The E2E Marketplace provisions the OpenClaw-based SDR agent and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Control UI | 80 | SDR agent chat interface and lead management |

Open the URL from the marketplace and authenticate with your gateway token.

> **First boot:** Takes 2–3 minutes for OpenClaw startup and workspace initialization.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `openclaw.gatewayToken` | Yes | Access token for the agent UI. Change from the default. |
| `openclaw.e2eBearerToken` | No | E2E TIR bearer token for GenAI inference. Can be set in the UI after first login. |
| `openclaw.companyName` | No | Your company name (shown in outreach emails). |
| `openclaw.companyDescription` | No | Product description used when drafting outreach. |
| `openclaw.sdrName` | No | SDR persona name shown in conversations. Default: `Alex`. |
| `openclaw.gmailUser` | No | Gmail address for outbound emails and reply polling. Required for autonomous outreach. |
| `openclaw.gmailAppPassword` | No | Gmail App Password (16 chars, from myaccount.google.com/apppasswords). |
| `integrations.hubspot.accessToken` | No | HubSpot Private App token (`pat-na1-...`) for CRM sync. |
| `telegram.botToken` | No | Telegram bot token from @BotFather. |
| `telegram.approvalChatId` | No | Telegram chat ID to receive draft approvals. |
| `outreach.autoOutreachEnabled` | No | `true` = emails send autonomously; `false` (default) = drafts wait for approval. |
| `outreach.leadScoreThreshold` | No | Minimum lead score (0–100) to trigger outreach sequence. Default: `0`. |
| `outreach.maxEmailsPerDay` | No | Hard cap on autonomous outbound emails per day. Default: `50`. |

## How the SDR Pipeline Works

**Interactive lane:** Leads message via Telegram or web chat → agent qualifies with BANT questions → registers lead → syncs to HubSpot.

**Autonomous lane (requires Gmail):** Scores each new lead → auto-outreach for qualifying leads → polls Gmail for replies → handles follow-ups on a configurable cadence.

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 80 | HTTP | OpenClaw Control UI |

## Troubleshooting

**Agent not responding after 3 minutes:**
```
kubectl logs -l app.kubernetes.io/component=openclaw -c gateway -n <namespace>
```

**Autonomous scheduler logs:**
```
kubectl logs -l app.kubernetes.io/component=openclaw -c automation -n <namespace>
```

**Gmail send/receive not working** — ensure IMAP is enabled in Gmail Settings and that you're using a 16-character App Password, not your login password.

**HubSpot sync not active** — set the token via chat if not set at deploy time:
```
node /home/node/.openclaw/workspace/save-hubspot-creds.js pat-na1-...
```

## License

Apache 2.0.

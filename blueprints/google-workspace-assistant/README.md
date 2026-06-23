# Google Workspace Assistant

E2E's Kubernetes deployment of an AI assistant that connects to your Google Workspace — read and send Gmail, manage Calendar events, search Drive, and edit Sheets and Docs, all through a conversational interface powered by the E2E TIR GenAI platform.

## What You Get After Deployment

The E2E Marketplace provisions the OpenClaw-based assistant and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Control UI | 80 | Conversational assistant interface |

Open the URL from the marketplace, authenticate with your gateway token, then start chatting in plain English.

> **First boot:** Initialization takes 30–60 seconds while OpenClaw loads and Google credentials are validated.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `openclaw.gatewayToken` | Yes | Password to access the assistant UI. Change from the default. |
| `openclaw.googleClientId` | Yes | Google OAuth 2.0 Client ID. |
| `openclaw.googleClientSecret` | Yes | Google OAuth 2.0 Client Secret. |
| `openclaw.googleRefreshToken` | Yes | Long-lived OAuth refresh token from Google OAuth Playground. |
| `openclaw.gmailAddress` | Yes | Your Gmail address (e.g. `you@gmail.com`). |
| `openclaw.e2eBearerToken` | No | E2E TIR bearer token. Can be set in the UI after first login. |
| `openclaw.googleTranslateKey` | No | Google Cloud Translation API key (for multi-language support). |
| `telegram.botToken` | No | Telegram bot token from @BotFather (enables Telegram access). |
| `openclaw.storage.size` | No | PVC size for workspace data. Default: `5Gi`. |

## Getting Google OAuth Credentials

1. Go to [console.cloud.google.com](https://console.cloud.google.com) and create or select a project.
2. Enable these APIs: Gmail, Google Calendar, Google Drive, Google Sheets, Google Docs.
3. Create an **OAuth 2.0 Client ID** (Desktop app type) under **APIs & Services → Credentials**.
4. Get a refresh token via [Google OAuth Playground](https://developers.google.com/oauthplayground):
   - Click the gear icon → check **Use your own OAuth credentials** → paste Client ID and Secret.
   - Select scopes: Gmail, Calendar, Drive, Sheets, Docs (all read+write).
   - Authorize → **Exchange authorization code for tokens** → copy the Refresh token.

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 80 | HTTP | OpenClaw Control UI |

## Troubleshooting

**OpenClaw not responding after 3 minutes:**
```
kubectl logs -l app.kubernetes.io/component=openclaw -c gateway -n <namespace>
```

**"invalid_grant" error from Google** — your refresh token has expired. Re-run the OAuth Playground steps to get a new one.

**Google scripts not loading:**
```
kubectl logs -l app.kubernetes.io/component=openclaw -c init-config -n <namespace>
```

## License

Apache 2.0.

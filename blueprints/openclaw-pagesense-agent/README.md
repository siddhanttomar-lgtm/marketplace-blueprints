# OpenClaw PageSense Analyst

E2E's Kubernetes deployment of an AI analyst that connects to [Zoho PageSense](https://www.zoho.com/pagesense/) — ask plain-English questions about your website analytics, A/B test results, funnel drop-offs, and campaign conversions without writing a single query.

## What You Get After Deployment

The E2E Marketplace provisions the OpenClaw-based analyst and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Control UI | 80 | Conversational analytics interface |

Open the URL from the marketplace and authenticate with your gateway token.

> **First boot:** Initialization takes 2–3 minutes while the PageSense MCP server connects to the Zoho API and OpenClaw initializes.

## Prerequisites

- A Zoho PageSense account with the tracking script installed on your website.
- Zoho OAuth credentials. Create a Self Client at [api-console.zoho.com](https://api-console.zoho.com/) with scopes: `ZohoPageSense.reports.READ`, `ZohoPageSense.experiments.READ`, `ZohoPageSense.goals.READ`, `ZohoPageSense.audience.READ`, `ZohoPageSense.customevents.READ`.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `openclaw.gatewayToken` | Yes | Password to access the analyst UI. Change from the default. |
| `zoho.clientId` | Yes | Zoho OAuth Client ID. |
| `zoho.clientSecret` | Yes | Zoho OAuth Client Secret. |
| `zoho.refreshToken` | Yes | Long-lived Zoho OAuth refresh token. |
| `zoho.portalName` | Yes | Your PageSense portal name (from the dashboard URL). |
| `zoho.projectLinkName` | Yes | Project link name shown in the PageSense URL. |
| `zoho.region` | No | Zoho data-center region. Default: `com` (US/global). Options: `eu`, `in`, `com.au`, `jp`. |
| `openclaw.e2eBearerToken` | No | E2E TIR bearer token. Can be set in the UI after first login. |
| `openclaw.gmailUser` | No | Gmail address for scheduled email reports. |
| `openclaw.gmailAppPassword` | No | Gmail App Password (not your login password) for sending reports. |
| `telegram.botToken` | No | Telegram bot token from @BotFather (enables Telegram access). |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 80 | HTTP | OpenClaw Control UI |

## Example Queries

- "Summarise traffic this week"
- "Which campaign converted best this month?"
- "How are my A/B experiments performing?"
- "Where are users dropping off in my checkout funnel?"
- "Which test variant is winning and by how much?"

## Troubleshooting

**OpenClaw not responding after 3 minutes:**
```
kubectl logs -l app.kubernetes.io/component=openclaw -c gateway -n <namespace>
```

**PageSense auth errors or no data:**
```
kubectl logs -l app.kubernetes.io/component=pagesense-mcp -n <namespace>
```
Verify `zoho.clientId`, `zoho.clientSecret`, and `zoho.refreshToken` are correct, and that the PageSense tracking script is installed on your website.

## License

Apache 2.0.

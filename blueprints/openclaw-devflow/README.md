# OpenClaw DevFlow

E2E's Kubernetes deployment of an AI developer productivity agent that connects to GitHub, Slack, Notion, and Jira — automate the full issue-to-PR-to-announcement loop through a single conversational interface.

## What You Get After Deployment

The E2E Marketplace provisions the OpenClaw-based agent and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Control UI | 80 | Conversational developer agent |

Open the URL from the marketplace and authenticate with your gateway token (auto-generated if not set).

> **First boot:** Initialization takes 2–3 minutes. Plugin MCP servers are fetched via `npx` on first use and cached on the PVC.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `openclaw.gatewayToken` | No | Access token for the agent UI. Auto-generated if left blank. |
| `openclaw.e2eBearerToken` | No | E2E TIR bearer token. Can be set in the UI after first login. |
| `plugins.github.enabled` | No | Enable GitHub integration. Default: `false`. |
| `plugins.github.personalAccessToken` | No | GitHub Personal Access Token (classic or fine-grained). Required when GitHub is enabled. |
| `plugins.slack.enabled` | No | Enable Slack integration. Default: `false`. |
| `plugins.slack.botToken` | No | Slack bot token (starts with `xoxb-`). Required when Slack is enabled. |
| `plugins.slack.teamId` | No | Slack workspace/team ID (e.g. `T01234567`). |
| `plugins.notion.enabled` | No | Enable Notion integration. Default: `false`. |
| `plugins.notion.integrationToken` | No | Notion internal integration token (starts with `secret_` or `ntn_`). |
| `plugins.jira.enabled` | No | Enable Jira integration. Default: `false`. |
| `plugins.jira.host` | No | Atlassian site host (e.g. `yourcompany.atlassian.net`). |
| `plugins.jira.email` | No | Atlassian account email. |
| `plugins.jira.apiToken` | No | Atlassian API token from `id.atlassian.com`. |
| `telegram.botToken` | No | Telegram bot token from @BotFather (enables Telegram access). |
| `persistence.size` | No | PVC size for plugin cache. Default: `5Gi`. |

> Enable at least one plugin — deploying with all plugins disabled produces a working agent with no tools.

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 80 | HTTP | OpenClaw Control UI |

## Example Queries

- "List my open pull requests in `acme/web`" *(GitHub)*
- "Create a TODO for this task on the launch page" *(Notion)*
- "Post a summary of today's deploys to #eng" *(Slack)*
- "What's blocking PROJ-142?" *(Jira)*
- "Take this task, make a Notion TODO, open a GitHub PR, then reply on #dev when it's done."

## Troubleshooting

**Find your auto-generated gateway token:**
```
kubectl get secret <release>-credentials -n <namespace> \
  -o jsonpath='{.data.OPENCLAW_GATEWAY_TOKEN}' | base64 -d; echo
```

**Gateway not responding after 3 minutes:**
```
kubectl logs -l app.kubernetes.io/component=openclaw -c gateway -n <namespace>
```

**A plugin isn't working** — confirm the plugin is enabled AND its credential is set. Check which plugins loaded:
```
kubectl logs -l app.kubernetes.io/component=openclaw -c init-config -n <namespace>
```

## License

Apache 2.0.

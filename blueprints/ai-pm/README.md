# OpenClaw Project Manager

E2E's Kubernetes deployment of the OpenClaw AI Project Manager — an AI chat gateway (OpenClaw) connected to a [Plane](https://plane.so) project management backend. Lets you create issues, manage sprints, and run standups through a conversational interface. Optionally integrates with Slack and Telegram.

## Architecture

```
  Browser / Chat Client
        │
  ┌─────▼──────────────────────────────────┐
  │  OpenClaw Gateway (NodePort :18789)      │
  │  AI Project Manager agent ("Alex")       │
  └──────────────────────────────────────────┘
        │ creates/reads issues via REST
  ┌─────▼──────────────────────────────────┐
  │  Plane API (ClusterIP :8000)             │
  │  + Plane Worker + Plane Beat             │
  └──────────────────────────────────────────┘
        │
  ┌─────▼────────────┐  ┌────────────────┐
  │  PostgreSQL :5432 │  │  Redis :6379   │
  │  (Plane DB)       │  │  (task queue)  │
  └───────────────────┘  └────────────────┘
```

## Prerequisites

- Kubernetes cluster (650m CPU, 1.5Gi RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs
- At least one LLM API key (Anthropic, OpenAI, Google, or Groq)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install ai-pm blueprints/ai-pm \
  --set plane.adminEmail=admin@example.com \
  --set plane.adminPassword=YOUR-PLANE-PASSWORD \
  --set plane.secretKey=YOUR-SECRET-KEY \
  --set openclaw.anthropicApiKey=YOUR-ANTHROPIC-KEY
```

Using a values file:

```bash
cp blueprints/ai-pm/values.example.yaml my-values.yaml
helm install ai-pm blueprints/ai-pm -f my-values.yaml
```

> **Note:** Startup takes 3–5 minutes. Plane runs database migrations and creates the AI agent API token during the first-boot Job. Wait until all pods are `Running` before opening the URL.

## Accessing

1. Open the deployment URL shown in the E2E Marketplace UI (OpenClaw on port 18789).
2. Enter the `openclaw.gatewayToken` when prompted.
3. Select **AI Project Manager** from the agent list.
4. First step: create your Plane workspace using the slug set in `plane.workspaceSlug`.

Example commands:
```
"What projects do I have?"
"Create an issue: fix the login bug, high priority, assign to alice@company.com"
"Move issue PROJ-5 to In Progress"
"Show me today's standup for my active project"
"Create Sprint 1 starting June 1st and ending June 14th"
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `plane.adminEmail` | `""` | Plane admin account email |
| `plane.adminPassword` | `""` | Plane admin account password |
| `plane.secretKey` | `""` | Django secret key — set a long random string |
| `plane.workspaceSlug` | `my-team` | Plane workspace slug — must match the slug you create in Plane |
| `openclaw.gatewayToken` | `PMAgent@12345` | Token to authenticate with the OpenClaw gateway — change before production |
| `openclaw.pmName` | `Alex` | Display name for the AI agent |
| `openclaw.anthropicApiKey` | `""` | Anthropic API key |
| `openclaw.openaiApiKey` | `""` | OpenAI API key |
| `openclaw.googleApiKey` | `""` | Google Gemini API key |
| `openclaw.groqApiKey` | `""` | Groq API key |
| `postgres.password` | `""` | PostgreSQL password — auto-generated if left empty |
| `redis.password` | `""` | Redis password — auto-generated if left empty |
| `slack.botToken` | `""` | Slack bot token for standup notifications (optional) |
| `slack.standupChannel` | `""` | Slack channel ID for standups (optional) |
| `telegram.botToken` | `""` | Telegram bot token (optional) |
| `postgres.storage.size` | `10Gi` | PostgreSQL PVC size |

## Ports

| Service | Port | Description |
|---------|------|-------------|
| OpenClaw Gateway | 18789 (NodePort) | Primary user-facing endpoint |
| Plane API | 8000 (ClusterIP) | Plane REST backend (internal) |
| PostgreSQL | 5432 (ClusterIP) | Database (internal) |
| Redis | 6379 (ClusterIP) | Task queue (internal) |

## Troubleshooting

**Agent replies "I couldn't connect to Plane"** — verify `plane.workspaceSlug` in values matches the workspace slug you created in Plane, and that the Plane migrator Job completed: `kubectl get jobs`

**Plane API pod `CrashLoopBackOff`** — DB migrations may have failed. Check: `kubectl logs job/<release-name>-migrator`

**OpenClaw shows no agents** — the container is still initialising. Wait 3–5 minutes and refresh.

**Wrong gateway token error** — token in the UI must match `openclaw.gatewayToken` set during install.

## License

Apache 2.0 (chart wrapper). [Plane](https://github.com/makeplane/plane/blob/preview/LICENSE) is AGPL-3.0.

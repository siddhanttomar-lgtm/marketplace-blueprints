# Contributing to marketplace-blueprints

This guide walks you through everything you need to add a new blueprint or improve an existing one — from forking the repo to tagging a release.

---

## What You Need Before You Start

Make sure these are installed on your machine:

- **Git** — `git --version`
- **Helm v3** — `helm version` (install: https://helm.sh/docs/intro/install/)
- **kubectl** — `kubectl version --client` (install: https://kubernetes.io/docs/tasks/tools/)
- A running Kubernetes cluster to test your chart

---

## Step 1 — Fork and Clone

**1.1 Fork the repository**

Go to https://github.com/e2enetworks-oss/marketplace-blueprints and click **Fork** (top-right).

**1.2 Clone your fork**

```bash
git clone https://github.com/<your-username>/marketplace-blueprints.git
cd marketplace-blueprints
```

**1.3 Add the upstream remote**

```bash
git remote add upstream https://github.com/e2enetworks-oss/marketplace-blueprints.git
```

**1.4 Create a branch for your work**

Use the format `blueprint/{name}` for new charts, or `fix/{name}-{issue}` for bug fixes:

```bash
git checkout -b blueprint/myapp
```

---

## Step 2 — Create the Blueprint Folder

Every blueprint lives under `blueprints/{name}/` where `{name}` is lowercase and hyphen-separated (e.g. `n8n`, `apisix`, `my-app`).

**Use the scaffolding script to create the folder skeleton automatically:**

```bash
bash scripts/create-blueprint.sh <name> "<Display Name>" "<description>" "<appVersion>"
```

Example:
```bash
bash scripts/create-blueprint.sh my-tool "My Tool" "Brief description of my tool" "1.0.0"
```

This creates `blueprints/my-tool/` with all required files pre-filled. Then edit the `TODO` placeholders and continue with the steps below.

**Required structure:**

```
blueprints/{name}/
├── Chart.yaml              ← chart metadata (name, version, appVersion)
├── values.yaml             ← all defaults
├── values.example.yaml     ← example config for users — no real credentials
├── .helmignore             ← keeps docs out of the packaged TGZ
├── README.md               ← what it does, ports, quick-start
├── charts/                 ← vendored dependencies (only if chart has dependencies)
├── Chart.lock              ← pinned dependency versions (only if chart has dependencies)
└── templates/              ← Kubernetes manifests
    └── ...
```

**2.1 Chart.yaml**

```yaml
apiVersion: v2
name: myapp
description: A short description of what this deploys
type: application
version: 1.0.0          # chart version — use semver, start at 1.0.0
appVersion: "2.5.0"     # the actual upstream software version
```

- `version` is the Helm chart version. Bump it when you change the chart.
- `appVersion` is the version of the software inside the chart (e.g. `"1.122.4"` for n8n 1.122.4).

**2.2 values.example.yaml rules**

- Never include real credentials, API keys, or IP addresses
- Use obvious placeholders: `"YOUR-PASSWORD-HERE"`, `"YOUR-NODE-IP"`
- Only include values a user is likely to customise

Example:

```yaml
auth:
  password: "YOUR-STRONG-PASSWORD"

persistence:
  size: 8Gi

service:
  type: NodePort
```

**2.3 .helmignore**

This keeps documentation files out of the packaged chart TGZ:

```
README.md
values.example.yaml
```

**2.4 README.md format**

Use this structure (customers deploy via the E2E Marketplace UI — no kubectl or helm commands):

```
# {Display Name}

One or two sentences — what it deploys and what it's useful for. Include upstream project link.

## What You Get After Deployment

Table of services, ports, and descriptions. Include the access URL format.

## Before You Deploy — Getting Your Credentials  (only for blueprints that require external API keys)

Step-by-step instructions to obtain each required credential from the external provider
(e.g. Anthropic API key, Google OAuth credentials, Telegram bot token).

## Configuration

Table of parameters the user fills in on the E2E Marketplace deployment form.
Columns: Parameter | Required | Description

## Ports

Table of service ports — verify these against your actual service templates.

## Troubleshooting

Common issues and how to fix them. No kubectl or cluster commands — use observable symptoms
and dashboard-visible signals only.

## License

Upstream project license.
```

---

## Step 3 — Validate Locally

Before pushing, run the validation script:

```bash
bash scripts/validate.sh
```

This runs `helm lint` and `helm template` on every chart in `blueprints/`. It will print errors if anything is wrong.

You can also lint just your chart:

```bash
helm lint blueprints/{name} --strict
```

And do a dry-run render to check all templates produce valid YAML:

```bash
helm template test blueprints/{name} --dry-run
```

Fix any errors before moving on. The CI pipeline runs the same checks and will block your PR if they fail.

---

## Step 4 — Test on a Real Cluster

Deploy your chart to a Kubernetes cluster before opening a PR:

```bash
cp blueprints/{name}/values.example.yaml my-test-values.yaml
# Edit my-test-values.yaml with your real values

helm install test-release blueprints/{name} -f my-test-values.yaml
kubectl get pods
```

Wait until the pod shows `Running` and `READY 1/1`. Then verify the application actually works — connect to it, check the UI, or run a health check.

When done:

```bash
helm uninstall test-release
```

---

## Step 5 — Update the Main README

Open the root `README.md` and add your blueprint to the **Available Blueprints** table:

```markdown
| [My App](blueprints/myapp/README.md) | 2.5.0 | Category |
```

Keep the table sorted by category, then alphabetically by name within each category.

---

## Step 6 — Commit and Push

Before committing, update the root README:

1. **`README.md`** — add your blueprint to the Available Blueprints table

Then stage and commit:

```bash
git add blueprints/{name}/
git add README.md
git commit -m "feat: add {name} blueprint v{appVersion}"
git push origin blueprint/{name}
```

---

## Step 7 — Open a Pull Request

Go to your fork on GitHub and click **Compare & pull request**.

Fill in the PR template:
- What the blueprint deploys and the upstream project URL
- Which Kubernetes versions / cluster types you tested on
- Screenshot or output showing it works

The lint CI will run automatically. It must pass before your PR can be merged.

---

## Step 8 — Tag a Release (After Merge)

After your PR is merged into `main`, create a release tag. Use the format `{name}-v{chart-version}`:

```bash
git checkout main
git pull upstream main
git tag n8n-v2.0.8
git push upstream n8n-v2.0.8
```

This triggers the release workflow which:
1. Packages the chart into a `.tgz`
2. Creates a GitHub Release with the file attached
3. Updates the Helm index on the `gh-pages` branch

After a few minutes, the chart will be available via:

```bash
helm repo update
helm search repo e2enetworks/{name}
```

---

## Improving an Existing Blueprint

The process is the same — fork, branch, change, validate, PR — except:

- Use branch format `fix/{name}-{short-description}` (e.g. `fix/n8n-persistence-default`)
- Bump `version` in `Chart.yaml` for any chart change (even docs-only fixes)
- Do not change `appVersion` unless you are updating to a new upstream software release

---

## Code of Conduct

Be respectful. If you find a security issue, see [SECURITY.md](SECURITY.md) instead of opening a public issue.

For bugs and feature requests: [GitHub Issues](https://github.com/e2enetworks-oss/marketplace-blueprints/issues)

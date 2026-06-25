# Developer Guide

Reference for engineers onboarding a new blueprint into the platform.

---

## Instructions for AI Assistants (Claude, GPT, etc.)

> **If you are an AI assistant reading this file to help a developer onboard a blueprint, follow this exact sequence. Read all the steps in this file first so you understand the full flow before asking anything.**
>
> **Phase 1 — Collect credentials (do this first, before any other work)**
>
> 1. Ask: *"What is the name of the blueprint you want to create?"* — wait for reply.
> 2. Ask: *"Do you already have a `.env.blueprint` file set up in the `marketplace-api` repo?"* — if yes, skip to Phase 2. If no, continue.
> 3. Ask: *"Share your Bearer token, API key, and DB password."* — wait for reply.
> 4. Ask: *"Which environment are you targeting — reply `first` to auto-pick, or paste your environment ID."* — wait for reply.
> 5. Tell the developer to run `cp .env.blueprint.example .env.blueprint` and fill in only: `BLUEPRINT_BEARER_TOKEN`, `BLUEPRINT_API_KEY`, `BLUEPRINT_DB_PASSWORD`, `BLUEPRINT_ENV_STRATEGY`. All other values in the example file are already correct — do not change them.
> 6. Do NOT ask about anything else. All other config is pre-set.
>
> **Phase 2 — Walk through each step interactively. Show one step at a time, wait for the developer to confirm it is done, then move to the next.**
>
> 7. **Product entry** — Guide the developer to add a catalog entry in `scripts/blueprint/catalog.py` (name, short description, highlights, logo URL, categories, version title). Refer to Step 1 in this file. Wait for confirmation before continuing.
> 8. **Helm chart** — Guide the developer to create `blueprints/{name}/` in this repo with `Chart.yaml`, `values.yaml`, `values.example.yaml`, `.helmignore`, `README.md`. Run `helm lint blueprints/{name} --strict` and confirm it passes. Refer to Step 2 in this file. Wait for confirmation before continuing.
> 9. **Blueprint source + services + variables** — Explain that these are handled automatically by the runner (Steps 3 and 4 in this file). No manual action needed — just confirm the catalog entry has `source_type`, `chart_name`, `chart_version`, `service`, and `variables` filled in correctly.
> 10. **Run the runner** — Show the command below and wait for the developer to confirm it ran and share the output before continuing:
>     ```bash
>     python scripts/blueprint/runner.py "<blueprint name>"
>     ```
>     Walk through the runner output one step at a time. If any step fails, diagnose using the Common Failures table in this file. Do not retry blindly.
> 11. **S3 packaging** — Confirm Step 6 (package) in the runner output shows `OK`. If it was skipped with `--no-package`, remind the developer to re-run without that flag after verifying the chart works.
> 12. **Verify** — Ask the developer to open the URL from the runner output and confirm the app responds. If it does not, ask for pod logs before diagnosing.
> 13. **Post-deploy checklist** — Remind the developer to insert legal terms and refund policy records in the DB. The product will not appear fully in the marketplace UI without these.

---

## Overview

Each blueprint has two components that must be in sync before it is live:

| Component | Where | Purpose |
|-----------|-------|---------|
| Helm chart | This repo (`blueprints/{name}/`) | What gets deployed on the customer's cluster |
| Platform registration | `marketplace-api` runner + catalog | How the marketplace UI presents and deploys it |

Both must be done. A chart without a catalog entry cannot be deployed via the platform. A catalog entry without a working chart will fail at deploy time.

---

## Step 1 — Create the Product Entry

Before touching any chart files, register the product in the platform.

A product has two levels:
- **Product** — the top-level listing (name, logo, categories, description, vendor)
- **Version** — a specific release under that product (version title, release notes, the chart source)

These are created via the internal API. All required fields and their constraints are documented in the runner catalog (`scripts/blueprint/catalog.py`). The `name`, `logo_url`, `categories`, and `short_description` fields feed directly into what end users see on the marketplace listing page.

Valid categories: `Databases`, `Developer Tools`.

Logo URL must resolve to a `.png`, `.jpg`, `.jpeg`, or `.svg` file — CDN URLs from devicons or vectorlogo.zone work reliably.

---

## Step 2 — Write the Helm Chart

Once the product and version exist, prepare the chart that backs this version.

The chart lives in this repo under `blueprints/{name}/`. For Bitnami-based blueprints, it is a thin wrapper that pins a specific upstream chart version and sets E2E platform defaults (NodePort service type, resource requests, persistence size).

Every chart must pass `helm lint --strict` before it is considered ready. The CI pipeline enforces this on every PR via `make lint`.

Key things the chart must do:
- Pin an explicit `chart_version` — never use `latest` or floating versions
- Set `service.type: NodePort` for externally accessible services
- Set `resources.requests.cpu` to a reasonable value — the platform cluster is CPU-constrained
- Avoid boolean values in `helm_extra_config` — the deploy engine processes all override values as strings

---

## Step 3 — Register the Blueprint Source

The blueprint source links the platform version record to the Helm chart. It tells the deploy engine where to fetch the chart (OCI registry or Helm repo URL), what chart name and version to use, and how to build the connection URL after deploy.

This step is handled by the runner (Step 4 in the 13-step flow). The runner attempts the API endpoint first; if the API server does not have Helm installed, it falls back to a direct DB insert.

Fields set at this step:
- `source_type` — `oci` for Bitnami OCI charts, `helm_repo` for standard repo
- `chart_name`, `chart_version`
- `helm_extra_config` — JSON dict of Helm value overrides (strings only)
- `url_rebuild_strategy` — `none` for template blueprints, `credentials` for database blueprints

---

## Step 4 — Register Services and Variables

This is the DB step. The API does not expose service or variable registration, so these are inserted directly via `db_ops.py`.

A **service** maps to a Kubernetes workload (Deployment or StatefulSet). Most blueprints have one primary service. Multi-workload blueprints (e.g. a chart that deploys both an app and a database) can have additional services.

A **variable** is any value a user can configure before deploying — passwords, persistence size, resource limits. Each variable must be registered with:
- `key` matching the Helm values path (e.g. `auth.password`)
- `input_type` — `string`, `password`, `select`, `number`
- `is_user_configurable: 1`

**The silent drop rule:** `build_helm_values()` on the deploy engine ignores any key supplied at deploy time that is not registered as a variable in the DB. No error is raised. The value is silently discarded. This means every key in `default_deploy_variables` must have a corresponding variable row — the runner's Step 9 validates this before deploying.

---

## Step 5 — Package to S3

After the chart source and variables are registered, the chart is packaged and uploaded to internal object storage. This sets `packaged_chart_key` on the blueprint source record.

When `packaged_chart_key` is set, the deploy engine uses the pre-packaged TGZ directly (~5s deploy). Without it, the engine downloads and validates the chart from the OCI/Helm registry at deploy time (~2 minutes).

Always run packaging after verifying a new blueprint for the first time. Use `--no-package` only during initial validation runs.

---

## Step 6 — Enable the Product

The product and version start in a disabled state. The state-transition API call flips them to `enabled=1` and `state=In Production`. After this, the blueprint appears in the marketplace UI and can be deployed by customers.

---

## Step 7 — Deploy and Verify

The runner fires a deploy using the registered `default_deploy_variables` and polls until `status=live`. Default timeout is 72 attempts × 10s = 12 minutes (configurable via `BLUEPRINT_POLL_MAX_ATTEMPTS`). A successful run prints the final URL.

The deploy status progresses through: `pending → cloning → provisioning → installing → configuring_ingress → extracting_credentials → live`. On failure the status moves to `rolling_back` before stopping.

After the runner completes:
1. Open the URL and confirm the application responds
2. Verify the marketplace UI shows the correct status, URL, and connection info
3. If the UI shows stale state, the deployment record and product state may need a direct DB correction — this happens occasionally when the Temporal workflow completes but the status write races with a stale connection

Legal terms and refund policy records are required for the product to appear fully in the customer UI. These are inserted as part of the post-deploy DB verification checklist.

---

## Runner Quick Reference

```bash
# Full run
python scripts/blueprint/runner.py "Blueprint Name"

# Register only — skip deploy
python scripts/blueprint/runner.py "Blueprint Name" --no-deploy

# Skip S3 packaging
python scripts/blueprint/runner.py "Blueprint Name" --no-package

# Override variables
python scripts/blueprint/runner.py "Blueprint Name" --variables auth.password=Pass@123
```

Environment config lives in `.env.blueprint` (gitignored). Copy from `.env.blueprint.example`.

---

## Known Platform Constraints

- Bitnami images moved registries post-2025-08-28. Sub-charts whose parent `values.yaml` has an empty sub-chart section (e.g. `mariadb: {}`) do not get remapped automatically. Fix: set `<subchart>.image.repository=bitnamilegacy/<name>` in `helm_extra_config`.
- Charts that define ClusterRole or ClusterRoleBinding will be rejected by the platform's admission controller on the multi-tenant cluster.
- JVM-based applications (SonarQube, Elasticsearch) frequently exceed the 600-second deploy timeout on the constrained cluster.
- The pricing API endpoint has a known server-side bug and always returns 500. The runner treats this as non-fatal. Pricing rows are not required for a blueprint to function.
- The deploy engine disables chart-managed ingress at deploy time. The platform injects its own auth-proxy ingress. Never set `ingress.enabled=true` in `helm_extra_config` — it is overridden regardless.
- Multi-service blueprints (app + bundled sub-chart) can register additional services via `extra_services` in the catalog spec. Variables are routed to the correct service via the `service_name` field on each variable.

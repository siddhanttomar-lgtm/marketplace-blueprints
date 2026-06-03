# marketplace-blueprints — Claude Instructions

## What This Repo Is

Production-ready Helm charts for the E2E Cloud Marketplace. Every folder under `blueprints/` is one self-contained chart that gets deployed on customer Kubernetes clusters via the E2E Marketplace platform.

This repo is **public**. Never write internal IPs, API URLs, DB credentials, product IDs, or any E2E internal system details into any file here.

---

## Repo Structure

```
blueprints/{name}/          ← one chart per blueprint
    Chart.yaml              ← name, version, appVersion (must match upstream)
    values.yaml             ← platform defaults (NodePort, resource requests, persistence)
    values.example.yaml     ← user-facing example — no real credentials
    .helmignore             ← excludes README.md and values.example.yaml from TGZ
    README.md               ← user-facing docs (ports, quick-start, config table)
    templates/              ← K8s manifests (or NOTES.txt for wrapper charts)
scripts/
    validate.sh             ← helm lint + helm template dry-run on all charts
    new-blueprint.sh        ← scaffolding script — creates a new blueprint skeleton
.github/workflows/
    lint-charts.yaml        ← runs make lint on every PR touching blueprints/
    gitleaks.yml            ← secret scan on every push and PR
    release.yaml            ← chart-releaser: package + publish to gh-pages on tag push
Makefile                    ← lint and validate targets
CONTRIBUTING.md             ← how to add a new blueprint (public-facing)
DEVELOPER.md                ← internal onboarding guide + AI assistant instructions
```

---

## Chart Conventions

- `appVersion` in `Chart.yaml` must match the actual upstream software version exactly
- `version` in `Chart.yaml` is the Helm chart version — start at `1.0.0`, bump on every chart change
- `service.type` defaults to `NodePort` for externally accessible services
- `resources.requests.cpu` must always be set — the platform cluster is CPU-constrained
- Never use `latest` or floating chart versions — always pin explicitly
- Wrapper/umbrella charts with no custom templates must have a `templates/NOTES.txt` or `helm lint --strict` will fail

---

## CI/CD

- **lint-charts.yaml** — triggers on PRs that touch `blueprints/**`. Runs `make lint` (helm lint --strict on all charts). Must pass before merge.
- **gitleaks.yml** — triggers on every push and PR. Scans for secrets. Must pass before merge.
- **release.yaml** — triggers when a tag matching `{name}-v{version}` is pushed. Packages chart → GitHub Release → updates Helm index on `gh-pages`.

---

## What NOT to Do

- Do not add internal E2E details (IPs, API endpoints, product IDs, DB credentials) to any file
- Do not modify `scripts/validate.sh` or `Makefile` without testing locally first
- Do not change `chart-dirs` in `.cr.yaml` — chart-releaser depends on it
- Do not commit `my-values.yaml` or any file matching `*-secret.yaml`
- Do not push directly to `main` — all changes go through PRs
- Do not bump `appVersion` without also verifying the upstream chart version is available

---

## Adding a New Blueprint

Use the scaffolding script — it creates the full folder skeleton:

```bash
bash scripts/new-blueprint.sh <name> "<display name>" "<one-line description>" "<upstream version>"
```

Example:
```bash
bash scripts/new-blueprint.sh mysql "MySQL" "MySQL relational database" "8.4.0"
```

Then fill in `values.yaml`, complete `README.md`, and run:

```bash
helm lint blueprints/<name> --strict
```

Full contribution steps are in `CONTRIBUTING.md`. Internal platform registration steps are in `DEVELOPER.md`.

---

## Helm Lint

Run lint on all charts:
```bash
make lint
```

Run lint on a single chart:
```bash
helm lint blueprints/<name> --strict
```

Run full validation (lint + template dry-run):
```bash
make validate
```

# marketplace-blueprints

Helm chart blueprints for marketplace-ready application deployments.

## Purpose

This repository is used to:

- store Helm charts under `blueprints/`
- scaffold new blueprints with a standard structure
- run local and CI validation for charts and scripts
- publish chart releases from GitHub Actions

## Repository Layout

```text
.
├── blueprints/              # Helm charts live here
├── scripts/
│   ├── create-blueprint.sh  # scaffold a new blueprint
│   └── validate.sh          # lint + template all charts
├── .github/workflows/       # CI and release workflows
├── Makefile                 # local helper commands
└── .cr.yaml                 # chart-releaser config
```

## Local Checks

Run these before opening a PR:

```bash
shellcheck scripts/*.sh
actionlint
yamllint .github/workflows
make test
make lint
make validate
```

Notes:

- `actionlint` is the main local validator for GitHub Actions workflows
- `yamllint` may show harmless warnings for GitHub Actions files because of the `on:` key

## Creating a New Blueprint

Use the scaffold script:

```bash
bash scripts/create-blueprint.sh <name> "<Display Name>" "<description>" "<appVersion>"
```

Example:

```bash
bash scripts/create-blueprint.sh redis "Redis" "In-memory data store" "7.2.5"
```

After scaffolding:

```bash
make lint
make validate
```

## Release Flow

- charts are read from `blueprints/`
- chart-releaser publishes to the `gh-pages` branch
- release config is stored in `.cr.yaml`

Current `.cr.yaml`:

```yaml
chart-dirs:
  - blueprints
pages-branch: gh-pages
```

## CI Workflows

- `gitleaks.yml`: scans the repository for secrets
- `lint-charts.yaml`: runs Helm lint and dry-run template validation
- `release.yaml`: publishes chart releases on matching tags

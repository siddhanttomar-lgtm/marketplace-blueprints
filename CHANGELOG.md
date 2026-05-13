# Changelog

All notable changes to this repository are documented here.
Each entry covers a chart release or a repository-level change.

---

## [Unreleased]

### Added
- `CLAUDE.md` — AI assistant instructions and repo conventions
- `scripts/new-blueprint.sh` — scaffolding script to create a new blueprint skeleton
- `.github/workflows/gitleaks.yml` — secret scanning on every push and PR
- `DEVELOPER.md` — internal onboarding guide with AI assistant instructions
- Template dry-run step added to CI (`lint-charts.yaml`) via `make validate`

---

## 2026-05-07 — Initial blueprint library (24 charts)

### Added
- `redis` 7.4.1 — Redis in-memory cache
- `postgresql` 18.3.0 — PostgreSQL relational database
- `mongodb` 8.2.6 — MongoDB document database
- `mariadb` 12.2.2 — MariaDB relational database
- `memcached` 1.6.41 — Memcached in-memory cache
- `influxdb` 3.4.1 — InfluxDB time-series database
- `clickhouse` 25.7.5 — ClickHouse analytical database
- `rabbitmq` 4.1.3 — RabbitMQ message broker
- `nats` 2.11.8 — NATS messaging system
- `kafka` 4.0.0 — Apache Kafka event streaming
- `grafana` 12.1.1 — Grafana observability platform
- `nginx` 1.29.6 — Nginx web server
- `tomcat` 11.0.20 — Apache Tomcat application server
- `wordpress` 6.9.1 — WordPress CMS
- `drupal` 11.2.3 — Drupal CMS
- `phpmyadmin` 5.2.2 — phpMyAdmin database UI (bundled MariaDB)
- `redmine` 5.1.4 — Redmine project management
- `gitea` 1.24.5 — Gitea self-hosted Git service
- `jenkins` 2.516.2 — Jenkins CI/CD
- `jenkins-maven` 2.492 — Jenkins with Maven build support
- `keycloak` 26.3.3 — Keycloak identity and access management
- `openclaw` slim — OpenClaw AI/LLM gateway
- `etcd` 3.6.4 — etcd distributed key-value store
- `n8n` 1.122.4 — n8n workflow automation

### Repository
- `README.md` — user-facing deployment guide (Steps 1–7)
- `CONTRIBUTING.md` — full contribution guide (fork → PR → release tag)
- `SECURITY.md` — vulnerability reporting policy
- `Makefile` — `lint` and `validate` targets
- `scripts/validate.sh` — local helm lint + template dry-run
- `.github/workflows/lint-charts.yaml` — CI lint gate on PRs
- `.github/workflows/release.yaml` — chart-releaser publish on tag push
- `.github/PULL_REQUEST_TEMPLATE.md` — PR checklist
- `.cr.yaml` — chart-releaser config

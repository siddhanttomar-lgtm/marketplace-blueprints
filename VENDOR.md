# Vendor Guide — E2E Cloud Marketplace

The E2E Cloud Marketplace lets end users deploy production-ready software with a single click. This guide is for vendors and open-source maintainers who want to **propose a new blueprint** or **contribute one directly**. Vendor can open a request or submit a pull request. All blueprints are reviewed by the E2E platform team before going live.

---

## What Can Be Listed

### Container

* Lightweight, portable application packages with all dependencies included
* Full control over container lifecycle and scaling
* Best for cloud-native applications, microservices, and GPU-accelerated AI/ML workloads

### Blueprint

* Multi-component solutions combining containers, networking, and storage
* One-click deployment of complete, AI ready application stacks
* Best for full-stack solutions, AI pipelines, analytics platforms, and enterprise use cases

We actively prioritise blueprints in the following areas:

* **AI / ML** — LLM gateways, RAG pipelines, vector databases, model serving, AI agents
* **SaaS & Productivity** — collaboration tools, CMS platforms, project management
* **Security** — identity providers, secret management, API gateways
* **Enterprise infrastructure** — databases, message queues, caching, CI/CD

---

## Before You Start — Understand the Repository

Read these files in order. They give you everything you need to understand how blueprints are structured and what standards they must meet.

**Step 1 — Repository overview**

Read [`README.md`](README.md). It covers the full list of available blueprints, the directory structure, versioning rules, and how the CI/CD pipeline works.

**Step 2 — Contribution standards**

Read [`CONTRIBUTING.md`](CONTRIBUTING.md). It covers code style, required files per blueprint, how to run lint checks locally, and the pull request checklist every submission must pass.

**Step 3 — Study an existing blueprint**

Pick a blueprint similar to what you want to add and read through its files:

```
blueprints/<name>/
├── Chart.yaml              ← chart name, version, appVersion
├── values.yaml             ← all default settings with comments
├── values.example.yaml     ← user-facing example (what deployers copy)
├── templates/              ← Kubernetes manifests
└── README.md               ← what it does, ports, env vars, quick-start
```

Good references to study:

| If your blueprint is... | Study this |
|------------------------|-----------|
| A web application / automation | [`blueprints/n8n`](blueprints/n8n/) |
| An API gateway | [`blueprints/apisix`](blueprints/apisix/) |
| A multi-component AI agent | [`blueprints/openclaw-personal-assistant`](blueprints/openclaw-personal-assistant/) |
| A developer tool | [`blueprints/jenkins-maven`](blueprints/jenkins-maven/) |
| A GPU / HPC workload | [`blueprints/vss`](blueprints/vss/) |

**Step 4 — Run validation locally**

Before submitting, run the lint and dry-run check on your chart:

```bash
helm lint blueprints/<your-blueprint> --strict
```

To run validation across all charts:

```bash
make validate
```

All checks must pass before opening a pull request.

---

## Option A — Request a New Blueprint

If you want E2E to build and maintain a blueprint (rather than contributing it yourself), open a GitHub Issue using the template below.

**How to open a request:**

1. Go to [Issues → New Issue](../../issues/new)
2. Use the title format: `[Blueprint Request] <Product Name>`
3. Fill in every field in the template below

> Incomplete requests will be closed. The more detail you provide, the faster we can evaluate and build it.

---

### Issue Template

```
**Blueprint Request: <Product Name>**

---

## Overview

**Product name:**
<!-- The exact name as it should appear in the marketplace. E.g. "Apache APISIX", "AI Chat Workspace" -->

**Type:**
<!-- Choose one: Container / Blueprint -->

**One-line description:**
<!-- What does this product do? E.g. "Open-source vector database for AI-native applications" -->

---

## Infrastructure Requirements

| Requirement | Value |
|-------------|-------|
| **Minimum CPU / vCPU** | e.g. 2 vCPU |
| **Minimum RAM** | e.g. 4 GB |
| **Minimum Storage** | e.g. 20 GB SSD |
| **GPU Requirements** | e.g. None / 1× NVIDIA A100 40 GB / 2× T4 |
| **GPU Memory** | e.g. N/A / 40 GB per GPU |
| **Recommended CPU** | e.g. 4 vCPU |
| **Recommended RAM** | e.g. 8 GB |
| **Recommended Storage** | e.g. 100 GB SSD |
| **Persistent storage needed?** | Yes / No |

---

## Architecture

**Number of components:**
<!-- E.g. 1 (single container) / 3 (app + database + cache) -->

**Component list (if multi-component):**
<!--
- App server (the main service)
- PostgreSQL (persistence)
- Redis (caching/queues)
-->

**External dependencies:**
<!-- Does this require an external API key, licence key, or third-party service to function? -->

**Default ports:**
<!--
- 8080 — HTTP UI
- 5432 — PostgreSQL
-->

---

## Vendor / Submitter Information

**Your name or organisation:**

**Contact email:**

```

---

## Option B — Contribute a Blueprint Directly

If you want to build and submit the blueprint yourself, follow the [Contributing Guide](CONTRIBUTING.md) and open a pull request. Your PR must:

* Pass all CI checks (`helm lint`, template dry-run, gitleaks secret scan)
* Include `Chart.yaml`, `values.yaml`, `values.example.yaml`, and `README.md`
* Set `appVersion` to the actual software version (not the chart version)
* Use pinned image tags — never `latest` or `main`
* Not bundle secrets or credentials in default values

The E2E platform team reviews every submission for security, resource sizing, and deployment reliability before merging.

---

## Review Process

| Stage | What happens |
|-------|-------------|
| **Submission** | Issue opened or PR created |
| **Initial review** | E2E team checks completeness within 2 business days |
| **Build & test** | E2E builds the chart, and verifies it |
| **Security review** | Images, default credentials, and RBAC are reviewed |
| **Live** | Blueprint published to the marketplace |

We will comment on your issue or PR with status updates.

---

## Questions

If you have a question before opening an issue, you can reach the marketplace team at **cloud-platform@e2enetworks.com**.

---

**Get started today:** [marketplace.e2enetworks.com](https://marketplace.e2enetworks.com)

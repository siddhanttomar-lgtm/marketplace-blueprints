# marketplace-blueprints

**Production-ready Helm charts for the [E2E Cloud Marketplace](https://marketplace.e2enetworks.com).**

Every blueprint in this repository is a fully self-contained Kubernetes deployment — tested, versioned, and ready to run. The charts are open-source so you can see exactly what gets deployed on your cluster.

---

## Available Blueprints

| Blueprint | Version | Category |
|-----------|---------|----------|
| [Redis](blueprints/redis/README.md) | 7.4.1 | Databases / Cache |
| [PostgreSQL](blueprints/postgresql/README.md) | 18.3.0 | Databases |
| [MongoDB](blueprints/mongodb/README.md) | 8.2.6 | Databases |
| [MariaDB](blueprints/mariadb/README.md) | 12.2.2 | Databases |
| [Memcached](blueprints/memcached/README.md) | 1.6.41 | Databases / Cache |
| [InfluxDB](blueprints/influxdb/README.md) | 3.4.1 | Databases |
| [ClickHouse](blueprints/clickhouse/README.md) | 25.7.5 | Databases |
| [RabbitMQ](blueprints/rabbitmq/README.md) | 4.1.3 | Messaging |
| [NATS](blueprints/nats/README.md) | 2.11.8 | Messaging |
| [Kafka](blueprints/kafka/README.md) | 4.0.0 | Messaging |
| [Grafana](blueprints/grafana/README.md) | 12.1.1 | Monitoring |
| [Nginx](blueprints/nginx/README.md) | 1.29.6 | Web Servers |
| [Apache Tomcat](blueprints/tomcat/README.md) | 11.0.20 | Web Servers |
| [WordPress](blueprints/wordpress/README.md) | 6.9.1 | CMS |
| [Drupal](blueprints/drupal/README.md) | 11.2.3 | CMS |
| [phpMyAdmin](blueprints/phpmyadmin/README.md) | 5.2.2 | Developer Tools |
| [Redmine](blueprints/redmine/README.md) | 5.1.4 | Developer Tools |
| [Gitea](blueprints/gitea/README.md) | 1.24.5 | Developer Tools |
| [Jenkins](blueprints/jenkins/README.md) | 2.516.2 | Developer Tools |
| [Jenkins + Maven](blueprints/jenkins-maven/README.md) | 2.492 | Developer Tools |
| [Keycloak](blueprints/keycloak/README.md) | 26.3.3 | Security |
| [OpenClaw](blueprints/openclaw/README.md) | slim | AI / LLM Gateway |
| [etcd](blueprints/etcd/README.md) | 3.6.4 | Databases / Storage |
| [n8n](blueprints/n8n/README.md) | 1.122.4 | Automation |

> New blueprints are added regularly. To propose or contribute one, see [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Local Validation Checks

Before opening a PR, run the relevant local checks:

```bash
shellcheck scripts/*.sh
actionlint
yamllint .github/workflows .charts-releaser.yaml
lychee --offline README.md CONTRIBUTING.md DEVELOPER.md SECURITY.md
make test
make lint
make validate
```

What each check covers:

- `shellcheck` validates the shell scripts under `scripts/`
- `actionlint` validates GitHub Actions workflow structure and expressions
- `yamllint` checks workflow YAML formatting and `.cr.yaml`
- `lychee --offline` checks local Markdown links without depending on external network availability
- `make lint` and `make validate` run the Helm chart checks for everything under `blueprints/`

CI mirrors these checks through:

- `repo-checks.yaml` for scripts, workflows, YAML, and Markdown links
- `lint-charts.yaml` for Helm chart lint and template validation
- `gitleaks.yml` for secret scanning
- `release.yaml` for chart packaging and release publishing

---

## How to Deploy a Blueprint

Follow these steps exactly, in order.

---

### Step 1 — Check Prerequisites

Before you start, make sure you have all of these installed on your local machine:

**1.1 Helm v3**

```bash
helm version
```

You should see something like `version.BuildInfo{Version:"v3.x.x"...}`.
If not, install it: https://helm.sh/docs/intro/install/

**1.2 kubectl**

```bash
kubectl version --client
```

If not installed: https://kubernetes.io/docs/tasks/tools/

**1.3 A running Kubernetes cluster**

```bash
kubectl get nodes
```

All nodes should show `Ready`. If not, fix your cluster before continuing.

---

### Step 2 — Clone This Repository

Run this on your local machine:

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
```

Move into the folder:

```bash
cd marketplace-blueprints
```

You should now see a `blueprints/` folder with one subfolder per blueprint.

---

### Step 3 — Pick a Blueprint

List all available blueprints:

```bash
ls blueprints/
```

Each subfolder is one blueprint (e.g. `redis`, `postgresql`, `wordpress`).

Read what a blueprint does and what it needs before deploying it:

```bash
cat blueprints/<name>/README.md
```

Replace `<name>` with your chosen blueprint, for example:

```bash
cat blueprints/redis/README.md
```

---

### Step 4 — Configure Your Values

Every blueprint has an example configuration file. Copy it:

```bash
cp blueprints/<name>/values.example.yaml my-values.yaml
```

Open `my-values.yaml` in any text editor and fill in your values. For example, for Redis:

```bash
cp blueprints/redis/values.example.yaml my-values.yaml
```

Then edit `my-values.yaml`:

```yaml
auth:
  password: "MyStrongPassword123"   # ← change this

persistence:
  size: 8Gi

service:
  type: NodePort
```

> **Important:** Never commit `my-values.yaml` to Git — it contains your passwords. It is already excluded by `.gitignore`.

To see every available option and its default value:

```bash
helm show values blueprints/<name>
```

---

### Step 5 — Deploy

Install the blueprint onto your cluster:

```bash
helm install <release-name> blueprints/<name> -f my-values.yaml
```

- `<release-name>` — any name you choose (e.g. `my-redis`, `prod-postgres`)
- `<name>` — the blueprint folder name (e.g. `redis`, `postgresql`)

Example — deploy Redis:

```bash
helm install my-redis blueprints/redis -f my-values.yaml
```

Check that the pod is starting:

```bash
kubectl get pods
```

Wait until the pod shows `Running` and `READY` is `1/1`. This may take 30–120 seconds depending on the blueprint.

---

### Step 6 — Access Your Application

Once the pod is `Running`, get the connection details.

**For NodePort services** (most blueprints):

```bash
kubectl get svc <release-name>
```

Look at the `PORT(S)` column. The number after the colon (e.g. `6379:31234/TCP`) is your NodePort. Connect to it using your node's IP and that port.

**For ClusterIP services** (admin UIs, dashboards):

Use port-forward to access them locally:

```bash
kubectl port-forward svc/<release-name> 8080:80
```

Then open `http://localhost:8080` in your browser.

Each blueprint's `README.md` has the exact connection command for that specific app.

---

### Step 7 — Upgrade or Uninstall

**To upgrade** (after changing `my-values.yaml`):

```bash
helm upgrade <release-name> blueprints/<name> -f my-values.yaml
```

**To uninstall:**

```bash
helm uninstall <release-name>
```

> **Note:** Uninstalling does not delete your persistent data (PVCs). To delete data permanently:
> ```bash
> kubectl delete pvc --all
> ```
> Only run this if you are sure. It cannot be undone.

---

## Helm Repository

> **Note:** The commands below work only after the first chart has been officially released and GitHub Pages is active. Until then, use the steps above (installing from source) — they always work.

Once available, you can add this repo to Helm and install charts without cloning:

```bash
helm repo add e2enetworks https://e2enetworks-oss.github.io/marketplace-blueprints
helm repo update
helm search repo e2enetworks
```

Then install any blueprint directly:

```bash
helm install my-redis e2enetworks/redis --set auth.password=MyPassword
```

**How the Helm repository works:**
When a new chart version is tagged and released, GitHub Actions automatically packages the chart and publishes an index to the `gh-pages` branch of this repository. GitHub Pages serves that index at the URL above. You do not need to do anything — it is fully automated.

---

## Repository Structure

```
marketplace-blueprints/
├── blueprints/
│   └── {name}/
│       ├── Chart.yaml              ← chart name, version, app version
│       ├── values.yaml             ← all default settings
│       ├── values.example.yaml     ← copy this and fill in your values
│       ├── values.schema.json      ← validates your inputs (where present)
│       ├── .helmignore             ← keeps docs out of the packaged chart
│       ├── templates/              ← Kubernetes manifests
│       └── README.md               ← what it does, ports, quick-start
├── scripts/
│   ├── create-blueprint.sh         ← scaffolds a new blueprint folder
│   └── validate.sh                 ← runs lint + dry-run on all charts locally
├── .github/
│   └── workflows/
│       ├── repo-checks.yaml        ← checks scripts, workflows, and docs
│       ├── lint-charts.yaml        ← runs on every pull request
│       ├── gitleaks.yml            ← scans for secrets
│       └── release.yaml            ← runs when a version tag is pushed
├── Makefile                        ← shortcuts for lint and validate
├── .cr.yaml                        ← chart-releaser configuration
├── .yamllint                       ← yamllint configuration used locally and in CI
├── CONTRIBUTING.md                 ← how to add or improve a blueprint
└── SECURITY.md                     ← how to report security issues
```

---

## Versioning

Each blueprint is versioned independently. There are two version fields in every `Chart.yaml`:

| Field | What it means | Example |
|-------|--------------|---------|
| `version` | The Helm chart version — bump this whenever you change the chart | `1.0.0` |
| `appVersion` | The version of the actual software inside the chart | `"7.4.1"` for Redis 7.4.1 |

**How releases work:**

A release is triggered by pushing a Git tag in the format `{name}-v{version}`:

```bash
git tag redis-v1.0.0
git push origin redis-v1.0.0
```

This triggers the CI workflow which:
1. Packages the chart into a `.tgz`
2. Creates a GitHub Release with the file attached
3. Updates the Helm index on `gh-pages` so `helm repo update` picks it up

---

## Docs

| | |
|--|--|
| [Contributing](CONTRIBUTING.md) | How to add a new blueprint or improve an existing one |
| [Developer Guide](DEVELOPER.md) | Internal notes for maintainers |

---

## Security

See [SECURITY.md](SECURITY.md) for how to report vulnerabilities.

---

## License

Charts in this repository are licensed under the [Apache License 2.0](LICENSE).
Third-party software deployed by these charts is subject to its own license — see each blueprint's `README.md` for details.

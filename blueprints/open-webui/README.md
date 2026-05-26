# Open WebUI with Ollama

E2E's Kubernetes deployment of [Open WebUI](https://github.com/open-webui/open-webui) bundled with [Ollama](https://ollama.com) — a private, self-hosted LLM workspace. Chat with local language models without sending data to external APIs.

## Architecture

```
  Browser → Service (NodePort :8080) → Open WebUI Pod → PVC (2Gi)
                                                       └→ Ollama Pod → PVC (20Gi models)
```

## Prerequisites

- Kubernetes cluster (2 vCPU, 4 GB RAM minimum; GPU optional)
- StorageClass supporting `ReadWriteOnce` PVCs
- Internet access from pods (to pull models on first use)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install open-webui blueprints/open-webui \
  --set webui.adminEmail=admin@example.com \
  --set webui.adminPassword=YOUR-PASSWORD
```

Using a values file:

```bash
cp blueprints/open-webui/values.example.yaml my-values.yaml
helm install open-webui blueprints/open-webui -f my-values.yaml
```

## Accessing

```bash
NODE_PORT=$(kubectl get svc open-webui -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:$NODE_PORT in your browser
# Login with the admin email and password you set
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `model` | `qwen2.5:0.5b` | Default model pulled on first startup |
| `webui.adminEmail` | `""` | Admin account email. Required. |
| `webui.adminPassword` | `""` | Admin account password. Required. |
| `webui.storage.size` | `2Gi` | PVC size for Open WebUI data |
| `ollama.storage.size` | `20Gi` | PVC size for Ollama models |
| `ollama.gpu.enabled` | `false` | Enable GPU scheduling for Ollama |
| `ollama.resources.requests.memory` | `2Gi` | Memory for Ollama (increase for larger models) |

## Persistence

Two PVCs are created:
- **Open WebUI data** (`webui.storage.size`, default 2Gi) — chat history and settings
- **Ollama models** (`ollama.storage.size`, default 20Gi) — downloaded model weights

## Ports

| Port | Notes |
|------|-------|
| 8080 | Open WebUI web interface |
| 11434 | Ollama API (internal) |

## Troubleshooting

**Models not loading** — Ollama pulls models on first use; check logs: `kubectl logs deploy/open-webui-ollama`

**Out of memory** — increase `ollama.resources.limits.memory` for models larger than 3B parameters

**GPU not detected** — ensure `ollama.gpu.enabled: true` and your cluster has GPU nodes with the nvidia device plugin

## License

Apache 2.0. Open WebUI is licensed under the [MIT License](https://github.com/open-webui/open-webui/blob/main/LICENSE).

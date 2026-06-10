# Open WebUI with Ollama

E2E's Kubernetes deployment of [Open WebUI](https://github.com/open-webui/open-webui) bundled with [Ollama](https://ollama.com) — a private, self-hosted LLM workspace. Chat with local language models without sending data to external APIs.

## What You Get After Deployment

The E2E Marketplace provisions Open WebUI with an embedded Ollama model server and shows the access URL in the dashboard.

> **Note:** On first deployment, Ollama downloads the selected model weights (several GB). Full readiness takes 5–15 minutes. The UI will show a loading state until the model is ready.

| Service | Port | Description |
|---------|------|-------------|
| Open WebUI | 8080 | Chat interface |

Open `http://<deployment-url>:8080` in your browser and log in with the admin email and password you set.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `webui.adminEmail` | Yes | Admin account email address. |
| `webui.adminPassword` | Yes | Admin account password. |
| `model` | No | Default model to pull on first startup. Default: `qwen2.5:0.5b`. |
| `webui.storage.size` | No | PVC size for chat history and settings. Default: `2Gi`. |
| `ollama.storage.size` | No | PVC size for downloaded model weights. Default: `20Gi`. Increase for larger models. |
| `ollama.gpu.enabled` | No | Enable GPU scheduling for Ollama. Default: `false`. |
| `ollama.resources.requests.memory` | No | Memory for Ollama. Default: `2Gi`. Increase for models larger than 3B parameters. |

## Ports

| Port | Description |
|------|-------------|
| 8080 | Open WebUI web interface |
| 11434 | Ollama API (internal) |

## Troubleshooting

**Models not loading** — Ollama pulls the model on first use; this can take 5–15 minutes. Wait and refresh the page.

**Out of memory** — increase `ollama.resources.limits.memory`. Models over 3B parameters need more than the default 2Gi.

**GPU not detected** — ensure `ollama.gpu.enabled: true` and your cluster node has a GPU with the NVIDIA device plugin installed.

## License

Apache 2.0. Open WebUI is licensed under the [MIT License](https://github.com/open-webui/open-webui/blob/main/LICENSE).

# Nvidia Video Search and Summarization (VSS)

E2E's Kubernetes deployment of the [NVIDIA VSS Blueprint](https://docs.nvidia.com/vss/) v3.1.0 — a full-stack AI video intelligence platform. Enables chat Q&A over video content, video upload and management, semantic search, real-time AI alerts, and long-video RAG summarization. Requires an NGC API key and a GPU node.

## Architecture

```
  Browser
    │
  ┌─▼──────────────────────────────────────────────┐
  │  VSS UI (port 30890)                             │
  │  Tabs: Chat │ Video Management │ Search │ Alerts │
  └──────────────┬─────────────────────────┬─────────┘
                 │                         │
  ┌──────────────▼──────┐   ┌──────────────▼──────┐
  │  VSS Agent           │   │  VST Ingress         │
  │  (port 30889)        │   │  (port 30892)        │
  │  Chat, tools, RAG    │   │  Upload + management │
  └──────────────┬───────┘   └──────────────────────┘
                 │
  ┌──────────────▼───────────────────────────┐
  │  NIM Pods (GPU required)                  │
  │  Cosmos-Reason2-8B (VLM) + Nemotron (LLM) │
  │  ~40GB model weights pulled from NGC      │
  └────────────────────────────────────────────┘
```

## Prerequisites

- Kubernetes cluster with at least one GPU node (H100, L40S, or RTXPRO6000BW)
- NVIDIA NGC API key (`nvapi-...`) — required to pull all `nvcr.io` images and download NIM model weights
- 80GB+ GPU memory for NIM pods (Cosmos VLM + Nemotron LLM)
- StorageClass supporting `ReadWriteOnce` PVCs

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install vss blueprints/vss \
  --set ngcApiKey=nvapi-YOUR-NGC-KEY \
  --set externalIp=YOUR-NODE-PUBLIC-IP
```

Using a values file:

```bash
cp blueprints/vss/values.example.yaml my-values.yaml
helm install vss blueprints/vss -f my-values.yaml
```

> **Note:** NIM pods download ~40GB of model weights from NGC on first start. Full readiness takes 15–30 minutes depending on network speed.

## Accessing

Once all pods are `Running`:

| Interface | URL | Description |
|-----------|-----|-------------|
| VSS UI | `http://<node-ip>:30890` | Chat, video management, search, alerts |
| VSS Agent API | `http://<node-ip>:30889` | REST API for programmatic access |
| VST Video Management | `http://<node-ip>:30892/vst` | Upload and manage video files |

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `ngcApiKey` | `""` | NGC API key — required |
| `externalIp` | `""` | Public IP of the GPU node |
| `hfToken` | `""` | HuggingFace token (optional, improves download rate limits) |
| `nim.hardwareProfile` | `H100` | GPU hardware profile: `H100`, `L40S`, `RTXPRO6000BW`, `AGX-THOR` |
| `gpu.deviceIds` | `0` | GPU device ID for VST services |
| `gpu.vlmDeviceId` | `0` | GPU device ID for Cosmos VLM |
| `gpu.llmDeviceId` | `0` | GPU device ID for Nemotron LLM |
| `kafka.enabled` | `false` | Enable Kafka — required for Search and Alerts tabs |
| `rtviEmbed.enabled` | `false` | Enable semantic video search (requires Kafka + GPU + ~10GB model) |
| `rtviVlm.enabled` | `false` | Enable real-time AI alerts (requires Kafka) |
| `lvs.enabled` | `false` | Enable long-video RAG summarization |
| `phoenix.enabled` | `true` | LLM tracing and observability |
| `vst.postgres.password` | `""` | VST database password — leave empty to auto-generate |

## Feature Tiers

| Feature | Enabled by default | Requires |
|---------|--------------------|----------|
| Chat Q&A + Video Management | Always on | NGC API key, GPU |
| Semantic Search | `rtviEmbed.enabled=true` | Kafka, GPU, ~10GB HF model |
| Real-time Alerts | `rtviVlm.enabled=true` | Kafka |
| Long Video Summarization | `lvs.enabled=true` | Elasticsearch (auto-enabled) |

## Ports

| Service | NodePort | Description |
|---------|----------|-------------|
| VSS UI | 30890 | Web interface |
| VSS Agent | 30889 | REST API |
| VST Ingress | 30892 | Video upload and management |
| LVS UI | 30893 | Long-video summarization UI (when `lvs.enabled=true`) |

## Troubleshooting

**NIM pods stuck in `Init` or `Pending`** — check NGC key is valid and node has GPU resources: `kubectl describe pod <nim-pod>`

**UI shows blank or loading forever** — NIM model weights are still downloading. Check progress: `kubectl logs <cosmos-pod> --follow`

**`externalIp` not set** — the VSS UI and Agent API links in the platform dashboard will not resolve. Set `externalIp` to the public IP of your GPU node.

**Video upload fails** — verify VST pods are all `Running`: `kubectl get pods -l app.kubernetes.io/name=vss`

## License

NVIDIA VSS is subject to the [NVIDIA Software License Agreement](https://www.nvidia.com/en-us/agreements/enterprise-software/nvidia-software-license-agreement/). The Helm chart wrapper is Apache 2.0.

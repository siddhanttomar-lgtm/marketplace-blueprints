# NVIDIA Video Search and Summarization (VSS)

E2E's Kubernetes deployment of the [NVIDIA VSS Blueprint](https://developer.nvidia.com/blog/nvidia-vss-blueprint) — GPU-accelerated video understanding at scale. Upload video recordings, chat with their content, run semantic search across footage, and trigger real-time AI alerts from live streams, all backed by NVIDIA NIM microservices.

## What You Get After Deployment

The E2E Marketplace provisions the full VSS stack on a GPU node and shows the service URLs in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| VSS UI | 8888 | Chat, video management, search, and alerts interface |
| VSS Agent API | 30889 | Video upload and agent REST API (NodePort) |
| VST Video Management | 30800 | NVIDIA VST video streaming and management (NodePort) |

> **First start:** NIM pods pull model weights from NGC (~40 GB total) on first deployment. Full readiness takes **15–30 minutes**. Plan storage accordingly.

## Feature Tiers

| Tier | Key | What it enables |
|------|-----|-----------------|
| BASE | always on | Chat Q&A with video content, video upload and management |
| SEARCH | `rtviEmbed.enabled=true` | Semantic search ("find clips with red cars") |
| ALERTS | `rtviVlm.enabled=true` | Real-time AI alert generation from live streams |
| LONG VIDEO | `lvs.enabled=true` | RAG-based analysis of hours-long recordings |

SEARCH and ALERTS both require `kafka.enabled=true`.

## Requirements

- **GPU:** H100-class GPU node (or L40S / RTXPRO6000BW)
- **NGC API Key:** Required to pull all `nvcr.io` images and download NIM model weights
- **Storage:** ~120 Gi minimum for NIM model caches (Cosmos ~80Gi, Nemotron ~40Gi)

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `ngcApiKey` | Yes | NGC API key (`nvapi-...`) from [ngc.nvidia.com](https://ngc.nvidia.com). |
| `externalIp` | Yes (ownGpu) | Public IP of the GPU node. Required when `ownGpu=true`. |
| `hfToken` | No | HuggingFace token — improves download rate limits for SEARCH tier. |
| `ownGpu` | No | `true` = your own GPU VM (set `externalIp`); `false` = E2E managed node. Default: `false`. |
| `nim.hardwareProfile` | No | GPU profile: `H100`, `L40S`, `RTXPRO6000BW`, `DGX-SPARK`, `AGX-THOR`. Leave empty for auto-detect. |
| `nim.cosmos.cacheSize` | No | PVC size for Cosmos VLM model cache. Default: `80Gi`. |
| `nim.nemotron.cacheSize` | No | PVC size for Nemotron LLM model cache. Default: `40Gi`. |
| `rtviEmbed.enabled` | No | Enable semantic search tier. Requires `kafka.enabled=true`. Default: `false`. |
| `rtviVlm.enabled` | No | Enable real-time alerts tier. Requires `kafka.enabled=true`. Default: `false`. |
| `lvs.enabled` | No | Enable long video RAG tier. Default: `false`. |
| `kafka.enabled` | No | Enable Kafka pipeline (required for SEARCH and ALERTS). Default: `false`. |
| `kibana.enabled` | No | Enable Kibana dashboards for Elasticsearch analytics. Default: `false`. |
| `phoenix.enabled` | No | Enable Phoenix LLM observability. Default: `true`. |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 8888 | HTTP | VSS UI (chat + video management + optional search/alerts tabs) |
| 30889 | HTTP | VSS Agent REST API and video upload endpoint |
| 30800 | HTTP | VST video management (`/vst` path) |
| 30801 | HTTP | LVS long-video UI (when `lvs.enabled=true`) |

## Enabling a Feature After Deployment

```bash
# Enable semantic search (requires Kafka)
helm upgrade <release> <chart> --set rtviEmbed.enabled=true --set kafka.enabled=true

# Enable real-time alerts (requires Kafka)
helm upgrade <release> <chart> --set rtviVlm.enabled=true --set kafka.enabled=true

# Enable long video RAG
helm upgrade <release> <chart> --set lvs.enabled=true
```

## Troubleshooting

**Check pod status:**
```
kubectl get pods -n <namespace>
```

**NIM pods stuck in `Pending`** — GPU node not schedulable or model download in progress. NIM pods need a GPU node and ~40GB download time on first start.

**Increase NIM cache sizes** if you see cache warnings:
```bash
helm upgrade <release> <chart> \
  --set nim.cosmos.cacheSize=80Gi \
  --set nim.nemotron.cacheSize=40Gi
```

**Phoenix observability** (port-forward required):
```
kubectl port-forward svc/<release>-phoenix 6006:6006 -n <namespace>
```

**Kibana analytics** (port-forward required):
```
kubectl port-forward svc/<release>-kibana 5601:5601 -n <namespace>
```

## License

Apache 2.0. NVIDIA VSS Blueprint is subject to the [NVIDIA Software License Agreement](https://www.nvidia.com/en-us/agreements/enterprise-software/nvidia-software-license-agreement/).

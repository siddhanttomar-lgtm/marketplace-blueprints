# RAG Knowledge Base

E2E's Kubernetes deployment of a complete Retrieval-Augmented Generation (RAG) stack: [n8n](https://n8n.io) for workflow automation, [Qdrant](https://qdrant.tech) for vector search, [Ollama](https://ollama.com) for local LLM inference, and [Open WebUI](https://github.com/open-webui/open-webui) as the chat interface.

## Architecture

```
  Browser → Open WebUI → Ollama (LLM inference)
       ↑                      ↑
  n8n workflows → Qdrant (vector store, embeddings via Ollama)
```

## Prerequisites

- Kubernetes cluster (4 vCPU, 8 GB RAM minimum)
- StorageClass supporting `ReadWriteOnce` PVCs
- Internet access from pods (for model downloads)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install rag-kb blueprints/rag-kb \
  --set openwebui.adminEmail=admin@example.com \
  --set openwebui.adminPassword=YOUR-PASSWORD \
  --set n8n.encryptionKey=$(openssl rand -base64 32)
```

Using a values file:

```bash
cp blueprints/rag-kb/values.example.yaml my-values.yaml
helm install rag-kb blueprints/rag-kb -f my-values.yaml
```

## Accessing

```bash
# Open WebUI chat interface
kubectl port-forward svc/rag-kb-openwebui 3000:8080
# Open http://localhost:3000

# n8n workflow editor
kubectl port-forward svc/rag-kb-n8n 5678:5678
# Open http://localhost:5678

# Qdrant dashboard
kubectl port-forward svc/rag-kb-qdrant 6333:6333
# Open http://localhost:6333/dashboard
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `ollama.models.embedding` | `nomic-embed-text` | Embedding model for Qdrant ingestion |
| `ollama.models.generation` | `llama3.2:3b` | Chat/generation model |
| `ollama.storage.size` | `15Gi` | PVC for Ollama model weights |
| `qdrant.storage.size` | `10Gi` | PVC for vector database |
| `openwebui.adminEmail` | `""` | Open WebUI admin email. Required. |
| `openwebui.adminPassword` | `""` | Open WebUI admin password. Required. |
| `n8n.encryptionKey` | `""` | n8n credential encryption key. Required. |
| `n8n.storage.size` | `2Gi` | PVC for n8n data |
| `openwebui.storage.size` | `5Gi` | PVC for Open WebUI data |

## Persistence

Four PVCs are created: Ollama models (15Gi), Qdrant vectors (10Gi), n8n data (2Gi), Open WebUI data (5Gi).

## Troubleshooting

**Models not loading** — Ollama downloads models on first use; initial startup can take several minutes

**Embeddings slow** — ensure `ollama.models.embedding` model is pulled; check `kubectl logs deploy/rag-kb-ollama`

**n8n workflows reset** — verify the n8n PVC is bound: `kubectl get pvc`

## License

Apache 2.0. Component licenses: n8n (Sustainable Use License), Qdrant (Apache 2.0), Ollama (MIT), Open WebUI (MIT).

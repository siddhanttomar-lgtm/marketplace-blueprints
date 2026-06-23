# NVIDIA cuFOLIO

E2E's Kubernetes deployment of [NVIDIA cuFOLIO](https://github.com/NVIDIA/cuOpt-Resources) — GPU-accelerated quantitative portfolio optimization. Combines NVIDIA cuOpt, cuDF, and cuML with a Streamlit UI and Jupyter Lab environment for high-performance financial analytics.

## What You Get After Deployment

The E2E Marketplace provisions the cuFOLIO workload on an H100-class GPU node and shows the service URLs in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| Streamlit UI | 30901 | Interactive portfolio optimization interface |
| Jupyter Lab | 30902 | Notebook environment for custom analysis |

> **First start:** An init container clones cuFOLIO and runs `uv sync --extra cuda13` — this takes **5–10 minutes** on first deployment. Subsequent restarts use the cached venv and start in under 60 seconds.

## Requirements

- **GPU:** 1× H100-class GPU (compute capability ≥ 9.0), 80 GB VRAM
- **CPU/RAM:** 8 vCPU, 32 GB RAM minimum
- **NGC API Key:** Required to pull the base image from `nvcr.io`

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `ngcApiKey` | Yes | NGC API key (`nvapi-...`) from [ngc.nvidia.com](https://ngc.nvidia.com). Required to pull the GPU base image. |
| `auth.username` | No | Optional username to protect Jupyter Lab access. |
| `auth.password` | No | Optional password for Jupyter Lab. |
| `storage.dataSize` | No | PVC size for workspace data (notebooks, results). Default: `100Gi`. |
| `storage.cacheSize` | No | PVC size for the Python package cache (cuOpt, cuDF, cuML). Default: `50Gi`. |
| `ownGpu` | No | Set to `true` if using your own GPU VM instead of an E2E managed node. |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 30901 | HTTP | Streamlit portfolio optimization UI |
| 30902 | HTTP | Jupyter Lab notebook environment |

## Troubleshooting

**Follow init container progress (clone + package install):**
```
kubectl logs -n <namespace> -l app.kubernetes.io/instance=<release> -c setup -f
```

**Follow main container logs:**
```
kubectl logs -n <namespace> -l app.kubernetes.io/instance=<release> -c cufolio -f
```

**Pod stuck in `Pending`** — the workload requires an H100-class GPU node. Verify GPU availability: `kubectl get nodes -l nvidia.com/gpu=true`.

**`uv sync` fails** — check the NGC API key is valid and the node can reach `nvcr.io`.

## License

Apache 2.0. cuFOLIO is provided by NVIDIA under the [Apache 2.0 License](https://github.com/NVIDIA/cuOpt-Resources/blob/main/LICENSE).

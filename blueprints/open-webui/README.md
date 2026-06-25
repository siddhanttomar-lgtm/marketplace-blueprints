# AI Chat Workspace

E2E's Kubernetes deployment of [Open WebUI](https://github.com/open-webui/open-webui) bundled with [LiteLLM](https://github.com/BerriAI/litellm) and [Whisper](https://github.com/SYSTRAN/faster-whisper) — a private, self-hosted AI chat workspace. Connect your own API keys or use E2E TIR GenAI free models with no external account required.

## What You Get After Deployment

The E2E Marketplace provisions Open WebUI with LiteLLM as a unified API router and Whisper for speech-to-text, and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| Open WebUI | 8080 | Chat interface |
| LiteLLM | 4000 | Internal API router (internal) |
| Whisper STT | 8000 | Speech-to-text (internal) |

Open the URL from the marketplace and sign up with the admin email and password you configured.

## AI Provider Options

Connect at least one AI provider. You can choose either or both:

**Option A — Bring your own API keys:**
Set one or more of these in the deployment form:
- OpenAI API Key
- Anthropic API Key
- Groq API Key
- Google API Key (Gemini)
- Fireworks API Key
- Mistral API Key
- Perplexity API Key

**Option B — E2E TIR GenAI (free models, no external key needed):**
Set `e2e.bearerToken` in the deployment form.
Get your token at: E2E Console → TIR → API Tokens.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `webui.adminEmail` | Yes | Admin account email address. |
| `webui.adminPassword` | Yes | Admin account password. Change from the default. |
| `openaiApiKey` | No | OpenAI API key (sk-...). |
| `anthropicApiKey` | No | Anthropic API key. |
| `groqApiKey` | No | Groq API key. |
| `googleApiKey` | No | Google Gemini API key. |
| `fireworksApiKey` | No | Fireworks AI API key. |
| `mistralApiKey` | No | Mistral API key. |
| `perplexityApiKey` | No | Perplexity API key. |
| `e2e.bearerToken` | No | E2E TIR bearer token for free hosted models. |
| `webui.storage.size` | No | PVC size for chat history and settings. Default: `2Gi`. |
| `whisper.model` | No | Whisper model size for speech-to-text. Default: `tiny`. |

## Ports

| Port | Description |
|------|-------------|
| 8080 | Open WebUI chat interface |
| 4000 | LiteLLM API router (internal) |
| 8000 | Whisper STT API (internal) |

## Troubleshooting

**No models available after login** — add at least one API key or E2E TIR bearer token in Open WebUI → Settings → Connections.

**Admin login not working** — verify `webui.adminEmail` and `webui.adminPassword` match what was set during deployment.

**Speech-to-text not working** — Whisper uses the `tiny` model by default. For better accuracy, set `whisper.model` to `base` or `small` and ensure sufficient memory is available.

**Pod not starting** — check `webui.adminEmail` is set; Open WebUI requires it on first boot.

## License

Apache 2.0. Open WebUI is licensed under the [MIT License](https://github.com/open-webui/open-webui/blob/main/LICENSE). LiteLLM is licensed under the [MIT License](https://github.com/BerriAI/litellm/blob/main/LICENSE).

{{/*
Expand the name of the chart.
*/}}
{{- define "vss.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified app name — just the helm release name.
The platform resolves workload_name_tpl {{release}} to helm_release (not release+chartname),
so all K8s objects must be prefixed with just .Release.Name.
*/}}
{{- define "vss.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "vss.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
VLM base URL — NIM cosmos always deployed as a pod in the same cluster
*/}}
{{- define "vss.vlmBaseUrl" -}}
http://{{ include "vss.fullname" . }}-nim-cosmos:{{ .Values.nim.cosmos.port }}
{{- end }}

{{/*
LLM base URL — NIM nemotron always deployed as a pod in the same cluster
*/}}
{{- define "vss.llmBaseUrl" -}}
http://{{ include "vss.fullname" . }}-nim-nemotron:{{ .Values.nim.nemotron.port }}
{{- end }}

{{/*
Kafka bootstrap URL
*/}}
{{- define "vss.kafkaBootstrap" -}}
{{ include "vss.fullname" . }}-kafka:{{ .Values.kafka.port }}
{{- end }}

{{/*
Redis host
*/}}
{{- define "vss.redisHost" -}}
{{ include "vss.fullname" . }}-redis
{{- end }}

{{/*
Elasticsearch URL
*/}}
{{- define "vss.elasticsearchUrl" -}}
http://{{ include "vss.fullname" . }}-elasticsearch:{{ .Values.elasticsearch.port }}
{{- end }}

{{/*
Phoenix endpoint
*/}}
{{- define "vss.phoenixEndpoint" -}}
{{- if .Values.phoenix.enabled -}}
http://{{ include "vss.fullname" . }}-phoenix:{{ .Values.phoenix.port }}
{{- else -}}
http://localhost:{{ .Values.phoenix.port }}
{{- end }}
{{- end }}

{{/*
VSS Agent external URL — ingress host when enabled (Phase 2); NodePort otherwise.
Phase 1: ingress routes to UI only; agent stays on NodePort.
*/}}
{{- define "vss.agentExternalUrl" -}}
{{- if and .Values.ingress.enabled .Values.ingress.baseDomain -}}
https://{{ include "vss.agentHost" . }}
{{- else -}}
http://{{ .Values.externalIp }}:{{ .Values.vssAgent.nodePort }}
{{- end -}}
{{- end }}

{{/*
VST internal URL — routes to vst-ingress (K8s service) so agent reaches the full 5-service VST stack.
*/}}
{{- define "vss.vstInternalUrl" -}}
http://{{ include "vss.fullname" . }}-vst-ingress:{{ .Values.vst.ingress.port }}/vst
{{- end }}

{{/*
VST ingress URL — used by vss-agent for internal K8s communication to VST
*/}}
{{- define "vss.vstIngressUrl" -}}
http://{{ include "vss.fullname" . }}-vst-ingress:{{ .Values.vst.ingress.port }}/vst
{{- end }}

{{/*
VST MCP URL — MCP gateway for tool integration
*/}}
{{- define "vss.vstMcpUrl" -}}
http://{{ include "vss.fullname" . }}-vst-mcp:{{ .Values.vst.mcp.port }}
{{- end }}

{{/*
LLM model name — always the NIM hub model ID
*/}}
{{- define "vss.llmModelName" -}}
{{ .Values.nim.nemotron.modelName }}
{{- end }}

{{/*
VLM model name — always the NIM hub model ID
*/}}
{{- define "vss.vlmModelName" -}}
{{ .Values.nim.cosmos.modelName }}
{{- end }}

{{/*
RTVI Embed internal URL — ClusterIP DNS used by vss-agent for embedding requests.
Returns empty string when rtviEmbed is disabled so callers can gate on non-empty.
*/}}
{{- define "vss.rtviEmbedUrl" -}}
{{- if .Values.rtviEmbed.enabled -}}
http://{{ include "vss.fullname" . }}-rtvi-embed:{{ .Values.rtviEmbed.port }}
{{- end -}}
{{- end -}}

{{/*
RTVI VLM internal URL — ClusterIP DNS used by vss-agent for real-time alert management.
Returns empty string when rtviVlm is disabled.
*/}}
{{- define "vss.rtviVlmUrl" -}}
{{- if .Values.rtviVlm.enabled -}}
http://{{ include "vss.fullname" . }}-rtvi-vlm:{{ .Values.rtviVlm.port }}
{{- end -}}
{{- end -}}

{{/*
LVS backend URL — ClusterIP DNS used by vss-agent lvs_video_understanding tool.
Returns empty string when lvs is disabled.
*/}}
{{- define "vss.lvsBackendUrl" -}}
{{- if .Values.lvs.enabled -}}
http://{{ include "vss.fullname" . }}-lvs:{{ .Values.lvs.backendPort }}
{{- end -}}
{{- end -}}

{{/*
LVS MCP URL — MCP gateway for external tool integrations.
Returns empty string when lvs is disabled.
*/}}
{{- define "vss.lvsMcpUrl" -}}
{{- if .Values.lvs.enabled -}}
http://{{ include "vss.fullname" . }}-lvs:{{ .Values.lvs.mcpPort }}
{{- end -}}
{{- end -}}

{{/*
VSS Agent MCP internal URL. Empty string when disabled.
*/}}
{{- define "vss.vssAgentMcpUrl" -}}
{{- if .Values.vssAgentMcp.enabled -}}
http://{{ include "vss.fullname" . }}-vss-agent-mcp:{{ .Values.vssAgentMcp.port }}
{{- end -}}
{{- end -}}

{{/*
Hostname helpers — derived from .Release.Name + ingress.baseDomain.
Only meaningful when ingress.enabled=true and ingress.baseDomain is set.
*/}}
{{- define "vss.uiHost" -}}
{{- printf "%s.%s" .Release.Name .Values.ingress.baseDomain -}}
{{- end -}}

{{- define "vss.agentHost" -}}
{{- printf "%s-api.%s" .Release.Name .Values.ingress.baseDomain -}}
{{- end -}}

{{- define "vss.vstHost" -}}
{{- printf "%s-vst.%s" .Release.Name .Values.ingress.baseDomain -}}
{{- end -}}

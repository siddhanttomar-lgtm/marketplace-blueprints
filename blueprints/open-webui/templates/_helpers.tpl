{{/*
Expand the name of the chart.
*/}}
{{- define "open-webui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "open-webui.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Ollama internal service host
*/}}
{{- define "open-webui.ollamaHost" -}}
{{- printf "%s-ollama" .Release.Name }}
{{- end }}

{{/*
Open WebUI service host
*/}}
{{- define "open-webui.webuiHost" -}}
{{- .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "open-webui.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "open-webui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Ollama selector labels
*/}}
{{- define "open-webui.ollamaSelectorLabels" -}}
app.kubernetes.io/name: {{ include "open-webui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: ollama
{{- end }}

{{/*
WebUI selector labels
*/}}
{{- define "open-webui.webuiSelectorLabels" -}}
app.kubernetes.io/name: {{ include "open-webui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: webui
{{- end }}

{{/*
WebUI secret key — generate once, reuse on upgrades via lookup
*/}}
{{- define "open-webui.secretKey" -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace (printf "%s-credentials" .Release.Name) }}
{{- if $secret }}
{{- index $secret.data "webui-secret-key" }}
{{- else }}
{{- randAlphaNum 32 | b64enc }}
{{- end }}
{{- end }}

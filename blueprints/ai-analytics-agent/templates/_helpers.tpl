{{- define "aaa.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "aaa.fullname" -}}
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

{{- define "aaa.labels" -}}
helm.sh/chart: {{ include "aaa.name" . }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "aaa.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "aaa.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aaa.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/* Service hostnames for inter-service communication */}}
{{- define "aaa.openclawHost" -}}
{{- printf "%s-openclaw" .Release.Name }}
{{- end }}

{{- define "aaa.umamiHost" -}}
{{- printf "%s-umami" .Release.Name }}
{{- end }}

{{- define "aaa.umamiMcpHost" -}}
{{- printf "%s-umami-mcp" .Release.Name }}
{{- end }}

{{- define "aaa.postgresqlHost" -}}
{{- printf "%s-postgresql" .Release.Name }}
{{- end }}

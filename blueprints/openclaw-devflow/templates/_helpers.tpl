{{- define "oca.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "oca.fullname" -}}
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

{{- define "oca.labels" -}}
helm.sh/chart: {{ include "oca.name" . }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "oca.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "oca.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oca.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/* Service hostname for the OpenClaw gateway */}}
{{- define "oca.openclawHost" -}}
{{- printf "%s-openclaw" .Release.Name }}
{{- end }}

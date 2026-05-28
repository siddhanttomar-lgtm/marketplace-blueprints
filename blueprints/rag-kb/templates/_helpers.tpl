{{/*
Common labels applied to all resources.
*/}}
{{- define "rag-kb.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels for a given component.
Usage: include "rag-kb.selectorLabels" (dict "release" .Release.Name "component" "qdrant")
*/}}
{{- define "rag-kb.selectorLabels" -}}
app.kubernetes.io/name: rag-kb-{{ .component }}
app.kubernetes.io/instance: {{ .release }}
{{- end }}

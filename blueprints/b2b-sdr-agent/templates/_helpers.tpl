{{- define "b2b-sdr.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "b2b-sdr.selectorLabels" -}}
app.kubernetes.io/name: b2b-sdr-{{ .component }}
app.kubernetes.io/instance: {{ .release }}
{{- end }}

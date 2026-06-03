{{- define "b2b-sdr.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "b2b-sdr.selectorLabels" -}}
app.kubernetes.io/name: b2b-sdr-{{ .component }}
app.kubernetes.io/instance: {{ .release }}
{{- end }}

{{/* Twenty internal service URL — used for API calls within the cluster */}}
{{- define "b2b-sdr.twentyInternalUrl" -}}
http://{{ .Release.Name }}-twenty:3000
{{- end }}

{{/* Postgres DSN for Twenty */}}
{{- define "b2b-sdr.postgresDsn" -}}
postgresql://{{ .Values.postgres.user }}:{{ .Values.postgres.password }}@{{ .Release.Name }}-postgres:5432/{{ .Values.postgres.database }}
{{- end }}

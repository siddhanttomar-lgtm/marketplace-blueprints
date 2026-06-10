{{- define "aipm.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "aipm.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{- define "aipm.postgresUrl" -}}
postgresql://{{ .Values.postgres.username | default "plane" }}:$(POSTGRES_PASSWORD)@{{ .Release.Name }}-postgres:5432/{{ .Values.postgres.database | default "plane" }}
{{- end }}

{{- define "aipm.redisUrl" -}}
{{- if .Values.redis.password -}}
redis://:$(REDIS_PASSWORD)@{{ .Release.Name }}-redis:6379/
{{- else -}}
redis://{{ .Release.Name }}-redis:6379/
{{- end }}
{{- end }}

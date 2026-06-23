{{/*
Expand the chart name.
*/}}
{{- define "cufolio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified app name — just the helm release name.
The platform resolves workload_name_tpl {{release}} to helm_release (not release+chartname),
so all K8s objects must be prefixed with just .Release.Name.
*/}}
{{- define "cufolio.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "cufolio.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Streamlit ingress host — {release}.{baseDomain}
*/}}
{{- define "cufolio.streamlitHost" -}}
{{- printf "%s.%s" .Release.Name .Values.ingress.baseDomain -}}
{{- end -}}

{{/*
Jupyter ingress host — {release}-jupyter.{baseDomain}
*/}}
{{- define "cufolio.jupyterHost" -}}
{{- printf "%s-jupyter.%s" .Release.Name .Values.ingress.baseDomain -}}
{{- end -}}

{{/*
Jupyter token — derive from NGC key hash if not explicitly set, so it is
deterministic across pod restarts without storing secrets in the PVC.
Falls back to a static placeholder when both are empty (dev/testing only).
*/}}
{{- define "cufolio.jupyterToken" -}}
{{- if .Values.jupyter.token -}}
{{- .Values.jupyter.token -}}
{{- else if .Values.ngcApiKey -}}
{{- .Values.ngcApiKey | sha256sum | trunc 32 -}}
{{- else -}}
{{- "changeme" -}}
{{- end -}}
{{- end -}}

{{/*
NGC image-pull dockerconfigjson — built from the customer-supplied .Values.ngcApiKey.
Authenticates pulls of nvcr.io images using the customer's NGC key (username is the
literal "$oauthtoken", as required by NGC). Returns a base64-encoded dockerconfigjson.
*/}}
{{- define "cufolio.nvcrDockerConfigJson" -}}
{{- $auth := printf "$oauthtoken:%s" .Values.ngcApiKey | b64enc -}}
{{- printf `{"auths":{"nvcr.io":{"username":"$oauthtoken","password":"%s","auth":"%s"}}}` .Values.ngcApiKey $auth | b64enc -}}
{{- end -}}

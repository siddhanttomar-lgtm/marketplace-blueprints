#!/usr/bin/env bash
# create-blueprint.sh - scaffold a new blueprint folder skeleton
#
# Usage:
#   bash scripts/create-blueprint.sh <name> "<Display Name>" "<description>" "<appVersion>"
#
# Example:
#   bash scripts/create-blueprint.sh my-tool "My Tool" "Brief description" "1.0.0"

set -euo pipefail

NAME="${1:-}"
DISPLAY_NAME="${2:-}"
DESCRIPTION="${3:-}"
APP_VERSION="${4:-}"

fail() {
  echo ""
  echo "  ERROR: $1"
  echo ""
  exit 1
}

yaml_quote() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '"%s"' "$value"
}

reject_newline() {
  local label="$1"
  local value="$2"
  case "$value" in
    *$'\n'*|*$'\r'*)
      fail "$label must be a single line"
      ;;
  esac
}

# Validate inputs
if [ -z "$NAME" ] || [ -z "$DISPLAY_NAME" ] || [ -z "$DESCRIPTION" ] || [ -z "$APP_VERSION" ]; then
  echo ""
  echo "  Usage: bash scripts/create-blueprint.sh <name> \"<Display Name>\" \"<description>\" \"<appVersion>\""
  echo ""
  echo "  Example:"
  echo "    bash scripts/create-blueprint.sh my-tool \"My Tool\" \"Brief description\" \"1.0.0\""
  echo ""
  exit 1
fi

if [[ ! "$NAME" =~ ^[a-z0-9]([-a-z0-9]*[a-z0-9])?$ ]]; then
  fail "blueprint name must use lowercase letters, numbers, and hyphens only, and must not start or end with a hyphen"
fi

reject_newline "Display name" "$DISPLAY_NAME"
reject_newline "Description" "$DESCRIPTION"
reject_newline "App version" "$APP_VERSION"

DEST="blueprints/$NAME"

if [ -d "$DEST" ]; then
  fail "blueprints/$NAME already exists. Aborting."
fi

# Create folder
mkdir -p "$DEST/templates"

# Chart.yaml
cat > "$DEST/Chart.yaml" <<EOF
apiVersion: v2
name: $NAME
description: $(yaml_quote "$DESCRIPTION")
type: application
version: 1.0.0
appVersion: $(yaml_quote "$APP_VERSION")
keywords:
  - $NAME
home: https://TODO-upstream-url
sources:
  - https://TODO-source-url
maintainers:
  - name: E2E Networks
    url: https://e2enetworks.com
EOF

# values.yaml
cat > "$DEST/values.yaml" <<EOF
replicaCount: 1

image:
  repository: TODO-image-repository
  tag: $(yaml_quote "$APP_VERSION")
  pullPolicy: IfNotPresent

auth:
  password: ""

service:
  type: NodePort
  port: 80
  nodePort: ""

persistence:
  enabled: true
  size: 8Gi
  storageClass: ""
  accessMode: ReadWriteOnce

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

nodeSelector: {}
tolerations: []
affinity: {}
EOF

# values.example.yaml
cat > "$DEST/values.example.yaml" <<EOF
# $DISPLAY_NAME - example configuration
# Copy this file, fill in required values, and pass to helm install:
#   helm install $NAME blueprints/$NAME -f my-values.yaml

auth:
  password: "YOUR-STRONG-PASSWORD"

persistence:
  size: 8Gi
  storageClass: ""

service:
  type: NodePort
EOF

# .helmignore
cat > "$DEST/.helmignore" <<EOF
# Patterns to ignore when building packages.
# This supports shell glob matching, relative path matching, and
# negation (prefixed with !). Only one pattern per line.
.DS_Store
# Common VCS dirs
.git/
.gitignore
.bzr/
.bzrignore
.hg/
.hgignore
.svn/
# Common backup files
*.swp
*.bak
*.tmp
*~
# Various IDEs
.project
.idea/
*.tmproj
# img folder
img/
# Changelog
CHANGELOG.md
EOF

# templates/deployment.yaml
cat > "$DEST/templates/deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
  labels:
    app.kubernetes.io/name: {{ .Chart.Name | quote }}
    app.kubernetes.io/instance: {{ .Release.Name | quote }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ .Chart.Name | quote }}
      app.kubernetes.io/instance: {{ .Release.Name | quote }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ .Chart.Name | quote }}
        app.kubernetes.io/instance: {{ .Release.Name | quote }}
    spec:
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      containers:
        - name: {{ .Chart.Name | quote }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.port }}
              protocol: TCP
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
EOF

# templates/service.yaml
cat > "$DEST/templates/service.yaml" <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
  labels:
    app.kubernetes.io/name: {{ .Chart.Name | quote }}
    app.kubernetes.io/instance: {{ .Release.Name | quote }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - name: http
      port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      {{- if .Values.service.nodePort }}
      nodePort: {{ .Values.service.nodePort }}
      {{- end }}
  selector:
    app.kubernetes.io/name: {{ .Chart.Name | quote }}
    app.kubernetes.io/instance: {{ .Release.Name | quote }}
EOF

# templates/NOTES.txt
cat > "$DEST/templates/NOTES.txt" <<EOF
$DISPLAY_NAME has been deployed.

Access the service via the URL shown in the E2E Marketplace dashboard.
EOF

# README.md
cat > "$DEST/README.md" <<EOF
# $DISPLAY_NAME

$DESCRIPTION

## What You Get After Deployment

The E2E Marketplace provisions $DISPLAY_NAME and shows the access URL in the dashboard.

| Service | Port | Description |
|---------|------|-------------|
| TODO    | TODO | TODO        |

Open \`http://<deployment-url>:<port>\` to access the interface.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| \`auth.password\` | Yes | Login password. |
| \`persistence.size\` | No | Storage size. Default: \`8Gi\`. |
| \`resources.requests.cpu\` | No | CPU request. Default: \`100m\`. |
| \`resources.requests.memory\` | No | Memory request. Default: \`128Mi\`. |

## Ports

| Service | Port | Description |
|---------|------|-------------|
| TODO    | TODO | TODO        |

## Troubleshooting

**Service not accessible** — wait 1–2 minutes after deployment for the pod to fully start, then refresh the access URL from the dashboard.

**Wrong password** — verify the password matches what was set in the deployment form.

## License

TODO
EOF

# Done
echo ""
echo "  Created blueprints/$NAME/ with:"
echo "    Chart.yaml                - fill in home + sources URLs"
echo "    values.yaml               - fill in image.repository"
echo "    values.example.yaml       - ready"
echo "    .helmignore               - ready"
echo "    templates/deployment.yaml - update container settings"
echo "    templates/service.yaml    - update service ports"
echo "    templates/NOTES.txt       - update connection command"
echo "    README.md                 - fill in ports + connection command"
echo ""
echo "  Next steps:"
echo "    1. Edit the TODO fields in the files above"
echo "    2. helm lint blueprints/$NAME --strict"
echo "    3. helm template test blueprints/$NAME --dry-run"
echo ""

#!/usr/bin/env bash
# new-blueprint.sh — scaffold a new blueprint folder skeleton
#
# Usage:
#   bash scripts/new-blueprint.sh <name> "<Display Name>" "<description>" "<appVersion>"
#
# Example:
#   bash scripts/new-blueprint.sh mysql "MySQL" "MySQL relational database" "8.4.0"

set -e

NAME="$1"
DISPLAY_NAME="$2"
DESCRIPTION="$3"
APP_VERSION="$4"

# ── Validate inputs ────────────────────────────────────────────────────────────
if [ -z "$NAME" ] || [ -z "$DISPLAY_NAME" ] || [ -z "$DESCRIPTION" ] || [ -z "$APP_VERSION" ]; then
  echo ""
  echo "  Usage: bash scripts/new-blueprint.sh <name> \"<Display Name>\" \"<description>\" \"<appVersion>\""
  echo ""
  echo "  Example:"
  echo "    bash scripts/new-blueprint.sh mysql \"MySQL\" \"MySQL relational database\" \"8.4.0\""
  echo ""
  exit 1
fi

DEST="blueprints/$NAME"

if [ -d "$DEST" ]; then
  echo ""
  echo "  ERROR: blueprints/$NAME already exists. Aborting."
  echo ""
  exit 1
fi

# ── Create folder ──────────────────────────────────────────────────────────────
mkdir -p "$DEST/templates"

# ── Chart.yaml ────────────────────────────────────────────────────────────────
cat > "$DEST/Chart.yaml" <<EOF
apiVersion: v2
name: $NAME
description: $DESCRIPTION
type: application
version: 1.0.0
appVersion: "$APP_VERSION"
keywords:
  - $NAME
home: https://TODO-upstream-url
sources:
  - https://TODO-source-url
maintainers:
  - name: E2E Networks
    url: https://e2enetworks.com
EOF

# ── values.yaml ───────────────────────────────────────────────────────────────
cat > "$DEST/values.yaml" <<EOF
replicaCount: 1

image:
  repository: TODO-image-repository
  tag: "$APP_VERSION"
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

# ── values.example.yaml ───────────────────────────────────────────────────────
cat > "$DEST/values.example.yaml" <<EOF
# $DISPLAY_NAME — example configuration
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

# ── .helmignore ───────────────────────────────────────────────────────────────
cat > "$DEST/.helmignore" <<EOF
README.md
values.example.yaml
EOF

# ── templates/NOTES.txt ───────────────────────────────────────────────────────
cat > "$DEST/templates/NOTES.txt" <<EOF
$DISPLAY_NAME has been deployed.

Get the NodePort:
  kubectl get svc {{ .Release.Name }}

Connect using the node IP and the NodePort shown above.
EOF

# ── README.md ─────────────────────────────────────────────────────────────────
cat > "$DEST/README.md" <<EOF
# $DISPLAY_NAME

$DESCRIPTION

## Quick Start

\`\`\`bash
cp blueprints/$NAME/values.example.yaml my-values.yaml
# Edit my-values.yaml and set your password

helm install my-$NAME blueprints/$NAME -f my-values.yaml
kubectl get pods
\`\`\`

Wait until the pod shows \`Running\` and \`READY 1/1\`.

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| \`auth.password\` | Login password | \`""\` (required) |
| \`persistence.size\` | Storage size | \`8Gi\` |
| \`service.type\` | Service type | \`NodePort\` |
| \`resources.requests.cpu\` | CPU request | \`100m\` |
| \`resources.requests.memory\` | Memory request | \`128Mi\` |

## Ports

| Service | Port |
|---------|------|
| TODO | TODO |

## Connecting

\`\`\`bash
# TODO — add connection command
kubectl get svc my-$NAME
\`\`\`

## Troubleshooting

**Pod not starting:**
\`\`\`bash
kubectl describe pod -l app.kubernetes.io/name=$NAME
kubectl logs -l app.kubernetes.io/name=$NAME
\`\`\`
EOF

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "  Created blueprints/$NAME/ with:"
echo "    Chart.yaml          ← fill in home + sources URLs"
echo "    values.yaml         ← fill in image.repository"
echo "    values.example.yaml ← ready"
echo "    .helmignore         ← ready"
echo "    templates/NOTES.txt ← update connection command"
echo "    README.md           ← fill in ports + connection command"
echo ""
echo "  Next steps:"
echo "    1. Edit the TODO fields in the files above"
echo "    2. helm lint blueprints/$NAME --strict"
echo "    3. helm template test blueprints/$NAME --dry-run"
echo ""

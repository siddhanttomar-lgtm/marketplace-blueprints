#!/usr/bin/env bash
# Regression tests for blueprint scaffolding and validation helpers.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_ROOT"' EXIT

fail() {
  echo "ERROR: $1"
  exit 1
}

assert_file() {
  [ -f "$1" ] || fail "expected file $1"
}

assert_contains() {
  local needle="$1"
  local file="$2"
  grep -q "$needle" "$file" || fail "expected $file to contain $needle"
}

run_create() {
  bash "$ROOT/scripts/create-blueprint.sh" "$@"
}

test_create_rejects_path_traversal() {
  local work="$TMPDIR_ROOT/path-traversal"
  mkdir -p "$work/blueprints"

  (
    cd "$work"
    if run_create "../escaped" "Escaped" "test chart" "1.0.0" >out.txt 2>err.txt; then
      fail "path traversal name was accepted"
    fi
    [ ! -e "$work/escaped" ] || fail "script wrote outside blueprints"
    assert_contains "blueprint name must use lowercase" out.txt
  )
}

test_create_quotes_description_and_renders_resources() {
  local work="$TMPDIR_ROOT/render"
  mkdir -p "$work/blueprints"

  (
    cd "$work"
    run_create "cache" "Cache" "Cache: in-memory data store" "1.0.0" >out.txt
    assert_file "blueprints/cache/templates/deployment.yaml"
    assert_file "blueprints/cache/templates/service.yaml"
    assert_contains 'description: "Cache: in-memory data store"' "blueprints/cache/Chart.yaml"

    helm lint blueprints/cache --strict >lint.txt
    helm template test blueprints/cache >rendered.yaml
    assert_contains "^kind: Deployment" rendered.yaml
    assert_contains "^kind: Service" rendered.yaml
  )
}

test_validate_rejects_empty_render() {
  local work="$TMPDIR_ROOT/empty-render"
  mkdir -p "$work/scripts" "$work/blueprints/empty/templates"
  cp "$ROOT/scripts/validate.sh" "$work/scripts/validate.sh"

  cat > "$work/blueprints/empty/Chart.yaml" <<'EOF'
apiVersion: v2
name: empty
description: "Empty chart"
type: application
version: 1.0.0
appVersion: "1.0.0"
EOF

  (
    cd "$work"
    if bash scripts/validate.sh >out.txt 2>err.txt; then
      fail "empty render passed validation"
    fi
    assert_contains "rendered no Kubernetes resources" out.txt
  )
}

test_create_rejects_path_traversal
test_create_quotes_description_and_renders_resources
test_validate_rejects_empty_render

echo "All blueprint tool tests passed."

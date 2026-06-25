#!/usr/bin/env bash
# validate.sh - helm lint + template dry-run for all charts under blueprints/
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
found=0
rendered_output="$(mktemp)"
trap 'rm -f "$rendered_output"' EXIT

for chart in "$REPO_ROOT"/blueprints/*/; do
  [ -f "${chart}Chart.yaml" ] || continue
  name=$(basename "$chart")
  echo "=== Validating blueprints/$name ==="

  helm lint "$chart" --strict

  ci_args=()
  [ -f "${chart}ci/ci-values.yaml" ] && ci_args=(-f "${chart}ci/ci-values.yaml")
  helm template test "$chart" "${ci_args[@]}" > "$rendered_output"
  if ! grep -q '^kind:' "$rendered_output"; then
    echo "ERROR: blueprints/$name rendered no Kubernetes resources"
    exit 1
  fi

  echo "  OK"
  found=1
done

if [ "$found" -eq 0 ]; then
  echo "No charts found under blueprints/ — nothing to validate"
  exit 0
fi

echo ""
echo "All charts valid."

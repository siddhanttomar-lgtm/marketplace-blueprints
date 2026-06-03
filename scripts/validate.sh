#!/usr/bin/env bash
# validate.sh — helm lint + template dry-run for all charts under blueprints/
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
found=0

for chart in "$REPO_ROOT"/blueprints/*/; do
  [ -f "${chart}Chart.yaml" ] || continue
  name=$(basename "$chart")
  echo "=== Validating blueprints/$name ==="

  helm lint "$chart" --strict

  helm template test "$chart" > /dev/null

  echo "  OK"
  found=1
done

if [ "$found" -eq 0 ]; then
  echo "No charts found under blueprints/ — nothing to validate"
  exit 0
fi

echo ""
echo "All charts valid."

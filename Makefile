.PHONY: lint validate test

# Lint all charts under blueprints/
lint:
	@rc=0; found=0; \
	for chart in blueprints/*/; do \
	  [ -f "$${chart}Chart.yaml" ] || continue; \
	  echo "Linting $$chart..."; \
	  helm lint "$$chart" --strict || rc=1; \
	  found=1; \
	done; \
	[ "$$found" -eq 1 ] || echo "No charts found"; \
	exit $$rc

# Lint + template dry-run
validate:
	@bash scripts/validate.sh

test:
	@bash scripts/test-blueprint-tools.sh

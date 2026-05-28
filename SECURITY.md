# Security Policy

## Reporting a Vulnerability

If you discover a security issue in this repository — such as an accidentally committed secret, an unsafe default configuration, or a chart that exposes sensitive data — please report it by opening a GitHub issue labelled **[SECURITY]**.

Do not include sensitive details (keys, tokens, passwords) in the public issue. If the report requires sharing sensitive information, contact the maintainers directly via the E2E Networks support portal before filing the issue.

We aim to acknowledge reports within 3 business days and resolve confirmed issues within 30 days.

## Scope

- Helm chart templates that expose secrets or grant excessive Kubernetes permissions by default
- Default values that create an insecure deployment out of the box
- Credentials or API keys accidentally committed to this repository

## Out of Scope

- Vulnerabilities in upstream software deployed by the charts (report those to the upstream project)
- Issues that require an attacker to already have cluster-admin access

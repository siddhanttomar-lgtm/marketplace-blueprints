# Jenkins + Maven

E2E's Kubernetes deployment of [Jenkins](https://www.jenkins.io) with [Apache Maven](https://maven.apache.org) pre-installed. Jenkins is a leading open-source automation server for CI/CD pipelines; Maven handles Java project builds. Maven is injected at startup — no manual plugin or tool configuration required.

## Architecture

```
  Browser → Service (NodePort :8080) → Jenkins Pod → PVC (10Gi)
                                            │
                                     Init Container
                                   (maven:3.9-alpine)
                                   copies Maven binary
```

## Requirements

- Kubernetes cluster (2 vCPU, 2GB RAM minimum — JVM is memory-heavy)
- StorageClass supporting `ReadWriteOnce` PVCs
- Allow ~5 minutes for full UI readiness after the pod reports Running (JVM + plugin init)

## Quick Start

```bash
git clone https://github.com/e2enetworks-oss/marketplace-blueprints.git
cd marketplace-blueprints

helm install jenkins-maven blueprints/jenkins-maven \
  --set jenkins.jenkinsPassword=YOUR-PASSWORD
```

Using a values file:

```bash
cp blueprints/jenkins-maven/values.example.yaml my-values.yaml
helm install jenkins-maven blueprints/jenkins-maven -f my-values.yaml
```

## Connecting

```bash
NODE_PORT=$(kubectl get svc jenkins-maven-jenkins -o jsonpath='{.spec.ports[0].nodePort}')
# Open http://<node-ip>:<NODE_PORT> in your browser
# Login: admin / <your password>
```

## Key Configuration

| Value | Default | Description |
|-------|---------|-------------|
| `jenkins.jenkinsPassword` | `""` | Admin password. Required. |
| `jenkins.jenkinsUser` | `admin` | Admin username |
| `jenkins.persistence.size` | `10Gi` | PVC size for Jenkins home |
| `jenkins.resources.requests.memory` | `1Gi` | Memory request |
| `jenkins.resources.requests.cpu` | `200m` | CPU request |
| `jenkins.resources.limits.memory` | `2Gi` | Memory limit |
| `jenkins.resources.limits.cpu` | `2` | CPU limit |

## Maven

Maven 3.9 (LTS) is pre-installed at `/opt/maven`. The `MAVEN_HOME` and `PATH+MAVEN` environment variables are registered globally in Jenkins via an init Groovy script at startup.

To use Maven in a pipeline:

```groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'mvn --version'
        sh 'mvn clean package'
      }
    }
  }
}
```

## Ports

| Port | Default Service Type | Notes |
|------|---------------------|-------|
| 8080 | NodePort | Jenkins web UI and API |

## Troubleshooting

**UI not loading after 5 minutes** — check startup logs: `kubectl logs -l app.kubernetes.io/name=jenkins -c jenkins`

**Password incorrect** — retrieve from secret: `kubectl get secret jenkins-maven-jenkins -o jsonpath='{.data.jenkins-password}' | base64 -d`

**Maven not found in pipeline** — verify the init Groovy ran: check Jenkins → Manage Jenkins → System → Global properties → Environment variables for `MAVEN_HOME`

**Pod pending** — check PVC: `kubectl get pvc`

## Upgrading

```bash
helm upgrade jenkins-maven blueprints/jenkins-maven -f my-values.yaml
```

## License

Apache 2.0. Jenkins is licensed under the [MIT License](https://www.jenkins.io/project/conduct/). Apache Maven is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

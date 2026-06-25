# Jenkins + Maven

E2E's Kubernetes deployment of [Jenkins](https://www.jenkins.io) with [Apache Maven](https://maven.apache.org) pre-installed. Maven 3.9 is injected at startup — no manual plugin or tool configuration required.

## What You Get After Deployment

The E2E Marketplace provisions Jenkins and shows the access URL in the dashboard. Allow up to 5 minutes for the UI to become available after deployment (JVM and plugin initialisation).

| Service | Port | Description |
|---------|------|-------------|
| Jenkins UI | 8080 | Web interface |

Open `http://<deployment-url>:8080` and log in with username `admin` and the password you set.

## Configuration

Fill in these values in the E2E Marketplace deployment form:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `jenkins.jenkinsPassword` | Yes | Admin password. |
| `jenkins.jenkinsUser` | No | Admin username. Default: `admin`. |
| `jenkins.persistence.size` | No | PVC size for Jenkins home. Default: `10Gi`. |
| `jenkins.resources.requests.memory` | No | Memory request. Default: `1Gi`. JVM requires at least 1Gi. |
| `jenkins.resources.limits.memory` | No | Memory limit. Default: `2Gi`. |

## Maven

Maven 3.9 (LTS) is pre-installed at `/opt/maven`. The `MAVEN_HOME` and `PATH+MAVEN` environment variables are registered globally in Jenkins at startup.

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

| Port | Description |
|------|-------------|
| 8080 | Jenkins web UI and API |

## Troubleshooting

**UI not loading after 5 minutes** — Jenkins initialises plugins on first boot which is slow. Wait an additional 2–3 minutes and refresh. If it still doesn't load, contact E2E support.

**Maven not found in pipeline** — verify the init Groovy ran: Jenkins → Manage Jenkins → System → Global properties → Environment variables. Look for `MAVEN_HOME`.

**Pod pending** — storage provisioning issue. Contact E2E support if the pod does not start within 5 minutes.

## License

Apache 2.0. Jenkins is licensed under the [MIT License](https://www.jenkins.io/project/conduct/). Apache Maven is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

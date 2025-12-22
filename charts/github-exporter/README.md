# github-exporter

A Helm Chart for the GitHub Prometheus Exporter

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/github-exporter
```

## Introduction

This chart bootstraps the [GitHub Exporter](https://github.com/githubexporter/github-exporter) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/github-exporter
```

These commands deploy the GitHub Exporter on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"github-exporter.fullname"` |
| github.auth.app.enabled | bool | `false` | Enable authentication using a GitHub App. |
| github.auth.app.id | string | `""` | The APP ID of the GitHub App. |
| github.auth.app.installationId | string | `""` | The INSTALLATION ID of the GitHub App. |
| github.auth.app.privateKey | string | `""` | The private Key. |
| github.auth.existingSecret | string | `""` | Name of existing secret to use for authentication credentials. Keys in secret should be called `github-app-id`, `github-app-installation-id`, `github-app-private-key` or `github-token` depenending on the choosen authentication type (`github.auth.type``). |
| github.auth.token.enabled | bool | `false` | Enable authentication with an API Token |
| github.auth.token.value | string | `""` | The Token used to authenticate against the GitHub API |
| github.config.apiUrl | string | `"https://api.github.com"` | Github API URL, shouldn't need to change this. |
| github.config.logLevel | string | `"error"` | The level of logging the exporter will run with. |
| github.config.rateLimit | int | `0` | The rate limit that suppose to be for github app (default is 15,000). If the exporter sees the value is below this variable it generating new token for the app. |
| github.targets.organizations | string | `""` | If supplied, the exporter will enumerate all repositories for that organization. Expected in the format "org1, org2". |
| github.targets.repositories | string | `""` | If supplied, The repos you wish to monitor, expected in the format "user/repo1, user/repo2". Can be across different Github users/orgs. |
| github.targets.users | string | `""` | If supplied, the exporter will enumerate all repositories for that users. Expected in the format "user1, user2". |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"githubexporter/github-exporter"` | image repository |
| image.tag | string | `"v2.1.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| nameOverride | string | `""` | Provide a name in place of `github-exporter` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podSecurityContext | object | `{}` | pod-level security context |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{"requests":{"cpu":"100m","memory":"100Mi"}}` | Resource limits and requests for the controller pods. |
| revisionHistoryLimit | int | `0` | The number of old ReplicaSets to retain |
| securityContext | object | `{}` | container-level security context |
| service.port | int | `9171` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.additionalLabels | object | `{}` | Prometheus ServiceMonitor labels |
| serviceMonitor.enabled | bool | `false` | Enable a Prometheus ServiceMonitor |
| serviceMonitor.interval | string | `"30s"` | Prometheus ServiceMonitor interval |
| serviceMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.namespace | string | `""` | Prometheus ServiceMonitor namespace |
| serviceMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.selector | object | `{}` | Prometheus ServiceMonitor selector |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/github-exporter
```

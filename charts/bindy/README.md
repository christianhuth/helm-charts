# bindy

Bindy is a Kubernetes operator that manages BIND9 DNS infrastructure declaratively

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/bindy
```

## Introduction

This chart bootstraps [Bindy](https://github.com/firestoned/bindy) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/bindy
```

These commands deploy Bindy on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| config.leaderElection.enabled | bool | `true` | Enable leader election for controller manager |
| config.leaderElection.leaseDurationSeconds | int | `15` | Lease duration in seconds |
| config.leaderElection.leaseName | string | `"bindy-leader"` | Lease name for leader election |
| config.leaderElection.renewDeadlineSeconds | int | `10` | Renew deadline in seconds |
| config.leaderElection.retryPeriodSeconds | int | `2` | Retry period in seconds |
| config.log.format | string | `"json"` | Log format: text or json |
| config.log.level | string | `"info"` | Log level for the controller: error, warn, info, debug, trace |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| extraEnvFrom | list | `[]` | additional environment variables from ConfigMaps or Secrets |
| fullnameOverride | string | `""` | String to fully override `"bindy.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"ghcr.io"` | image registry |
| image.repository | string | `"firestoned/bindy"` | image repository |
| image.tag | string | `"v0.3.1"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| nameOverride | string | `""` | Provide a name in place of `bindy` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | see [values.yaml](./values.yaml) | pod-level security context |
| rbac.adminRole.bindToBindy | bool | `false` | Create a rolebinding to allow Bindy to delete resources |
| rbac.adminRole.create | bool | `false` | Create admin role that enables the deletion of resources |
| rbac.create | bool | `true` | Create RBAC resources |
| replicaCount | int | `1` | Number of replicas |
| resources | object | see [values.yaml](./values.yaml) | Resource limits and requests for the pods. |
| revisionHistoryLimit | int | `0` | The number of old ReplicaSets to retain |
| securityContext | object | see [values.yaml](./values.yaml) | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
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
helm install my-release -f values.yaml christianhuth/bindy
```

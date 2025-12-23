# prometheus-pve-exporter

A Helm chart for bootstrapping a PVE Exporter. Uses ServiceMonitor to collect metrics.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/prometheus-pve-exporter
```

## Introduction

A Prometheus exporter for [Proxmox Virtual Environment](https://proxmox.com/en/proxmox-ve) metrics.

This chart bootstraps a [PVE Exporter](https://github.com/prometheus-pve/prometheus-pve-exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/prometheus-pve-exporter
```

These commands deploy prometheus-pve-exporter on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| args | list | `[]` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env.pveAuthType | string | `"token"` |  |
| env.pveExistingSecretName | string | `""` |  |
| env.pvePassword | string | `"password"` |  |
| env.pveTokenName | string | `"tokenName"` |  |
| env.pveTokenValue | string | `"tokenValue"` |  |
| env.pveUser | string | `"user"` |  |
| env.pveVerifySsl | bool | `false` |  |
| fullnameOverride | string | `""` | String to fully override `"prometheus-pve-exporter.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"prompve/prometheus-pve-exporter"` | image repository |
| image.tag | string | `"3.8.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| nameOverride | string | `""` | Provide a name in place of `prometheus-pve-exporter` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the controller pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534}` | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.additionalLabels | object | `{}` | Prometheus ServiceMonitor labels |
| serviceMonitor.enabled | bool | `false` | Enable a prometheus ServiceMonitor |
| serviceMonitor.interval | string | `"30s"` | Prometheus ServiceMonitor interval |
| serviceMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.namespace | string | `""` | Prometheus ServiceMonitor namespace |
| serviceMonitor.pveTargets | list | `[]` | Prometheus |
| serviceMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.selector | object | `{}` | Prometheus ServiceMonitor selector |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/prometheus-pve-exporter
```

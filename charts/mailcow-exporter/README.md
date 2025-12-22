# mailcow-exporter

Prometheus exporter for information about a mailcow instance

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/mailcow-exporter
```

## Introduction

This chart bootstraps a [Prometheus Exporter for Mailcow](https://github.com/mailcow/prometheus-exporter) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+
- Prometheus

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/mailcow-exporter
```

These commands deploy the Mailcow Exporter on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| config.exporter.auth.enabled | bool | `true` | Enable authentication against the metrics provided by the exporter |
| config.exporter.auth.existingSecret | string | `""` | Name of existing secret to use for Exporter authentication. Key in secret needs to be `mailcow-security-token`. |
| config.exporter.auth.securityToken | string | `""` | Token that must be provided through the ?token=... URL parameter in order to fetch metrics. If none is provided, accessing the endpoints is only allowed by providing the same API-Key as used for the exporter |
| config.exporter.port | int | `9099` | The hostname and port the exporter will listen on |
| config.mailcow.auth.apiKey | string | `""` | API Key to use when accessing the mailcow API. Ignored if config.mailcow.auth.existingSecret is provided. |
| config.mailcow.auth.existingSecret | string | `""` | Name of existing secret to use for Mailcow authentication. Key in secret needs to be `mailcow-api-key`. |
| config.mailcow.host | string | `""` | Hostname under which the mailcow instance is hosted |
| config.mailcow.scheme | string | `"https"` | The scheme to use when accessing the API (must be "http" or "https") |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"mailcow-exporter.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"ghcr.io"` | image registry |
| image.repository | string | `"mailcow/prometheus-exporter"` | image repository |
| image.tag | string | `"2.1.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `mailcow-exporter` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podSecurityContext | object | `{}` | pod-level security context |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the headwind pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| securityContext | object | `{}` | container-level security context |
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
| serviceMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.selector | object | `{}` | Prometheus ServiceMonitor selector |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/mailcow-exporter
```

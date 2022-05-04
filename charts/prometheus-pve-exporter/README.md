# prometheus-pve-exporter

## TL;DR;

```console
helm repo add christianknell https://charts.knell.it
helm install my-release christianknell/prometheus-pve-exporter
```

## Introduction

A Prometheus exporter for [Proxmox Virtual Environment](https://proxmox.com/en/proxmox-ve) metrics.

This chart bootstraps a [PVE Exporter](https://github.com/prometheus-pve/prometheus-pve-exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://charts.knell.it
helm install my-release christianknell/prometheus-pve-exporter
```

These commands deploy prometheus-pve-exporter on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

The following tables list the configurable parameters of the prometheus-pve-exporter chart and their default values.

| Key                              | Type   | Default                                                                                                 | Description                                                                                                            |
| -------------------------------- | ------ | ------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| affinity                         | object | `{}`                                                                                                    | Assign custom [affinity] rules                                                                                         |
| args                             | list   | `[]`                                                                                                    |                                                                                                                        |
| env.pveAuthType                  | string | `"token"`                                                                                               |                                                                                                                        |
| env.pveExistingSecretName        | string | `""`                                                                                                    |                                                                                                                        |
| env.pvePassword                  | string | `""`                                                                                                    |                                                                                                                        |
| env.pveTokenName                 | string | `""`                                                                                                    |                                                                                                                        |
| env.pveTokenValue                | string | `""`                                                                                                    |                                                                                                                        |
| env.pveUser                      | string | `""`                                                                                                    |                                                                                                                        |
| env.pveVerifySsl                 | bool   | `false`                                                                                                 |                                                                                                                        |
| fullnameOverride                 | string | `""`                                                                                                    | String to fully override `"prometheus-pve-exporter.fullname"`                                                          |
| image.pullPolicy                 | string | `"Always"`                                                                                              |                                                                                                                        |
| image.repository                 | string | `"prompve/prometheus-pve-exporter"`                                                                     |                                                                                                                        |
| image.tag                        | string | `""`                                                                                                    |                                                                                                                        |
| imagePullSecrets                 | list   | `[]`                                                                                                    | If defined, uses a Secret to pull an image from a private Docker registry or repository.                               |
| nameOverride                     | string | `""`                                                                                                    | Provide a name in place of `prometheus-pve-exporter`                                                                   |
| nodeSelector                     | object | `{}`                                                                                                    | [Node selector]                                                                                                        |
| podAnnotations                   | object | `{}`                                                                                                    | Annotations to be added to exporter pods                                                                               |
| replicaCount                     | int    | `1`                                                                                                     |                                                                                                                        |
| resources                        | object | `{}`                                                                                                    | Resource limits and requests for the controller pods.                                                                  |
| securityContext                  | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534}` | container-level security context                                                                                       |
| service.port                     | int    | `80`                                                                                                    |                                                                                                                        |
| service.type                     | string | `"ClusterIP"`                                                                                           |                                                                                                                        |
| serviceAccount.annotations       | object | `{}`                                                                                                    | Annotations to add to the service account                                                                              |
| serviceAccount.create            | bool   | `true`                                                                                                  | Specifies whether a service account should be created                                                                  |
| serviceAccount.name              | string | `""`                                                                                                    | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.additionalLabels  | object | `{}`                                                                                                    | Prometheus ServiceMonitor labels                                                                                       |
| serviceMonitor.enabled           | bool   | `false`                                                                                                 | Enable a prometheus ServiceMonitor                                                                                     |
| serviceMonitor.interval          | string | `"30s"`                                                                                                 | Prometheus ServiceMonitor interval                                                                                     |
| serviceMonitor.metricRelabelings | list   | `[]`                                                                                                    | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion                                                 |
| serviceMonitor.namespace         | string | `""`                                                                                                    | Prometheus ServiceMonitor namespace                                                                                    |
| serviceMonitor.pveTargets        | list   | `[]`                                                                                                    | Prometheus                                                                                                             |
| serviceMonitor.relabelings       | list   | `[]`                                                                                                    | Prometheus [RelabelConfigs] to apply to samples before scraping                                                        |
| serviceMonitor.selector          | object | `{}`                                                                                                    | Prometheus ServiceMonitor selector                                                                                     |
| tolerations                      | list   | `[]`                                                                                                    | [Tolerations] for use with node taints                                                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/prometheus-pve-exporter
```
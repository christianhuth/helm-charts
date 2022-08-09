# netcupscp-exporter

Prometheus Exporter for Netcup Server Control Panel (SCP)

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.3](https://img.shields.io/badge/AppVersion-v0.1.3-informational?style=flat-square)

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/netcupscp-exporter
```

## Introduction

This chart bootstraps a [Prometheus Exporter for Netcup ServerControlPanel (SCP) WebService](https://github.com/mrueg/netcupscp-exporter) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/netcupscp-exporter
```

These commands deploy Skooner on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                        | Type   | Default                      | Description                                                            |
| ------------------------------------------ | ------ | ---------------------------- | ---------------------------------------------------------------------- |
| affinity                                   | object | `{}`                         |                                                                        |
| autoscaling.enabled                        | bool   | `false`                      |                                                                        |
| autoscaling.maxReplicas                    | int    | `100`                        |                                                                        |
| autoscaling.minReplicas                    | int    | `1`                          |                                                                        |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                         |                                                                        |
| env.loginName                              | string | `""`                         |                                                                        |
| env.password                               | string | `""`                         |                                                                        |
| fullnameOverride                           | string | `""`                         |                                                                        |
| image.pullPolicy                           | string | `"Always"`                   |                                                                        |
| image.registry                             | string | `"ghcr.io"`                  |                                                                        |
| image.repository                           | string | `"mrueg/netcupscp-exporter"` |                                                                        |
| image.tag                                  | string | `"v0.1.3"`                   |                                                                        |
| imagePullSecrets                           | list   | `[]`                         |                                                                        |
| ingress.annotations                        | object | `{}`                         |                                                                        |
| ingress.className                          | string | `""`                         |                                                                        |
| ingress.enabled                            | bool   | `false`                      |                                                                        |
| ingress.hosts[0].host                      | string | `"chart-example.local"`      |                                                                        |
| ingress.hosts[0].paths[0].path             | string | `"/"`                        |                                                                        |
| ingress.hosts[0].paths[0].pathType         | string | `"ImplementationSpecific"`   |                                                                        |
| ingress.tls                                | list   | `[]`                         |                                                                        |
| nameOverride                               | string | `""`                         |                                                                        |
| nodeSelector                               | object | `{}`                         |                                                                        |
| podAnnotations                             | object | `{}`                         |                                                                        |
| podSecurityContext                         | object | `{}`                         |                                                                        |
| replicaCount                               | int    | `1`                          |                                                                        |
| resources                                  | object | `{}`                         |                                                                        |
| securityContext                            | object | `{}`                         |                                                                        |
| service.port                               | int    | `80`                         |                                                                        |
| service.type                               | string | `"ClusterIP"`                |                                                                        |
| serviceAccount.annotations                 | object | `{}`                         |                                                                        |
| serviceAccount.create                      | bool   | `true`                       |                                                                        |
| serviceAccount.name                        | string | `""`                         |                                                                        |
| serviceMonitor.additionalLabels            | object | `{}`                         | Prometheus ServiceMonitor labels                                       |
| serviceMonitor.enabled                     | bool   | `false`                      | Enable a prometheus ServiceMonitor                                     |
| serviceMonitor.interval                    | string | `"30s"`                      | Prometheus ServiceMonitor interval                                     |
| serviceMonitor.metricRelabelings           | list   | `[]`                         | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.namespace                   | string | `""`                         | Prometheus ServiceMonitor namespace                                    |
| serviceMonitor.relabelings                 | list   | `[]`                         | Prometheus [RelabelConfigs] to apply to samples before scraping        |
| serviceMonitor.selector                    | object | `{}`                         | Prometheus ServiceMonitor selector                                     |
| tolerations                                | list   | `[]`                         |                                                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/netcupscp-exporter
```

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

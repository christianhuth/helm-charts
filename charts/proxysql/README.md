# proxysql

A proxysql Helm chart for Kubernetes. Offers option to expose web interface through Ingress. Uses ServiceMonitor to collect metrics.

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.4.2](https://img.shields.io/badge/AppVersion-2.4.2-informational?style=flat-square)

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/proxysql
```

## Introduction

This chart bootstraps a [ProxySQL](https://github.com/sysown/proxysql) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/proxysql
```

These commands deploy proxysql on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                                                | Type   | Default                    | Description |
| ------------------------------------------------------------------ | ------ | -------------------------- | ----------- |
| affinity                                                           | object | `{}`                       |             |
| autoscaling.enabled                                                | bool   | `false`                    |             |
| autoscaling.maxReplicas                                            | int    | `100`                      |             |
| autoscaling.minReplicas                                            | int    | `1`                        |             |
| autoscaling.targetCPUUtilizationPercentage                         | int    | `80`                       |             |
| fullnameOverride                                                   | string | `""`                       |             |
| image.pullPolicy                                                   | string | `"Always"`                 |             |
| image.repository                                                   | string | `"proxysql/proxysql"`      |             |
| image.tag                                                          | string | `""`                       |             |
| imagePullSecrets                                                   | list   | `[]`                       |             |
| ingress.annotations."nginx.ingress.kubernetes.io/backend-protocol" | string | `"HTTPS"`                  |             |
| ingress.className                                                  | string | `""`                       |             |
| ingress.enabled                                                    | bool   | `false`                    |             |
| ingress.hosts[0].host                                              | string | `"chart-example.local"`    |             |
| ingress.hosts[0].paths[0].path                                     | string | `"/"`                      |             |
| ingress.hosts[0].paths[0].pathType                                 | string | `"ImplementationSpecific"` |             |
| ingress.tls                                                        | list   | `[]`                       |             |
| metrics.enabled                                                    | bool   | `false`                    |             |
| metrics.serviceMonitor.additionalLabels                            | object | `{}`                       |             |
| metrics.serviceMonitor.enabled                                     | bool   | `false`                    |             |
| nameOverride                                                       | string | `""`                       |             |
| nodeSelector                                                       | object | `{}`                       |             |
| podAnnotations                                                     | object | `{}`                       |             |
| podSecurityContext.fsGroup                                         | int    | `999`                      |             |
| podSecurityContext.runAsGroup                                      | int    | `999`                      |             |
| podSecurityContext.runAsNonRoot                                    | bool   | `true`                     |             |
| podSecurityContext.runAsUser                                       | int    | `999`                      |             |
| proxysql.admin.password                                            | string | `"admin"`                  |             |
| proxysql.admin.user                                                | string | `"admin"`                  |             |
| proxysql.cluster.claim.accessModes[0]                              | string | `"ReadWriteOnce"`          |             |
| proxysql.cluster.claim.enabled                                     | bool   | `true`                     |             |
| proxysql.cluster.claim.size                                        | string | `"1Gi"`                    |             |
| proxysql.cluster.claim.storageClassName                            | string | `"default"`                |             |
| proxysql.cluster.enabled                                           | bool   | `false`                    |             |
| proxysql.cluster.password                                          | string | `"cluster"`                |             |
| proxysql.cluster.user                                              | string | `"cluster"`                |             |
| proxysql.monitor.enabled                                           | bool   | `false`                    |             |
| proxysql.monitor.replicationLagInterval                            | int    | `10000`                    |             |
| proxysql.monitor.replicationLagTimeout                             | int    | `1500`                     |             |
| proxysql.monitor.slaveLagWhenNull                                  | int    | `60`                       |             |
| proxysql.monitor.writerAsReader                                    | bool   | `true`                     |             |
| proxysql.mysql.connectionMaxAgeMS                                  | int    | `0`                        |             |
| proxysql.mysql.galera.enabled                                      | bool   | `false`                    |             |
| proxysql.mysql.galera.maxWriters                                   | int    | `1`                        |             |
| proxysql.mysql.galera.writerAsReader                               | bool   | `true`                     |             |
| proxysql.mysql.maxConnections                                      | int    | `2048`                     |             |
| proxysql.mysql.port                                                | int    | `3306`                     |             |
| proxysql.mysql.queryRetriesOnFailure                               | int    | `2`                        |             |
| proxysql.mysql.queyCacheSizeMB                                     | int    | `256`                      |             |
| proxysql.mysql.readWriteSplit                                      | bool   | `true`                     |             |
| proxysql.mysql.servers                                             | list   | `[]`                       |             |
| proxysql.mysql.slave.checkType                                     | string | `"read_only"`              |             |
| proxysql.mysql.slave.enabled                                       | bool   | `false`                    |             |
| proxysql.mysql.users                                               | list   | `[]`                       |             |
| proxysql.mysql.version                                             | string | `"5.7.34"`                 |             |
| proxysql.mysql.waitTimeout                                         | int    | `28800000`                 |             |
| proxysql.port                                                      | int    | `6032`                     |             |
| proxysql.web.enabled                                               | bool   | `true`                     |             |
| proxysql.web.password                                              | string | `"sadmin"`                 |             |
| proxysql.web.port                                                  | int    | `443`                      |             |
| proxysql.web.user                                                  | string | `"sadmin"`                 |             |
| replicaCount                                                       | int    | `1`                        |             |
| resources                                                          | object | `{}`                       |             |
| securityContext                                                    | object | `{}`                       |             |
| service.annotations                                                | object | `{}`                       |             |
| service.type                                                       | string | `"ClusterIP"`              |             |
| serviceAccount.annotations                                         | object | `{}`                       |             |
| serviceAccount.create                                              | bool   | `true`                     |             |
| serviceAccount.name                                                | string | `""`                       |             |
| tolerations                                                        | list   | `[]`                       |             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/proxysql
```

---

Autogenerated from chart metadata using [helm-docs v1.10.0](https://github.com/norwoodj/helm-docs/releases/v1.10.0)

# proxysql

A proxysql Helm chart for Kubernetes. Offers option to expose web interface through Ingress. Uses ServiceMonitor to collect metrics.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/proxysql
```

## Introduction

This chart bootstraps a [ProxySQL](https://github.com/sysown/proxysql) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/proxysql
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

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` | String to fully override `"proxysql.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"proxysql/proxysql"` | image repository |
| image.tag | string | `"3.0.1"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations."nginx.ingress.kubernetes.io/backend-protocol" | string | `"HTTPS"` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| metrics.enabled | bool | `false` |  |
| metrics.serviceMonitor.additionalLabels | object | `{}` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| nameOverride | string | `""` | Provide a name in place of `proxysql` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podSecurityContext | object | `{"fsGroup":999,"runAsGroup":999,"runAsNonRoot":true,"runAsUser":999}` | pod-level security context |
| proxysql.admin.password | string | `"admin"` |  |
| proxysql.admin.user | string | `"admin"` |  |
| proxysql.cluster.claim.accessModes[0] | string | `"ReadWriteOnce"` |  |
| proxysql.cluster.claim.enabled | bool | `true` |  |
| proxysql.cluster.claim.size | string | `"1Gi"` |  |
| proxysql.cluster.claim.storageClassName | string | `"default"` |  |
| proxysql.cluster.enabled | bool | `false` |  |
| proxysql.cluster.password | string | `"cluster"` |  |
| proxysql.cluster.user | string | `"cluster"` |  |
| proxysql.monitor.enabled | bool | `false` |  |
| proxysql.monitor.replicationLagInterval | int | `10000` |  |
| proxysql.monitor.replicationLagTimeout | int | `1500` |  |
| proxysql.monitor.slaveLagWhenNull | int | `60` |  |
| proxysql.monitor.writerAsReader | bool | `true` |  |
| proxysql.mysql.connectionMaxAgeMS | int | `0` |  |
| proxysql.mysql.galera.enabled | bool | `false` |  |
| proxysql.mysql.galera.maxWriters | int | `1` |  |
| proxysql.mysql.galera.writerAsReader | bool | `true` |  |
| proxysql.mysql.maxConnections | int | `2048` |  |
| proxysql.mysql.port | int | `3306` |  |
| proxysql.mysql.queryRetriesOnFailure | int | `2` |  |
| proxysql.mysql.queyCacheSizeMB | int | `256` |  |
| proxysql.mysql.readWriteSplit | bool | `true` |  |
| proxysql.mysql.servers | list | `[]` |  |
| proxysql.mysql.slave.checkType | string | `"read_only"` |  |
| proxysql.mysql.slave.enabled | bool | `false` |  |
| proxysql.mysql.users | list | `[]` |  |
| proxysql.mysql.version | string | `"5.7.34"` |  |
| proxysql.mysql.waitTimeout | int | `28800000` |  |
| proxysql.port | int | `6032` |  |
| proxysql.web.enabled | bool | `true` |  |
| proxysql.web.password | string | `"sadmin"` |  |
| proxysql.web.port | int | `443` |  |
| proxysql.web.user | string | `"sadmin"` |  |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the headwind pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| securityContext | object | `{}` | container-level security context |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/proxysql
```

# polr

Polr is a quick, modern, and open-source link shortener

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/polr
```

## Introduction

This chart bootstraps a quick, modern and open-source link shortener called [Polr](https://polrproject.org/) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/polr
```

These commands deploy Polr on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| admin.email | string | `""` |  |
| admin.existingSecret | string | `""` |  |
| admin.password | string | `"admin"` |  |
| admin.username | string | `"admin"` |  |
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env[0].name | string | `"APP_ADDRESS"` |  |
| env[0].value | string | `"polr.local"` |  |
| env[1].name | string | `"APP_NAME"` |  |
| env[1].value | string | `"Polr"` |  |
| externalDatabase.database | string | `"polr"` |  |
| externalDatabase.existingSecret | string | `""` |  |
| externalDatabase.host | string | `"polr-mysql"` |  |
| externalDatabase.password | string | `"polr"` |  |
| externalDatabase.port | string | `"3306"` |  |
| externalDatabase.username | string | `"polr"` |  |
| fullnameOverride | string | `""` | String to fully override `"polr.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"ajanvier/polr"` | image repository |
| image.tag | string | `"2.3.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| mail.enabled | bool | `false` |  |
| mail.existingSecret | string | `""` |  |
| mail.fromAddress | string | `""` |  |
| mail.fromName | string | `""` |  |
| mail.host | string | `""` |  |
| mail.password | string | `""` |  |
| mail.port | string | `""` |  |
| mail.username | string | `""` |  |
| mysql.auth.database | string | `"polr"` |  |
| mysql.auth.existingSecret | string | `""` |  |
| mysql.auth.password | string | `"polr"` |  |
| mysql.auth.username | string | `"polr"` |  |
| mysql.enabled | bool | `true` |  |
| nameOverride | string | `""` | Provide a name in place of `polr` |
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
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/polr
```

## Upgrading the Chart

### To 4.0.0

This major updates the MySQL subchart to its newest major, 14.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1400) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the MySQL subchart to its newest major, 13.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1300) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the MySQL subchart to its newest major, 12.2.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#upgrading) and [here](https://dev.mysql.com/doc/relnotes/mysql/8.4/en/) you can find more information about the changes introduced in that version.

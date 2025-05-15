# taiga

Taiga is a free and open-source project management tool

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/taiga
```

## Introduction

This chart bootstraps the free and open-source project management tool [Taiga](https://taiga.io) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/taiga
```

These commands deploy Taiga on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| externalDatabase.auth.database | string | `"taiga"` | Name of the database to use |
| externalDatabase.auth.existingSecret | string | `""` | Name of existing secret to use for database credentials |
| externalDatabase.auth.password | string | `"taiga"` | Password to use |
| externalDatabase.auth.userPasswordKey | string | `""` | Key in the secret containing the password |
| externalDatabase.auth.username | string | `"taiga"` | Name of the user to use |
| externalDatabase.hostname | string | `""` | Hostname of the database |
| externalDatabase.port | int | `5432` | Port used to connect to database |
| fullnameOverride | string | `""` | String to fully override `"taiga.fullname"` |
| nameOverride | string | `""` | Provide a name in place of `taiga` |
| postgresql.auth.database | string | `"taiga"` | Name for a custom database to create |
| postgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| postgresql.auth.password | string | `"taiga"` | Password for the custom user to create. Ignored if postgresql.auth.existingSecret is provided |
| postgresql.auth.username | string | `"taiga"` | Name for a custom user to create |
| postgresql.enabled | bool | `true` | enable PostgreSQL™ subchart from Bitnami |
| rabbitmq.auth.existingSecret | string | `""` | Use existing secret for password details (`config.rabbitmq.auth.password` will be ignored and picked up from this secret). The secret has to contain the key `rabbitmq-password`. |
| rabbitmq.auth.password | string | `""` | The password credential to be used when using an external database driver. |
| rabbitmq.auth.username | string | `""` | The username credential to be used when using an external database driver. |
| rabbitmq.enabled | bool | `true` | enable integrated RabbitMQ™ subchart from Bitnami |
| rabbitmq.host | string | `""` | The RabbitMQ server host name |
| rabbitmq.useSsl | bool | `false` | Whether connection is encrypted with SSL/TLS or not. |
| rabbitmq.vhost | string | `"/"` | The RabbitMQ server VHost |
| taiga.backend.affinity | object | `{}` | Affinity settings for pod assignment |
| taiga.backend.autoscaling.enabled | bool | `false` |  |
| taiga.backend.autoscaling.maxReplicas | int | `100` |  |
| taiga.backend.autoscaling.minReplicas | int | `1` |  |
| taiga.backend.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| taiga.backend.image.pullPolicy | string | `"Always"` | image pull policy |
| taiga.backend.image.registry | string | `"docker.io"` | image registry |
| taiga.backend.image.repository | string | `"taigaio/taiga-back"` | image repository |
| taiga.backend.image.tag | string | `"6.8.2"` | Overrides the image tag |
| taiga.backend.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| taiga.backend.nodeSelector | object | `{}` | Node labels for pod assignment |
| taiga.backend.podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| taiga.backend.podSecurityContext | object | `{}` | pod-level security context |
| taiga.backend.replicaCount | int | `1` | Number of replicas |
| taiga.backend.resources | object | `{}` | Resource limits and requests for the headwind pods. |
| taiga.backend.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| taiga.backend.securityContext | object | `{}` | container-level security context |
| taiga.backend.service.port | int | `8080` | Kubernetes port where service is exposed |
| taiga.backend.service.type | string | `"ClusterIP"` | Kubernetes service type |
| taiga.backend.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| taiga.backend.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| taiga.backend.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| taiga.backend.tolerations | list | `[]` | Toleration labels for pod assignment |
| taiga.frontend.affinity | object | `{}` | Affinity settings for pod assignment |
| taiga.frontend.autoscaling.enabled | bool | `false` |  |
| taiga.frontend.autoscaling.maxReplicas | int | `100` |  |
| taiga.frontend.autoscaling.minReplicas | int | `1` |  |
| taiga.frontend.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| taiga.frontend.image.pullPolicy | string | `"Always"` | image pull policy |
| taiga.frontend.image.registry | string | `"docker.io"` | image registry |
| taiga.frontend.image.repository | string | `"taigaio/taiga-back"` | image repository |
| taiga.frontend.image.tag | string | `"6.8.2"` | Overrides the image tag |
| taiga.frontend.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| taiga.frontend.ingress.annotations | object | `{}` |  |
| taiga.frontend.ingress.className | string | `""` |  |
| taiga.frontend.ingress.enabled | bool | `false` |  |
| taiga.frontend.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| taiga.frontend.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| taiga.frontend.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| taiga.frontend.ingress.tls | list | `[]` |  |
| taiga.frontend.nodeSelector | object | `{}` | Node labels for pod assignment |
| taiga.frontend.podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| taiga.frontend.podSecurityContext | object | `{}` | pod-level security context |
| taiga.frontend.replicaCount | int | `1` | Number of replicas |
| taiga.frontend.resources | object | `{}` | Resource limits and requests for the headwind pods. |
| taiga.frontend.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| taiga.frontend.securityContext | object | `{}` | container-level security context |
| taiga.frontend.service.port | int | `8080` | Kubernetes port where service is exposed |
| taiga.frontend.service.type | string | `"ClusterIP"` | Kubernetes service type |
| taiga.frontend.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| taiga.frontend.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| taiga.frontend.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| taiga.frontend.tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/taiga
```

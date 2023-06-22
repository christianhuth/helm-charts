# shlink-backend

A PHP-based self-hosted URL shortener that can be used to serve shortened URLs under your own domain.

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/shlink-backend
```

## Introduction

This chart bootstraps a self-hosted URL shortener called [Shlink](https://shlink.io) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/shlink-backend
```

These commands deploy Shlink on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                        | Type   | Default                    | Description                                                                                                            |
| ------------------------------------------ | ------ | -------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| affinity                                   | object | `{}`                       | Affinity settings for pod assignment                                                                                   |
| autoscaling.enabled                        | bool   | `false`                    |                                                                                                                        |
| autoscaling.maxReplicas                    | int    | `100`                      |                                                                                                                        |
| autoscaling.minReplicas                    | int    | `1`                        |                                                                                                                        |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                       |                                                                                                                        |
| env[0].name                                | string | `"DEFAULT_DOMAIN"`         |                                                                                                                        |
| env[0].value                               | string | `"doma.in"`                |                                                                                                                        |
| env[1].name                                | string | `"IS_HTTPS_ENABLED"`       |                                                                                                                        |
| env[1].value                               | string | `"false"`                  |                                                                                                                        |
| fullnameOverride                           | string | `""`                       | String to fully override `"shlink-backend.fullname"`                                                                   |
| image.pullPolicy                           | string | `"Always"`                 | image pull policy                                                                                                      |
| image.repository                           | string | `"shlinkio/shlink"`        | image repository                                                                                                       |
| image.tag                                  | string | `"3.6.3"`                  | Overrides the image tag                                                                                                |
| imagePullSecrets                           | list   | `[]`                       | If defined, uses a Secret to pull an image from a private Docker registry or repository.                               |
| ingress.annotations                        | object | `{}`                       |                                                                                                                        |
| ingress.className                          | string | `""`                       |                                                                                                                        |
| ingress.enabled                            | bool   | `false`                    |                                                                                                                        |
| ingress.hosts[0].host                      | string | `"chart-example.local"`    |                                                                                                                        |
| ingress.hosts[0].paths[0].path             | string | `"/"`                      |                                                                                                                        |
| ingress.hosts[0].paths[0].pathType         | string | `"ImplementationSpecific"` |                                                                                                                        |
| ingress.tls                                | list   | `[]`                       |                                                                                                                        |
| mariadb.auth.database                      | string | `"shlink"`                 |                                                                                                                        |
| mariadb.auth.password                      | string | `"shlink"`                 |                                                                                                                        |
| mariadb.auth.username                      | string | `"shlink"`                 |                                                                                                                        |
| mariadb.enabled                            | bool   | `false`                    |                                                                                                                        |
| mysql.auth.database                        | string | `"shlink"`                 |                                                                                                                        |
| mysql.auth.password                        | string | `"shlink"`                 |                                                                                                                        |
| mysql.auth.username                        | string | `"shlink"`                 |                                                                                                                        |
| mysql.enabled                              | bool   | `false`                    |                                                                                                                        |
| nameOverride                               | string | `""`                       | Provide a name in place of `shlink-backend`                                                                            |
| nodeSelector                               | object | `{}`                       | Node labels for pod assignment                                                                                         |
| podAnnotations                             | object | `{}`                       | Annotations to be added to exporter pods                                                                               |
| podSecurityContext                         | object | `{}`                       | pod-level security context                                                                                             |
| postgresql.auth.database                   | string | `"shlink"`                 |                                                                                                                        |
| postgresql.auth.password                   | string | `"shlink"`                 |                                                                                                                        |
| postgresql.auth.username                   | string | `"shlink"`                 |                                                                                                                        |
| postgresql.enabled                         | bool   | `false`                    |                                                                                                                        |
| rabbitmq.enabled                           | bool   | `false`                    |                                                                                                                        |
| redis.auth.enabled                         | bool   | `false`                    |                                                                                                                        |
| redis.enabled                              | bool   | `false`                    |                                                                                                                        |
| replicaCount                               | int    | `1`                        | Number of replicas                                                                                                     |
| resources                                  | object | `{}`                       | Resource limits and requests for the headwind pods.                                                                    |
| revisionHistoryLimit                       | int    | `10`                       | The number of old ReplicaSets to retain                                                                                |
| securityContext                            | object | `{}`                       | container-level security context                                                                                       |
| service.port                               | int    | `80`                       | Kubernetes port where service is exposed                                                                               |
| service.type                               | string | `"ClusterIP"`              | Kubernetes service type                                                                                                |
| serviceAccount.annotations                 | object | `{}`                       | Annotations to add to the service account                                                                              |
| serviceAccount.create                      | bool   | `true`                     | Specifies whether a service account should be created                                                                  |
| serviceAccount.name                        | string | `""`                       | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations                                | list   | `[]`                       | Toleration labels for pod assignment                                                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/shlink-backend
```

## Upgrading the Chart

### To 2.0.0

This major updates the RabbitMQ subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq#upgrading) and [here](https://www.rabbitmq.com/upgrade.html) you can find more information about the changes introduced in that version.

### To 1.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

Additionally it updates the RabbitMQ subchart to its newest major, 11.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq#to-1100) you can find more information about the changes introduced in that version.

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

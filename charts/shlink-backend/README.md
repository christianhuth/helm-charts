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

| Key                                        | Type   | Default                    | Description |
| ------------------------------------------ | ------ | -------------------------- | ----------- |
| affinity                                   | object | `{}`                       |             |
| autoscaling.enabled                        | bool   | `false`                    |             |
| autoscaling.maxReplicas                    | int    | `100`                      |             |
| autoscaling.minReplicas                    | int    | `1`                        |             |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                       |             |
| env[0].name                                | string | `"DEFAULT_DOMAIN"`         |             |
| env[0].value                               | string | `"doma.in"`                |             |
| env[1].name                                | string | `"IS_HTTPS_ENABLED"`       |             |
| env[1].value                               | string | `"false"`                  |             |
| fullnameOverride                           | string | `""`                       |             |
| image.pullPolicy                           | string | `"Always"`                 |             |
| image.repository                           | string | `"shlinkio/shlink"`        |             |
| image.tag                                  | string | `"3.3.2"`                  |             |
| imagePullSecrets                           | list   | `[]`                       |             |
| ingress.annotations                        | object | `{}`                       |             |
| ingress.className                          | string | `""`                       |             |
| ingress.enabled                            | bool   | `false`                    |             |
| ingress.hosts[0].host                      | string | `"chart-example.local"`    |             |
| ingress.hosts[0].paths[0].path             | string | `"/"`                      |             |
| ingress.hosts[0].paths[0].pathType         | string | `"ImplementationSpecific"` |             |
| ingress.tls                                | list   | `[]`                       |             |
| mariadb.auth.database                      | string | `"shlink"`                 |             |
| mariadb.auth.password                      | string | `"shlink"`                 |             |
| mariadb.auth.username                      | string | `"shlink"`                 |             |
| mariadb.enabled                            | bool   | `false`                    |             |
| mysql.auth.database                        | string | `"shlink"`                 |             |
| mysql.auth.password                        | string | `"shlink"`                 |             |
| mysql.auth.username                        | string | `"shlink"`                 |             |
| mysql.enabled                              | bool   | `false`                    |             |
| nameOverride                               | string | `""`                       |             |
| nodeSelector                               | object | `{}`                       |             |
| podAnnotations                             | object | `{}`                       |             |
| podSecurityContext                         | object | `{}`                       |             |
| postgresql.auth.database                   | string | `"shlink"`                 |             |
| postgresql.auth.password                   | string | `"shlink"`                 |             |
| postgresql.auth.username                   | string | `"shlink"`                 |             |
| postgresql.enabled                         | bool   | `false`                    |             |
| rabbitmq.enabled                           | bool   | `false`                    |             |
| redis.auth.enabled                         | bool   | `false`                    |             |
| redis.enabled                              | bool   | `false`                    |             |
| replicaCount                               | int    | `1`                        |             |
| resources                                  | object | `{}`                       |             |
| securityContext                            | object | `{}`                       |             |
| service.port                               | int    | `80`                       |             |
| service.type                               | string | `"ClusterIP"`              |             |
| serviceAccount.annotations                 | object | `{}`                       |             |
| serviceAccount.create                      | bool   | `true`                     |             |
| serviceAccount.name                        | string | `""`                       |             |
| tolerations                                | list   | `[]`                       |             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/shlink-backend
```

## Upgrading the Chart

### 1.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

Additionally it updates the RabbitMQ subchart to its newest major, 11.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq#to-1100) you can find more information about the changes introduced in that version.

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

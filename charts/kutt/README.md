# kutt

Kutt is a free modern URL shortener.

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/kutt
```

## Introduction

This chart bootstraps the free modern URL shortener called [Kutt](https://kutt.it) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/kutt
```

These commands deploy Kutt on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                        | Type   | Default                        | Description |
| ------------------------------------------ | ------ | ------------------------------ | ----------- |
| affinity                                   | object | `{}`                           |             |
| autoscaling.enabled                        | bool   | `false`                        |             |
| autoscaling.maxReplicas                    | int    | `100`                          |             |
| autoscaling.minReplicas                    | int    | `1`                            |             |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                           |             |
| envSecrets.google.analytics                | string | `""`                           |             |
| envSecrets.google.analyticsUniversal       | string | `""`                           |             |
| envSecrets.google.existingSecret           | string | `""`                           |             |
| envSecrets.google.safeBrowsingKey          | string | `""`                           |             |
| envSecrets.jwt.existingSecret              | string | `""`                           |             |
| envSecrets.jwt.key                         | string | `"secret-jwt-key"`             |             |
| envSecrets.recaptcha.existingSecret        | string | `""`                           |             |
| envSecrets.recaptcha.secretKey             | string | `""`                           |             |
| envSecrets.recaptcha.siteKey               | string | `""`                           |             |
| env[0].name                                | string | `"ADMIN_EMAILS"`               |             |
| env[0].value                               | string | `""`                           |             |
| env[10].name                               | string | `"USER_LIMIT_PER_DAY"`         |             |
| env[10].value                              | string | `"50"`                         |             |
| env[1].name                                | string | `"CUSTOM_DOMAIN_USE_HTTPS"`    |             |
| env[1].value                               | string | `"false"`                      |             |
| env[2].name                                | string | `"DEFAULT_DOMAIN"`             |             |
| env[2].value                               | string | `"localhost:3000"`             |             |
| env[3].name                                | string | `"DEFAULT_MAX_STATS_PER_LINK"` |             |
| env[3].value                               | string | `"5000"`                       |             |
| env[4].name                                | string | `"DISALLOW_ANONYMOUS_LINKS"`   |             |
| env[4].value                               | string | `"false"`                      |             |
| env[5].name                                | string | `"DISALLOW_REGISTRATION"`      |             |
| env[5].value                               | string | `"false"`                      |             |
| env[6].name                                | string | `"LINK_LENGT"`                 |             |
| env[6].value                               | string | `"6"`                          |             |
| env[7].name                                | string | `"NON_USER_COOLDOWN"`          |             |
| env[7].value                               | string | `"0"`                          |             |
| env[8].name                                | string | `"REPORT_EMAIL"`               |             |
| env[8].value                               | string | `""`                           |             |
| env[9].name                                | string | `"SITE_NAME"`                  |             |
| env[9].value                               | string | `"Kutt"`                       |             |
| externalPostgresql.database                | string | `"kutt"`                       |             |
| externalPostgresql.existingSecret          | string | `""`                           |             |
| externalPostgresql.hostname                | string | `""`                           |             |
| externalPostgresql.password                | string | `"kutt"`                       |             |
| externalPostgresql.port                    | int    | `5432`                         |             |
| externalPostgresql.userPasswordKey         | string | `""`                           |             |
| externalPostgresql.username                | string | `"kutt"`                       |             |
| fullnameOverride                           | string | `""`                           |             |
| image.pullPolicy                           | string | `"Always"`                     |             |
| image.repository                           | string | `"kutt/kutt"`                  |             |
| image.tag                                  | string | `"v2.7.4"`                     |             |
| imagePullSecrets                           | list   | `[]`                           |             |
| ingress.annotations                        | object | `{}`                           |             |
| ingress.className                          | string | `""`                           |             |
| ingress.enabled                            | bool   | `false`                        |             |
| ingress.hosts[0].host                      | string | `"chart-example.local"`        |             |
| ingress.hosts[0].paths[0].path             | string | `"/"`                          |             |
| ingress.hosts[0].paths[0].pathType         | string | `"ImplementationSpecific"`     |             |
| ingress.tls                                | list   | `[]`                           |             |
| mail.existingSecret                        | string | `""`                           |             |
| mail.from                                  | string | `""`                           |             |
| mail.host                                  | string | `""`                           |             |
| mail.password                              | string | `""`                           |             |
| mail.port                                  | string | `""`                           |             |
| mail.secure                                | bool   | `true`                         |             |
| mail.username                              | string | `""`                           |             |
| nameOverride                               | string | `""`                           |             |
| nodeSelector                               | object | `{}`                           |             |
| podAnnotations                             | object | `{}`                           |             |
| podSecurityContext                         | object | `{}`                           |             |
| postgresql.auth.database                   | string | `"kutt"`                       |             |
| postgresql.auth.password                   | string | `"kutt"`                       |             |
| postgresql.auth.username                   | string | `"kutt"`                       |             |
| postgresql.enabled                         | bool   | `true`                         |             |
| redis.auth.enabled                         | bool   | `true`                         |             |
| redis.enabled                              | bool   | `true`                         |             |
| replicaCount                               | int    | `1`                            |             |
| resources                                  | object | `{}`                           |             |
| securityContext                            | object | `{}`                           |             |
| service.port                               | int    | `80`                           |             |
| service.type                               | string | `"ClusterIP"`                  |             |
| serviceAccount.annotations                 | object | `{}`                           |             |
| serviceAccount.create                      | bool   | `true`                         |             |
| serviceAccount.name                        | string | `""`                           |             |
| tolerations                                | list   | `[]`                           |             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/kutt
```

## Upgrading the Chart

### 1.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

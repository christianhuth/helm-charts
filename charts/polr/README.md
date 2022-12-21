# polr

Polr is a quick, modern, and open-source link shortener

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/polr
```

## Introduction

This chart bootstraps a quick, modern and open-source link shortener called [Polr](https://polrproject.org/) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/polr
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

| Key                                        | Type   | Default                    | Description |
| ------------------------------------------ | ------ | -------------------------- | ----------- |
| admin.email                                | string | `""`                       |             |
| admin.existingSecret                       | string | `""`                       |             |
| admin.password                             | string | `"admin"`                  |             |
| admin.username                             | string | `"admin"`                  |             |
| affinity                                   | object | `{}`                       |             |
| autoscaling.enabled                        | bool   | `false`                    |             |
| autoscaling.maxReplicas                    | int    | `100`                      |             |
| autoscaling.minReplicas                    | int    | `1`                        |             |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                       |             |
| env[0].name                                | string | `"APP_ADDRESS"`            |             |
| env[0].value                               | string | `"polr.local"`             |             |
| env[1].name                                | string | `"APP_NAME"`               |             |
| env[1].value                               | string | `"Polr"`                   |             |
| externalDatabase.database                  | string | `"polr"`                   |             |
| externalDatabase.existingSecret            | string | `""`                       |             |
| externalDatabase.host                      | string | `"polr-mysql"`             |             |
| externalDatabase.password                  | string | `"polr"`                   |             |
| externalDatabase.port                      | string | `"3306"`                   |             |
| externalDatabase.username                  | string | `"polr"`                   |             |
| fullnameOverride                           | string | `""`                       |             |
| image.pullPolicy                           | string | `"Always"`                 |             |
| image.repository                           | string | `"ajanvier/polr"`          |             |
| image.tag                                  | string | `"2.3.0"`                  |             |
| imagePullSecrets                           | list   | `[]`                       |             |
| ingress.annotations                        | object | `{}`                       |             |
| ingress.className                          | string | `""`                       |             |
| ingress.enabled                            | bool   | `false`                    |             |
| ingress.hosts[0].host                      | string | `"chart-example.local"`    |             |
| ingress.hosts[0].paths[0].path             | string | `"/"`                      |             |
| ingress.hosts[0].paths[0].pathType         | string | `"ImplementationSpecific"` |             |
| ingress.tls                                | list   | `[]`                       |             |
| mail.enabled                               | bool   | `false`                    |             |
| mail.existingSecret                        | string | `""`                       |             |
| mail.fromAddress                           | string | `""`                       |             |
| mail.fromName                              | string | `""`                       |             |
| mail.host                                  | string | `""`                       |             |
| mail.password                              | string | `""`                       |             |
| mail.port                                  | string | `""`                       |             |
| mail.username                              | string | `""`                       |             |
| mysql.auth.database                        | string | `"polr"`                   |             |
| mysql.auth.existingSecret                  | string | `""`                       |             |
| mysql.auth.password                        | string | `"polr"`                   |             |
| mysql.auth.username                        | string | `"polr"`                   |             |
| mysql.enabled                              | bool   | `true`                     |             |
| nameOverride                               | string | `""`                       |             |
| nodeSelector                               | object | `{}`                       |             |
| podAnnotations                             | object | `{}`                       |             |
| podSecurityContext                         | object | `{}`                       |             |
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
helm install my-release -f values.yaml christianknell/polr
```

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

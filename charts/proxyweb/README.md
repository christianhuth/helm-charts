# proxyweb

A Helm chart for Kubernetes

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/proxyweb
```

## Introduction

This chart bootstraps a [ProxyWeb](https://github.com/edmodo/proxyweb/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/proxyweb
```

These commands deploy ProxyWeb on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                                  | Type   | Default                    | Description |
| ---------------------------------------------------- | ------ | -------------------------- | ----------- |
| affinity                                             | object | `{}`                       |             |
| autoscaling.enabled                                  | bool   | `false`                    |             |
| autoscaling.maxReplicas                              | int    | `100`                      |             |
| autoscaling.minReplicas                              | int    | `1`                        |             |
| autoscaling.targetCPUUtilizationPercentage           | int    | `80`                       |             |
| configuration.config.flask.SECRET_KEY                | string | `"kaNGSGSLrEzaplUL"`       |             |
| configuration.config.flask.SEND_FILE_MAX_AGE_DEFAULT | int    | `0`                        |             |
| configuration.config.flask.TEMPLATES_AUTO_RELOAD     | string | `"True"`                   |             |
| configuration.config.global.default_server           | string | `"proxysql"`               |             |
| configuration.config.global.hide_tables[0]           | string | `""`                       |             |
| configuration.config.global.read_only                | bool   | `false`                    |             |
| configuration.config.servers.proxysql.dsn[0].db      | string | `"main"`                   |             |
| configuration.config.servers.proxysql.dsn[0].host    | string | `"127.0.0.1"`              |             |
| configuration.config.servers.proxysql.dsn[0].passwd  | string | `"admin"`                  |             |
| configuration.config.servers.proxysql.dsn[0].port    | string | `"6032"`                   |             |
| configuration.config.servers.proxysql.dsn[0].user    | string | `"admin"`                  |             |
| configuration.existingSecret                         | string | `""`                       |             |
| fullnameOverride                                     | string | `""`                       |             |
| image.pullPolicy                                     | string | `"Always"`                 |             |
| image.repository                                     | string | `"proxyweb/proxyweb"`      |             |
| image.tag                                            | string | `""`                       |             |
| imagePullSecrets                                     | list   | `[]`                       |             |
| ingress.annotations                                  | object | `{}`                       |             |
| ingress.className                                    | string | `""`                       |             |
| ingress.enabled                                      | bool   | `false`                    |             |
| ingress.hosts[0].host                                | string | `"chart-example.local"`    |             |
| ingress.hosts[0].paths[0].path                       | string | `"/"`                      |             |
| ingress.hosts[0].paths[0].pathType                   | string | `"ImplementationSpecific"` |             |
| ingress.tls                                          | list   | `[]`                       |             |
| nameOverride                                         | string | `""`                       |             |
| nodeSelector                                         | object | `{}`                       |             |
| podAnnotations                                       | object | `{}`                       |             |
| podSecurityContext                                   | object | `{}`                       |             |
| psp.enabled                                          | bool   | `false`                    |             |
| replicaCount                                         | int    | `1`                        |             |
| resources                                            | object | `{}`                       |             |
| securityContext                                      | object | `{}`                       |             |
| service.port                                         | int    | `80`                       |             |
| service.type                                         | string | `"ClusterIP"`              |             |
| serviceAccount.annotations                           | object | `{}`                       |             |
| serviceAccount.create                                | bool   | `true`                     |             |
| serviceAccount.name                                  | string | `""`                       |             |
| tolerations                                          | list   | `[]`                       |             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/proxyweb
```

---

Autogenerated from chart metadata using [helm-docs v1.10.0](https://github.com/norwoodj/helm-docs/releases/v1.10.0)

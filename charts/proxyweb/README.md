# proxyweb

A Helm chart for Kubernetes

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/proxyweb
```

## Introduction

This chart bootstraps a [ProxyWeb](https://github.com/edmodo/proxyweb/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/proxyweb
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

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| configuration.config.flask.SECRET_KEY | string | `"kaNGSGSLrEzaplUL"` |  |
| configuration.config.flask.SEND_FILE_MAX_AGE_DEFAULT | int | `0` |  |
| configuration.config.flask.TEMPLATES_AUTO_RELOAD | string | `"True"` |  |
| configuration.config.global.default_server | string | `"proxysql"` |  |
| configuration.config.global.hide_tables[0] | string | `""` |  |
| configuration.config.global.read_only | bool | `false` |  |
| configuration.config.misc.adhoc_report | list | see [values.yaml](./values.yaml) | List of reports that should be displayed |
| configuration.config.servers.proxysql.dsn[0].db | string | `"main"` |  |
| configuration.config.servers.proxysql.dsn[0].host | string | `"127.0.0.1"` |  |
| configuration.config.servers.proxysql.dsn[0].passwd | string | `"sadmin"` |  |
| configuration.config.servers.proxysql.dsn[0].port | string | `"6032"` |  |
| configuration.config.servers.proxysql.dsn[0].user | string | `"sadmin"` |  |
| configuration.existingSecret | string | `""` |  |
| fullnameOverride | string | `""` | String to fully override `"proxyweb.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.repository | string | `"proxyweb/proxyweb"` | image repository |
| image.tag | string | `"latest"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `proxyweb` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podSecurityContext | object | `{}` | pod-level security context |
| psp.enabled | bool | `false` |  |
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
helm install my-release -f values.yaml christianhuth/proxyweb
```

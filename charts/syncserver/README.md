# syncserver

Helm chart for Firefox Syncserver

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/syncserver
```

## Introduction

Run-Your-Own Firefox Sync Server

**Note that the upstream project is no longer being maintained.**
Use this at your own risk, and with the understanding that it is not being maintained, work is being done on its [replacement](https://github.com/mozilla-services/syncstorage-rs), and that no support or assistance will be offered.

This chart bootstraps the [Mozilla Syncserver](https://github.com/mozilla-services/syncserver) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/syncserver
```

These commands deploy the Mozilla Syncserver on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| fullnameOverride | string | `""` | String to fully override `"syncserver.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"mozilla/syncserver"` | image repository |
| image.tag | string | `"latest"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `syncserver` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the controller pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| securityContext | object | `{}` | container-level security context |
| service.port | int | `5000` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| syncserver.config.allowNewUser | bool | `false` | controls whether the server will accept requests from previously-unseen users |
| syncserver.config.batchUploadEnabled | bool | `true` |  |
| syncserver.config.debugEnabled | bool | `false` |  |
| syncserver.config.existingSecret | string | `""` | Name of an existing secret containing the syncserver secret under the key syncserver-secret |
| syncserver.config.forceWsgiEnviron | bool | `true` |  |
| syncserver.config.publicUrl | string | `"http://localhost:5000"` |  |
| syncserver.config.secret | string | `"super-strong-secret"` | Secret to secure the syncserver |
| syncserver.config.sqlUri | string | `"sqlite:////data/syncserver.db"` |  |
| syncserver.extraEnv | list | `[]` | additional environment variables to be added to the syncserver pods |
| syncserver.persistence.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| syncserver.persistence.annotations | object | `{}` |  |
| syncserver.persistence.enabled | bool | `false` |  |
| syncserver.persistence.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| syncserver.persistence.resources | object | `{}` | represents the minimum and maximum resources the volume should have. |
| syncserver.persistence.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/syncserver
```

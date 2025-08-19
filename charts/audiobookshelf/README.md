# audiobookshelf

A Helm chart for installing the Argo CD Metrics Server, which connects to Prometheus and can be used to display Metrics in the Argo CD UI

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/audiobookshelf
```

## Introduction

This chart bootstraps [Audiobookshelf](https://github.com/advplyr/audiobookshelf) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/audiobookshelf
```

These commands deploy Audiobookshelf on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| audiobookshelf.backup.path | string | `"/backups"` | Path to where backups are stored. Backups contain a backup of the database in /config and images/metadata stored in ./metadata/items and ./metadata/authors |
| audiobookshelf.backup.persistence.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| audiobookshelf.backup.persistence.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| audiobookshelf.backup.persistence.enabled | bool | `true` | use a PVC to persist the backup directory |
| audiobookshelf.backup.persistence.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| audiobookshelf.backup.persistence.resources | object | `{}` | represents the minimum and maximum resources the volume should have. |
| audiobookshelf.backup.persistence.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| audiobookshelf.config.path | string | `"/config"` | Path to the config directory. It will contain the database (users/books/libraries/settings). This location must not be mounted over the network. |
| audiobookshelf.config.persistence.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| audiobookshelf.config.persistence.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| audiobookshelf.config.persistence.enabled | bool | `true` | use a PVC to persist the config directory |
| audiobookshelf.config.persistence.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| audiobookshelf.config.persistence.resources | object | `{}` | represents the minimum and maximum resources the volume should have. |
| audiobookshelf.config.persistence.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| audiobookshelf.metadata.path | string | `"/metadata"` | Path to the metadata directory. It will contain cache, streams, covers, downloads, backups and logs. |
| audiobookshelf.metadata.persistence.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| audiobookshelf.metadata.persistence.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| audiobookshelf.metadata.persistence.enabled | bool | `true` | use a PVC to persist the metadata directory |
| audiobookshelf.metadata.persistence.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| audiobookshelf.metadata.persistence.resources | object | `{}` | represents the minimum and maximum resources the volume should have. |
| audiobookshelf.metadata.persistence.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| audiobookshelf.nodeEnv | string | `"production"` | Type of deployment. Should be production unless using development. |
| audiobookshelf.podcast.downloadTimeout | string | `"30"` | Timeout to wait for a podcast to start downloading. |
| audiobookshelf.query.logging | string | `""` | Debug information for logging SQL queries. Use log to log the queries, and benchmark to also log the runtime of each query. |
| audiobookshelf.query.profiling | string | `""` | Experimental profiling of specific database queries. Not implemented on most queries. |
| audiobookshelf.source | string | `"Helm"` | Installation source. Will be shown in the web client. |
| audiobookshelf.sqlite.cacheSize | string | `""` | Set the cache_size pragma for the SQLite database |
| audiobookshelf.sqlite.mmapSize | string | `""` | Set the mmap_size pragma for the SQLite database |
| audiobookshelf.sqlite.tempStore | string | `""` | Set the temp_store pragma for the SQLite database |
| audiobookshelf.timezone | string | `"Europe/Berlin"` | specify the time zone. Check list: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"argocd-extension-metrics.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"advplyr/audiobookshelf"` | image repository |
| image.tag | string | `"2.28.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `argocd-extension-metrics` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podSecurityContext | object | `{}` | pod-level security context |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{"requests":{"cpu":"100m","memory":"100Mi"}}` | Resource limits and requests for the controller pods. |
| revisionHistoryLimit | int | `0` | The number of old ReplicaSets to retain |
| securityContext | object | `{}` | container-level security context |
| service.port | int | `8080` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/audiobookshelf
```

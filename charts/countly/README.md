# countly

Countly is a product analytics platform that helps teams track, analyze and act-on their user actions and behaviour on mobile, web and desktop applications.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/baserow
```

## Introduction

Baserow is an open source no-code database and Airtable alternative.

This chart bootstraps [Baserow](https://gitlab.com/bramw/baserow) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/baserow
```

These commands deploys Baserow on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| api.affinity | object | `{}` | Affinity settings for pod assignment |
| api.autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| api.autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| api.autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| api.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| api.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| api.extraEnv | list | `[]` | additional environment variables to be added to the api pods |
| api.image.pullPolicy | string | `"Always"` | image pull policy |
| api.image.registry | string | `"docker.io"` | image registry |
| api.image.repository | string | `"countly/api"` | image repository |
| api.image.tag | string | `"24.10.8"` | Overrides the image tag |
| api.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| api.livenessProbe.failureThreshold | int | `6` | Failure threshold for livenessProbe |
| api.livenessProbe.initialDelaySeconds | int | `60` | Initial delay seconds for livenessProbe |
| api.livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe |
| api.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| api.livenessProbe.timeoutSeconds | int | `2` | Timeout in seconds for livenessProbe |
| api.nodeSelector | object | `{}` | Node labels for pod assignment |
| api.podAnnotations | object | `{}` | Annotations to be added to the frontend pods |
| api.podSecurityContext | object | `{}` | pod-level security context |
| api.priorityClassName | string | `""` | Pod priority class name |
| api.readinessProbe.failureThreshold | int | `6` | Failure threshold for readinessProbe |
| api.readinessProbe.initialDelaySeconds | int | `60` | Initial delay seconds for readinessProbe |
| api.readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| api.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| api.readinessProbe.timeoutSeconds | int | `2` | Timeout in seconds for readinessProbe |
| api.replicaCount | int | `1` | Number of replicas |
| api.resources | object | see [values.yaml](./values.yaml) | Resource limits and requests for the controller pods. |
| api.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| api.securityContext | object | `{}` | container-level security context |
| api.selectorLabels | object | `{}` | Additional labels to add to the pod |
| api.service.port | int | `3000` | Kubernetes port where service is exposed |
| api.service.type | string | `"ClusterIP"` | Kubernetes service type |
| api.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| api.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| api.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| api.tolerations | list | `[]` | Toleration labels for pod assignment |
| config.api.mail.auth.existingSecret | string | `""` | Use existing secret for password details. The secret has to contain the key `mail-password`. When it's set the `config.api.mail.auth.password` is ignored. |
| config.api.mail.auth.password | string | `""` | The password to authenticate to the smtp host when sending emails. |
| config.api.mail.auth.username | string | `""` | The username to authenticate to the smtp host when sending emails. |
| config.api.mail.enabled | bool | `false` | Enable sending of emails |
| config.api.mail.from | string | `""` | The email address Countly will send emails from. |
| config.api.mail.host | string | `""` | The host of the external SMTP server that Countly should use to send emails. |
| config.api.mail.port | int | `0` | The port used to connect to the smtp host. |
| externalMongodb.auth.database | string | `"countly"` | Name for a custom database to use |
| externalMongodb.hostname | string | `""` | Hostname of the MongoDB database |
| externalMongodb.port | int | `27017` | Port used to connect to MongoDB database |
| extraEnv | list | `[]` | additional environment variables to be added to both api and frontend pods |
| frontend.affinity | object | `{}` | Affinity settings for pod assignment |
| frontend.autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| frontend.autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| frontend.autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| frontend.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| frontend.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| frontend.extraEnv | list | `[]` | additional environment variables to be added to the frontend pods |
| frontend.image.pullPolicy | string | `"Always"` | image pull policy |
| frontend.image.registry | string | `"docker.io"` | image registry |
| frontend.image.repository | string | `"countly/frontend"` | image repository |
| frontend.image.tag | string | `"25.05.4"` | Overrides the image tag |
| frontend.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| frontend.livenessProbe.failureThreshold | int | `6` | Failure threshold for livenessProbe |
| frontend.livenessProbe.initialDelaySeconds | int | `60` | Initial delay seconds for livenessProbe |
| frontend.livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe |
| frontend.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| frontend.livenessProbe.timeoutSeconds | int | `2` | Timeout in seconds for livenessProbe |
| frontend.nodeSelector | object | `{}` | Node labels for pod assignment |
| frontend.podAnnotations | object | `{}` | Annotations to be added to the frontend pods |
| frontend.podSecurityContext | object | `{}` | pod-level security context |
| frontend.priorityClassName | string | `""` | Pod priority class name |
| frontend.readinessProbe.failureThreshold | int | `6` | Failure threshold for readinessProbe |
| frontend.readinessProbe.initialDelaySeconds | int | `60` | Initial delay seconds for readinessProbe |
| frontend.readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| frontend.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| frontend.readinessProbe.timeoutSeconds | int | `2` | Timeout in seconds for readinessProbe |
| frontend.replicaCount | int | `1` | Number of replicas |
| frontend.resources | object | see [values.yaml](./values.yaml) | Resource limits and requests for the controller pods. |
| frontend.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| frontend.securityContext | object | `{}` | container-level security context |
| frontend.selectorLabels | object | `{}` | Additional labels to add to the pod |
| frontend.service.port | int | `3000` | Kubernetes port where service is exposed |
| frontend.service.type | string | `"ClusterIP"` | Kubernetes service type |
| frontend.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| frontend.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| frontend.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| frontend.tolerations | list | `[]` | Toleration labels for pod assignment |
| fullnameOverride | string | `""` | String to fully override `"baserow.fullname"` |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| ingress.enabled | bool | `false` | Enable ingress record generation |
| ingress.hostname | string | `""` | The publicly reachable hostname |
| ingress.pathType | string | `"Prefix"` | Valid values: ImplementationSpecific, Exact, Prefix |
| ingress.tls | list | `[]` | An array with the tls configuration |
| mongodb.architecture | string | `"standalone"` | MongoDB™ architecture. Currently only standalone is supported by this Chart. |
| mongodb.auth.database | string | `"countly"` | Name for a custom database to create |
| mongodb.auth.enabled | bool | `false` | Enable authentication |
| mongodb.enabled | bool | `true` | enable MongoDB™ subchart from Bitnami |
| nameOverride | string | `""` | Provide a name in place of `baserow` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/baserow
```

## Upgrading the Chart

### To 3.0.0

This major updates the Redis subchart to its newest major, 20.6.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-2050) you can find more information about the changes introduced in that version.

Additionally it updates the PostgreSQL subchart to its newest major, 16.4.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1630) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the Redis subchart to its newest major, 18.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/7.2/00-RELEASENOTES) you can find more information about the changes introduced in that version.

Additionally it updates the PostgreSQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1400) you can find more information about the changes introduced in that version.

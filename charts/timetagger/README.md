# timetagger

A Helm Chart for installing Timetagger, an open source time-tracker with an interactive user experience and powerful reporting.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/timetagger
```

## Introduction

This chart bootstraps [Timetagger](https://github.com/almarklein/timetagger) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/timetagger
```

These commands deploy Timetagger on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| auth.existingSecret | string | `""` | Use an existing Secret for basic authentication. Username and password have to be stored as key credentials in the form username:password |
| auth.password | string | `"$2a$08$5R4yIIiiea0DjjwJV1UyBuRkql7Eik9uBiyzwMI5E8d.WtBshWdl2"` | Password for basic authentication. Should be a salted bcrypt hash of the password. Can be generated e.g. using https://timetagger.app/cred. |
| auth.username | string | `"test"` | Username for basic authentication |
| autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| config.log.level | string | `"info"` | log level: debug, info, warn, error |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| extraEnvFrom | list | `[]` | additional environment variables from ConfigMaps or Secrets |
| fullnameOverride | string | `""` | String to fully override `"timetagger.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"ghcr.io"` | image registory |
| image.repository | string | `"almarklein/timetagger"` | image repository |
| image.tag | string | `"v26.1.1"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.failureThreshold | int | `6` | Failure threshold for livenessProbe |
| livenessProbe.initialDelaySeconds | int | `10` | Initial delay seconds for livenessProbe |
| livenessProbe.periodSeconds | int | `5` | Period seconds for livenessProbe |
| livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| livenessProbe.timeoutSeconds | int | `1` | Timeout seconds for livenessProbe |
| nameOverride | string | `""` | Provide a name in place of `timetagger` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| persistence.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| persistence.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| persistence.enabled | bool | `false` | use a PVC to persist data |
| persistence.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| persistence.resources | object | `{}` | represents the minimum and maximum resources the volume should have. |
| persistence.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| podSecurityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | pod-level security context |
| readinessProbe.failureThreshold | int | `6` | Failure threshold for readinessProbe |
| readinessProbe.initialDelaySeconds | int | `10` | Initial delay seconds for readinessProbe |
| readinessProbe.periodSeconds | int | `5` | Period seconds for readinessProbe |
| readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| readinessProbe.timeoutSeconds | int | `1` | Timeout seconds for readinessProbe |
| replicaCount | int | `1` | Number of replicas |
| resources | object | see [values.yaml](./values.yaml) | Resource limits and requests for the controller pods. |
| revisionHistoryLimit | int | `0` | The number of old ReplicaSets to retain |
| route.main.additionalRules | list | `[]` | Additional custom rules that can be added to the route |
| route.main.annotations | object | `{}` | Add annotations to the route |
| route.main.apiVersion | string | `"gateway.networking.k8s.io/v1"` | Set the route apiVersion, e.g. gateway.networking.k8s.io/v1 or gateway.networking.k8s.io/v1alpha2 |
| route.main.enabled | bool | `false` | Enables or disables the route |
| route.main.filters | list | `[]` | Filters define the filters that are applied to requests that match this rule. |
| route.main.hostnames | list | `[]` | Hostnames to be matched |
| route.main.httpsRedirect | bool | `false` | adds a filter for redirecting to https (HTTP 301 Moved Permanently). To redirect HTTP traffic to HTTPS, you need to have a Gateway with both HTTP and HTTPS listeners. Matches and filters do not take effect if enabled. Ref. https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/ |
| route.main.kind | string | `"HTTPRoute"` | Set the route kind Valid options are GRPCRoute, HTTPRoute, TCPRoute, TLSRoute, UDPRoute |
| route.main.labels | object | `{}` | Add labels to the route |
| route.main.matches | list | see [values.yaml](./values.yaml) | define conditions used for matching the rule against incoming HTTP requests. |
| route.main.parentRefs | list | `[]` | Parent references (Gateway) |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":1000}` | container-level security context |
| service.port | int | `8080` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/timetagger
```

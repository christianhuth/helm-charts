# kubevirt-manager

KubeVirt Web UI to manage the lifecycle of Virtual Machines and more

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/kubevirt-manager
```

## Introduction

This chart bootstraps the KubeVirt Web UI called [KubeVirt Manager](https://kubevirt-manager.io) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/kubevirt-manager
```

These commands deploy the KubeVirt Manager on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"kubevirt-manager.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"kubevirtmanager/kubevirt-manager"` | image repository |
| image.tag | string | `"1.5.3"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| ingress.basicAuth.enabled | bool | `false` | enable the configuration of basic authentication with nginx |
| ingress.basicAuth.existingSecret | string | `""` | An existing Secret containing the username and password for basic authentication. Username and password have to be base64 encoded in the form username:password. The Secret needs to contain a key `.htpasswd` with the base64 encoded authentication information. If set `ingress.basicAuth.username` and `ingress.basicAuth.password` will be ignored. |
| ingress.basicAuth.password | string | `"password"` | Password for authentication |
| ingress.basicAuth.username | string | `"admin"` | Username for authentication |
| ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| ingress.enabled | bool | `false` | Enable ingress record generation |
| ingress.hosts | list | see [values.yaml](./values.yaml) | An array with the hosts configuration |
| ingress.tls | list | `[]` | An array with the tls configuration |
| nameOverride | string | `""` | Provide a name in place of `kubevirt-manager` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| prometheus.additionalLabels | object | `{}` | Prometheus ServiceMonitor labels |
| prometheus.enabled | bool | `false` | Enable a Prometheus ServiceMonitor |
| prometheus.interval | string | `"30s"` | Prometheus ServiceMonitor interval |
| prometheus.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| prometheus.namespace | string | `""` | Prometheus ServiceMonitor namespace |
| prometheus.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| prometheus.selector | object | `{}` | Prometheus ServiceMonitor selector |
| prometheus.service.name | string | `""` | Name of the Prometheus Service |
| prometheus.service.namespace | string | `""` | Namespace of the Prometheus Service |
| prometheus.service.port | string | `""` | Port of the Prometheus Service |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the pods. |
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
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":30000,"runAsNonRoot":true,"runAsUser":10000,"seccompProfile":{"type":"RuntimeDefault"}}` | container-level security context |
| service.port | int | `8080` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/kubevirt-manager
```

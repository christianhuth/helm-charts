# dnsbl-exporter

Prometheus compatible exporter to query DNSBLs/RBLs.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/dnsbl-exporter
```

## Introduction

This chart bootstraps the [Prometheus DNS Blacklist Exporter](https://github.com/Luzilla/dnsbl_exporter) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/dnsbl-exporter
```

These commands deploy the DNS Blacklist Exporter on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| deploymentStrategy | object | `{}` | Deployment strategy for the all deployed Deployments |
| dnsblConfig.log.debug | bool | `false` | Enable debug log level |
| dnsblConfig.log.format | string | `"text"` | Define the log format. Valid values are text or json |
| dnsblConfig.rbl.domainBased | bool | `false` |  |
| dnsblConfig.rbl.rbls | list | `[]` | List of Relay Block Lists (RBLs) that should be checked |
| dnsblConfig.resolver | string | `""` | The URL of the DNS resolver that should be used. If unbound is enabled (unbound.enabled) this will be ignored |
| dnsblConfig.targets | list | `[]` | List of Targets that should be checked for in the RBLs |
| extraEnv | list | `[]` | Additional environment variables that will be added to the deployment |
| fullnameOverride | string | `""` | String to fully override `"dnsbl-exporter.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"ghcr.io"` | image registry |
| image.repository | string | `"luzilla/dnsbl_exporter"` | image repository |
| image.tag | string | `"v0.7.0-rc3"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.enabled | bool | `true` | Enable the livenessProbe |
| livenessProbe.failureThreshold | int | `5` | Failure threshold for livenessProbe |
| livenessProbe.initialDelaySeconds | int | `30` | Initial delay seconds for livenessProbe |
| livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe |
| livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| livenessProbe.timeoutSeconds | int | `10` | Timeout in seconds for livenessProbe |
| nameOverride | string | `""` | Provide a name in place of `dnsbl-exporter` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podSecurityContext | object | `{}` | pod-level security context |
| readinessProbe.enabled | bool | `true` | Enable the readinessProbe |
| readinessProbe.failureThreshold | int | `5` | Failure threshold for readinessProbe |
| readinessProbe.initialDelaySeconds | int | `30` | Initial delay seconds for readinessProbe |
| readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| readinessProbe.timeoutSeconds | int | `10` | Timeout in seconds for readinessProbe |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource limits and requests for the dnsbl exporter pods. |
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
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534}` | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.additionalLabels | object | `{}` | Prometheus ServiceMonitor labels |
| serviceMonitor.enabled | bool | `false` | Enable a prometheus ServiceMonitor |
| serviceMonitor.interval | string | `"60s"` | Prometheus ServiceMonitor interval |
| serviceMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.namespace | string | `""` | Prometheus ServiceMonitor namespace |
| serviceMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.scrapeTimeout | string | `"20s"` | How long until a scrape request times out. It cannot be greater than the scrape interval |
| serviceMonitor.selector | object | `{}` | Prometheus ServiceMonitor selector |
| tolerations | list | `[]` | Toleration labels for pod assignment |
| unbound.enabled | bool | `true` | Enable the integrated unbound DNS resolver |
| unbound.image.pullPolicy | string | `"Always"` | image pull policy for the unbound image |
| unbound.image.registry | string | `"ghcr.io"` | image registry for the unbound image |
| unbound.image.repository | string | `"luzilla/unbound"` | image repository for the unbound image |
| unbound.image.tag | string | `"v0.7.0-rc3"` | Overrides the image tag for the unbound image |
| unbound.livenessProbe.enabled | bool | `true` | Enable the livenessProbe of unbound |
| unbound.livenessProbe.failureThreshold | int | `5` | Failure threshold for livenessProbe of unbound |
| unbound.livenessProbe.initialDelaySeconds | int | `10` | Initial delay seconds for livenessProbe of unbound |
| unbound.livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe of unbound |
| unbound.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe of unbound |
| unbound.livenessProbe.timeoutSeconds | int | `2` | Timeout in seconds for livenessProbe of unbound |
| unbound.readinessProbe.enabled | bool | `true` | Enable the readinessProbe of unbound |
| unbound.readinessProbe.failureThreshold | int | `5` | Failure threshold for readinessProbe of unbound |
| unbound.readinessProbe.initialDelaySeconds | int | `10` | Initial delay seconds for readinessProbe of unbound |
| unbound.readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe of unbound |
| unbound.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe of unbound |
| unbound.readinessProbe.timeoutSeconds | int | `2` | Timeout in seconds for readinessProbe of unbound |
| unbound.resources | object | `{"limits":{"cpu":"200m","memory":"200Mi"},"requests":{"cpu":"100m","memory":"32Mi"}}` | Resource limits and requests for the unbound pods. |
| unbound.securityContext | object | `{"capabilities":{"add":["NET_ADMIN"],"drop":["ALL"]},"readOnlyRootFilesystem":false,"runAsGroup":101,"runAsNonRoot":true,"runAsUser":100}` | container-level security context for the unbound DNS resolver |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/dnsbl-exporter
```

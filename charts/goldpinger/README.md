# goldpinger

Debugging tool for Kubernetes which tests and displays connectivity between nodes in the cluster.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/goldpinger
```

## Introduction

This chart bootstraps [Goldpinger](https://github.com/bloomberg/goldpinger) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/goldpinger
```

These commands deploy Goldpinger on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"goldpinger.fullname"` |
| goldpinger.displayNodename | bool | `true` | Display nodename other than podname in UI |
| goldpinger.externalTargets.dns.targets | string | `""` | A space delimited list of hosts to attempt dns resolve on |
| goldpinger.externalTargets.dns.timeout | string | `"500ms"` | The timeout for a dns check on the provided dns-targets |
| goldpinger.externalTargets.http.targets | string | `""` | A space delimited list of external targets (<http://url> or <https://url>) to attempt an HTTP{S} check on. A 200 HTTP code is considered successful. |
| goldpinger.externalTargets.http.timeout | string | `"500ms"` | The timeout for a http check on the provided http-targets |
| goldpinger.externalTargets.tcp.targets | string | `""` | A space delimited list of external targets (<host:port> or <ip:port>) to attempt a TCP check on |
| goldpinger.externalTargets.tcp.timeout | string | `"500ms"` | The timeout for a tcp check on the provided tcp-targets |
| goldpinger.internalPeers.pingNumber | int | `0` | Number of peers to ping. A value of 0 indicates all peers should be pinged |
| goldpinger.internalPeers.timeouts.check | string | `"1000ms"` | The timeout for a check call to other goldpinger pods |
| goldpinger.internalPeers.timeouts.checkAll | string | `"5000ms"` | The timeout for a check-all call to other goldpinger pods |
| goldpinger.internalPeers.timeouts.ping | string | `"300ms"` | The timeout for a ping call to other goldpinger pods |
| goldpinger.ipVersions | string | `"4"` | The space delimited list of IP versions to use. Possible values are 4 and 6 |
| goldpinger.jitterFactor | float | `0.05` | The amount of jitter to add while pinging clients |
| goldpinger.port | int | `8080` | Port where Goldpinger will run |
| goldpinger.refreshInterval | int | `30` | If > 0, will create a thread and collect stats every n seconds |
| goldpinger.zapConfig | string | `"{\n  \"level\": \"info\",\n  \"encoding\": \"json\",\n  \"outputPaths\": [\n      \"stdout\"\n  ],\n  \"errorOutputPaths\": [\n      \"stderr\"\n  ],\n  \"initialFields\": {\n  },\n  \"encoderConfig\": {\n      \"messageKey\": \"message\",\n      \"levelKey\": \"level\",\n      \"levelEncoder\": \"lowercase\",\n      \"timeKey\": \"ts\",\n      \"timeEncoder\": \"ISO8601\",\n      \"callerKey\": \"caller\",\n      \"callerEncoder\": \"Short\"\n  }\n}\n"` |  |
| grafanaDashboard.enabled | bool | `false` | Enable the creation of a Grafana Dashboard |
| grafanaDashboard.folder | string | `""` | folder assignment for dashboard |
| grafanaDashboard.grafanaCom.id | int | `10949` | ID of the dashboard from the Grafana marketplace |
| grafanaDashboard.grafanaCom.revision | int | `1` | Revision of the dashboard from the Grafana marketplace |
| grafanaDashboard.instanceSelector | object | `{}` | Selects Grafana instances for import |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"bloomberg/goldpinger"` | image repository |
| image.tag | string | `"3.10.3"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.failureThreshold | int | `3` | Failure threshold for livenessProbe |
| livenessProbe.initialDelaySeconds | int | `20` | Initial delay seconds for livenessProbe |
| livenessProbe.periodSeconds | int | `5` | Period seconds for livenessProbe |
| livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| livenessProbe.timeoutSeconds | int | `5` | Timeout seconds for livenessProbe |
| nameOverride | string | `""` | Provide a name in place of `goldpinger` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podSecurityContext | object | `{"fsGroup":2000,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | pod-level security context |
| prometheusRule.enabled | bool | `false` | Enable a PrometheusRule |
| prometheusRule.rules | list | `[{"alert":"goldpinger_nodes_unhealthy","annotations":{"description":"Goldpinger instance {{ \"{{ $labels.goldpinger_instance }}\" }} has been reporting unhealthy nodes for at least 5 minutes.\n","summary":"Instance {{ \"{{ $labels.instance }}\" }} down"},"expr":"sum(goldpinger_nodes_health_total{job=\"{{ template \"goldpinger.fullname\" . }}\", status=\"unhealthy\"})\nBY (instance, goldpinger_instance) > 0\n","for":"5m","labels":{"severity":"warning"}}]` | List of rules |
| rbac.clusterscoped | bool | `true` | Create clusterscoped resources |
| rbac.create | bool | `true` | Create RBAC resources |
| readinessProbe.failureThreshold | int | `3` | Failure threshold for readinessProbe |
| readinessProbe.initialDelaySeconds | int | `20` | Initial delay seconds for readinessProbe |
| readinessProbe.periodSeconds | int | `5` | Period seconds for readinessProbe |
| readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| readinessProbe.timeoutSeconds | int | `5` | Timeout seconds for readinessProbe |
| resources | object | `{"limits":{"memory":"80Mi"},"requests":{"cpu":"1m","memory":"40Mi"}}` | Resource limits and requests for the headwind pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
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
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true}` | container-level security context |
| service.port | int | `8080` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.additionalLabels | object | `{}` | Prometheus ServiceMonitor labels |
| serviceMonitor.enabled | bool | `false` | Enable a Prometheus ServiceMonitor |
| serviceMonitor.interval | string | `"30s"` | Prometheus ServiceMonitor interval |
| serviceMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.namespace | string | `""` | Prometheus ServiceMonitor namespace |
| serviceMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.selector | object | `{}` | Prometheus ServiceMonitor selector |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/goldpinger
```

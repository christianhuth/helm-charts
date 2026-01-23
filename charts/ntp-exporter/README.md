# ntp-exporter

Prometheus exporter that checks the drift of Kubernetes node's clock against a given NTP server or servers

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/ntp-exporter
```

## Introduction

This chart bootstraps a [NTP-Exporter for Prometheus](https://github.com/sapcc/ntp_exporter) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+
- Prometheus

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/ntp-exporter
```

These commands deploy the NTP-Exporter on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| fullnameOverride | string | `""` | String to fully override `"ntp-exporter.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"ghcr.io"` | image registry |
| image.repository | string | `"sapcc/ntp_exporter"` | image repository |
| image.tag | string | `"v2.9.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `ntp-exporter` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| ntp.config.highDriftThreshold | string | `"10ms"` | High drift threshold |
| ntp.config.measurementDuration | string | `"30s"` | Duration of measurements in case of high (>10ms) drift |
| ntp.config.protocolVersion | string | `"4"` | NTP protocol version to use |
| ntp.exporter.path | string | `"/metrics"` | Path under which to expose metrics |
| ntp.exporter.port | int | `9559` | The port the exporter will listen on |
| ntp.server | string | `""` | NTP server to query for time |
| ntp.source | string | `"cli"` | source of information about ntp server. Valid options are cli and http |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podMonitor.additionalLabels | object | `{}` | Prometheus PodMonitor labels |
| podMonitor.enabled | bool | `false` | Enable a prometheus PodMonitor |
| podMonitor.interval | string | `"30s"` | Prometheus PodMonitor interval |
| podMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| podMonitor.namespace | string | `""` | Prometheus PodMonitor namespace |
| podMonitor.relabelings | list | see [values.yaml](./values.yaml) | Prometheus [RelabelConfigs] to apply to samples before scraping |
| podMonitor.selector | object | `{}` | Prometheus PodMonitor selector |
| podSecurityContext | object | see [values.yaml](./values.yaml) | pod-level security context |
| prometheusRule.defaultRules.absence.enabled | bool | `true` | Enable the rule that alerts if no metrics are scraped from ntp-exporter |
| prometheusRule.defaultRules.absence.rule | object | see [values.yaml](./values.yaml) for definition | The rule definition for clock drift alerting |
| prometheusRule.defaultRules.clockDrift.enabled | bool | `true` | Enable the rule that alerts on high clock drift |
| prometheusRule.defaultRules.clockDrift.rule | object | see [values.yaml](./values.yaml) for definition | The rule definition for clock drift alerting |
| prometheusRule.defaultRules.enabled | bool | `true` | Enable the default rules that alert on clock drift and metrics absence |
| prometheusRule.enabled | bool | `false` | Enable a PrometheusRule |
| prometheusRule.rules | list | `[]` | List of additional rules |
| resources | object | see [values.yaml](./values.yaml) | Resource limits and requests for the headwind pods. |
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
| securityContext | object | see [values.yaml](./values.yaml) | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | see [values.yaml](./values.yaml) | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/ntp-exporter
```

# dns-exporter

A multi-target Prometheus exporter with an exclusive focus on DNS monitoring

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/dns-exporter
```

## Introduction

This chart bootstraps the [Prometheus DNS-Exporter](https://github.com/tykling/dns_exporter) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/dns-exporter
```

These commands deploy the DNS-Exporter on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

### Defining Scrape Targets

This Helm Charts allows you to create two ServiceMonitors:

- One for the metrics of the DNS-Exporter itself
- One for the DNS metrics of the targets

The Scrape Targets can be configured using `.serviceMonitor.targetsMonitor.targets`.
For each Scrape Target we need to define at least the DNS server and ip family (`ipv4` or `ipv6`).
You also have to define the family if you are scraping DNS records unrelated to the ip address type like NS.

A basic example would look like this:

```yaml
serviceMonitor:
  targetsMonitor:
    targets:
      - query_name:
          - christianhuth.de
        family:
          - ipv4
        server:
          - dns.google
```

While this looks like you can define multiple values for the attributes, this is sadly not supported by the DNS-Exporter.
Defining multiple values will result in only the first value taking affect.

There are more attributes you can define for each target.
A complete list can be found [https://dns-exporter.readthedocs.io/latest/configuration.html#settings](in the official documentation).

Instead of defining all the attributes (like family, server, ...) for each target again, you can use pre-defined modules or define your own ones using .Values.serviceMonitor.modules.

```yaml
serviceMonitor:
  targetsMonitor:
    modules:
      google_udp:
        family: ipv4
        protocol: udp
        server: dns.google
        query_type: NS
    targets:
      - query_name:
          - christianhuth.de
        module:
          - google_udp
```

This will result in a query for the NS records of christianhuth.de using the DNS server dns.google with the UDP protocol.
In this example, the ip family is only defined, because DNS-Exporter won't work without defining one.

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
| extraEnv | list | `[]` | Additional environment variables that will be added to the deployment |
| fullnameOverride | string | `""` | String to fully override `"netcupscp-exporter.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"tykling/dns_exporter"` | image repository |
| image.tag | string | `"v1.1.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `netcupscp-exporter` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podSecurityContext | object | `{}` | pod-level security context |
| priorityClassName | string | `""` | Priority class name ref: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the headwind pods. |
| revisionHistoryLimit | int | `0` | The number of old ReplicaSets to retain |
| securityContext | object | `{}` | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor.enabled | bool | `false` | Enable a prometheus ServiceMonitor |
| serviceMonitor.modules | object | `{}` | Define modules that can be used inside your targets |
| serviceMonitor.selfMonitor.additionalLabels | object | `{}` | Prometheus ServiceMonitor labels |
| serviceMonitor.selfMonitor.enabled | bool | `true` | Enable a prometheus ServiceMonitor to monitor the DNS Exporter |
| serviceMonitor.selfMonitor.interval | string | `"30s"` | Prometheus ServiceMonitor interval |
| serviceMonitor.selfMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.selfMonitor.namespace | string | `""` | Prometheus ServiceMonitor namespace |
| serviceMonitor.selfMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.selfMonitor.selector | object | `{}` | Prometheus ServiceMonitor selector |
| serviceMonitor.targetsMonitor.additionalLabels | object | `{}` | Prometheus ServiceMonitor labels |
| serviceMonitor.targetsMonitor.enabled | bool | `true` | Enable a prometheus ServiceMonitor to monitor the Targets of the DNS Exporter |
| serviceMonitor.targetsMonitor.interval | string | `"30s"` | Prometheus ServiceMonitor interval |
| serviceMonitor.targetsMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.targetsMonitor.namespace | string | `""` | Prometheus ServiceMonitor namespace |
| serviceMonitor.targetsMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.targetsMonitor.selector | object | `{}` | Prometheus ServiceMonitor selector |
| serviceMonitor.targetsMonitor.targets | list | `[]` | Targets that should be scraped by the DNS-Exporter |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/dns-exporter
```

# promlens

PromLens is a tool that makes learning and using PromQL easier and more productive

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/promlens
```

## Introduction

This chart bootstraps [Promlens](https://github.com/prometheus/promlens) - The query builder, analyzer, and explainer for PromQL using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/promlens
```

These commands deploy Promlens on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| config.grafana.apiToken | string | `""` | The auth token to pass to the Grafana API, see https://grafana.com/docs/grafana/latest/http_api/auth/ |
| config.grafana.defaultDatasourceId | string | `""` | The default Grafana datasource ID to use (overrides Grafana's own default). |
| config.grafana.enabled | bool | `false` | Enable integration with Grafana |
| config.grafana.existingSecret | string | `""` | An existing secret containing the auth token, key needs to be api-token |
| config.grafana.url | string | `""` | The URL of your Grafana installation |
| config.log.format | string | `"json"` | Output format of log messages. One of: [logfmt, json] |
| config.log.level | string | `"info"` | Only log messages with the given severity or above. One of: [debug, info, warn, error] |
| config.sharedLinks.gcs.bucket | string | `""` | Name of the GCS bucket for storing shared links |
| config.sharedLinks.gcs.enabled | bool | `false` | Enable Link Sharing via Google Storage Bucket |
| config.sharedLinks.gcs.existingSecret | string | `""` | An existing secret containing the credentials for the storage-account as json, key needs to be gcs-cred.json |
| config.sharedLinks.gcs.storageAccount | string | `""` | Google Cloud Storage Account key |
| config.sharedLinks.sql.createTables | bool | `true` | Whether to automatically create the required tables when using a SQL database for shared links. |
| config.sharedLinks.sql.driver | string | `"sqlite"` | The SQL driver to use for storing shared links in a SQL database. Supported values: [mysql, sqlite]. |
| config.sharedLinks.sql.dsn | string | `"/tmp/promlens-links.db"` | SQL Data Source Name when using a SQL database to shared links (see https://github.com/go-sql-driver/mysql#dsn-data-source-name) for MySQL, https://github.com/glebarez/go-sqlite#example for SQLite) |
| config.sharedLinks.sql.enabled | bool | `false` | Enable Link Sharing via SQL database |
| config.sharedLinks.sql.existingSecret | string | `""` | An existing secret containing the dsn for the link storage backend, key needs to be dsn |
| config.sharedLinks.sql.retention | string | `"0"` | The maximum retention time for shared links when using a SQL database (e.g. '10m', '12h'). Set to 0 for infinite retention. |
| config.web.defaultPrometheusUrl | string | `""` | The default Prometheus URL to load PromLens with. |
| config.web.externalUrl | string | `""` | The URL under which PromLens is externally reachable (for example, if PromLens is served via a reverse proxy). Used for generating relative and absolute links back to PromLens itself. If the URL has a path portion, it will be used to prefix all HTTP endpoints served by PromLens. If omitted, relevant URL components will be derived automatically. |
| config.web.routePrefix | string | `""` |  |
| fullnameOverride | string | `""` | String to fully override `"promlens.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"prom/promlens"` | image repository |
| image.tag | string | `"v0.3.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` | Annotations to add to the ingress |
| ingress.className | string | `""` | Ingress class name |
| ingress.enabled | bool | `false` | Enable ingress |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `promlens` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | Pod-level security context |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the pods. |
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
helm install my-release -f values.yaml christianhuth/promlens
```

# umami

Umami is a simple, fast, privacy-focused alternative to Google Analytics.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/umami
```

## Introduction

Umami is a simple, fast, privacy-focused alternative to Google Analytics.

This chart bootstraps [Umami](https://github.com/umami-software/umami) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/umami
```

These commands deploy Umami on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| database.databaseUrlKey | string | `""` | Key in the existing secret containing the database url |
| database.existingSecret | string | `""` | use an existing secret containing the database url. If none given, we will generate the database url by using the other values. The password for the database has to be set using `.Values.postgresql.auth.password`, `.Values.mysql.auth.password` or `.Values.externalDatabase.auth.password`. |
| externalDatabase.auth.database | string | `"mychart"` | Name of the database to use |
| externalDatabase.auth.password | string | `"mychart"` | Password to use |
| externalDatabase.auth.username | string | `"mychart"` | Name of the user to use |
| externalDatabase.hostname | string | `""` | Hostname of the database |
| externalDatabase.port | int | `5432` | Port used to connect to database |
| externalDatabase.type | string | `"postgresql"` | Type of database |
| extraEnv | list | `[]` | additional environment variables to be added to the pods. See https://umami.is/docs/environment-variables for a complete list of available variables. Most variables can be set under umami as well. |
| fullnameOverride | string | `""` | String to fully override `"umami.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"ghcr.io"` | image registry |
| image.repository | string | `"umami-software/umami"` | image repository |
| image.tag | string | `"postgresql-v2.20.1"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| ingress.enabled | bool | `false` | Enable ingress record generation |
| ingress.hosts | list | see [values.yaml](./values.yaml) | An array with hosts and paths |
| ingress.tls | list | `[]` | An array with the tls configuration |
| initContainers | object | `{}` | define additional init containers |
| mysql.auth.database | string | `"mychart"` | Name for a custom database to create |
| mysql.auth.password | string | `"mychart"` | Password for the custom user to create |
| mysql.auth.username | string | `"mychart"` | Name for a custom user to create |
| mysql.enabled | bool | `false` | enable MySQL™ subchart from Bitnami |
| nameOverride | string | `""` | Provide a name in place of `umami` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podLabels | object | `{}` | Labels to be added to pods |
| podSecurityContext | object | `{}` | pod-level security context |
| postgresql.auth.database | string | `"mychart"` | Name for a custom database to create |
| postgresql.auth.password | string | `"mychart"` | Password for the custom user to create |
| postgresql.auth.username | string | `"mychart"` | Name for a custom user to create |
| postgresql.enabled | bool | `true` | enable PostgreSQL™ subchart from Bitnami |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the controller pods. |
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
| securityContext | object | `{"runAsGroup":65533,"runAsNonRoot":true,"runAsUser":1001}` | container-level security context |
| service.port | int | `3000` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |
| umami.appSecret.existingSecret | string | `""` | Name of an existing secret containing the app secret under the key app-secret. |
| umami.appSecret.secret | string | `""` | A random string used to generate unique values. |
| umami.clientIpHeader | string | `""` | HTTP header to check for the client's IP address. This is useful when you're behind a proxy that uses non-standard headers. |
| umami.cloudMode | string | `"0"` | Disables users, teams, and websites settings page. |
| umami.collectApiEndpoint | string | `""` | Allows you to send metrics to a location different than the default `/api/send`. This is to help you avoid some ad-blockers. |
| umami.corsMaxAge | string | `"86400"` | How many seconds a CORS preflight should last. Default is 24 hours. |
| umami.customScript.data | string | `""` | The custom script |
| umami.customScript.enabled | bool | `false` | Create and mount a ConfigMap with a custom script |
| umami.customScript.key | string | `"script.js"` | Key in the ConfigMap |
| umami.customScript.mountPath | string | `"/app/public/script.js"` | The path to mount the custom script to |
| umami.debug | string | `""` | Console logging for specific areas of the application. Values include `umami:auth`, `umami:clickhouse`, `umami:kafka`, `umami:middleware`, and `umami:prisma`. |
| umami.disableBotCheck | string | `"1"` | By default bots are excluded from statistics. This disables checking for bots. |
| umami.disableLogin | string | `"1"` | Disables the login page for the application |
| umami.disableTelemetry | string | `"1"` | Umami collects completely anonymous telemetry data in order help improve the application. You can choose to disable this if you don't want to participate. |
| umami.disableUpdates | string | `"1"` | Disables the check for new versions of Umami |
| umami.enableTestConsole | string | `"1"` | Enables the internal test page, {host}/console. Admin access is required. Users can manually fire pageviews and events to their websites. |
| umami.forceSSL | string | `"1"` | This will redirect all requests from http to https in the Umami application. Note, this does not apply to the tracking script. |
| umami.hostname | string | `"0.0.0.0"` | hostname under which Umami will be reached |
| umami.ignoreHostname | string | `""` | This will do a DNS lookup on a hostname and the resulting IP address will be ignored. This can be a comma delimited list of hostnames. |
| umami.ignoredIpAddresses | string | `""` | You can provide a comma-delimited list of IP address to exclude from data collection. |
| umami.logQuery | string | `"1"` | If you are running in development mode, this will log database queries to the console for debugging. |
| umami.migration.v1v2.enabled | bool | `false` | enable a job that migrates database structure from v1 to v2 |
| umami.removeDisableLoginEnv | bool | `true` | setting this to true removes the environment variable DISABLE_LOGIN defined in `umami.disableLogin` from the deployment as this caused errors in some setups |
| umami.removeTrailingSlash | string | `"1"` | Removes the trailing slash from all incoming urls. |
| umami.trackerScriptName | string | `"umami"` | Allows you to assign a custom name to the tracker script different from the default umami. This is to help you avoid some ad-blockers. |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/umami
```

## Upgrading the Chart

### To 7.0.0

This major updates the PostgreSQL subchart to its newest major, 18.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#upgrading) you can find more information about the changes introduced in that version.

### To 6.0.0

This major updates the MySQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1400) you can find more information about the changes introduced in that version.

### To 5.0.0

This major updates the MySQL subchart to its newest major, 13.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/mysql#to-1300) you can find more information about the changes introduced in that version.

### To 4.0.0

This major updates the PostgreSQL subchart to its newest major, 16.3.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1630) you can find more information about the changes introduced in that version.

This major also updates the MySQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1200) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the PostgreSQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1400) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the Docker Image to its newest major, 2.0.0. [Here](https://github.com/umami-software/umami/releases/tag/v2.0.0) you can find more information about the changes introduced in that version.

To upgrade from a previous version of the Helm Chart make sure to activate the database migration job with `umami.migration.v1v2.enabled`.

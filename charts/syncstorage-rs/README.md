# syncstorage-rs

A Helm chart for deploying Mozilla's Firefox Sync Storage server to Kubernetes

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/syncstorage-rs
```

## Introduction

This chart bootstraps the [Mozilla Firefox Sync Storage server](https://github.com/mozilla-services/syncstorage-rs) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/syncstorage-rs
```

These commands deploy the Mozilla Firefox Sync Storage server on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"syncstorage-rs.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"ghcr.io"` | image registry |
| image.repository | string | `"porelli/firefox-sync"` | image repository |
| image.tag | string | `"syncstorage-rs-mysql-0.18.2"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.enabled | bool | `true` | Enable the livenessProbe |
| livenessProbe.failureThreshold | int | `6` | Failure threshold for livenessProbe |
| livenessProbe.initialDelaySeconds | int | `10` | Initial delay seconds for livenessProbe |
| livenessProbe.periodSeconds | int | `10` | Period seconds for livenessProbe |
| livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| livenessProbe.timeoutSeconds | int | `2` | Timeout in seconds for livenessProbe |
| nameOverride | string | `""` | Provide a name in place of `syncstorage-rs` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| readinessProbe.enabled | bool | `true` | Enable the readinessProbe |
| readinessProbe.failureThreshold | int | `6` | Failure threshold for readinessProbe |
| readinessProbe.initialDelaySeconds | int | `10` | Initial delay seconds for readinessProbe |
| readinessProbe.periodSeconds | int | `10` | Period seconds for readinessProbe |
| readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| readinessProbe.timeoutSeconds | int | `2` | Timeout in seconds for readinessProbe |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the controller pods. |
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
| securityContext | object | `{}` | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| syncserver-db.auth.database | string | `"syncserver"` | The database name to be used when using the integrated MariaDB database. |
| syncserver-db.auth.password | string | `"syncserver"` | The password credential to be used when using the integrated MariaDB database. |
| syncserver-db.auth.username | string | `"syncserver"` | The username credential to be used when using the integrated MariaDB database. |
| syncserver-db.enabled | bool | `true` | enable integrated MariaDB™ subchart from Bitnami for the Syncserver database |
| syncstorage.config.host | string | `"0.0.0.0"` | host to listen for connections |
| syncstorage.config.logLevel | string | `"info"` | The minimum Rust error logging level. Valid values: debug, info, warn, error. |
| syncstorage.config.port | int | `8000` | connection port |
| syncstorage.config.runTokenserverDbMigrations | bool | `true` | run migrations for the tokenserver database |
| syncstorage.masterKey.existingSecret | string | `""` | Use existing secret for the sync master key (`syncstorage.masterKey.value` will be ignored and picked up from this secret). The secret has to contain the key `master-key`. |
| syncstorage.masterKey.value | string | `""` | The sync master key value |
| syncstorage.syncserver-db.auth.database | string | `""` | The database name to be used when using an external database for the Syncserver. Will be ignored when you activate the integrated database with syncserver-db.enabled. |
| syncstorage.syncserver-db.auth.existingSecret | string | `""` | Use existing secret for connection url. The secret has to contain the key `database-url`. |
| syncstorage.syncserver-db.auth.password | string | `""` | The password credential to be used when using an external database driver. Will be ignored when you activate the integrated database with syncserver-db.enabled. |
| syncstorage.syncserver-db.auth.username | string | `""` | The username credential to be used when using an external database driver. Will be ignored when you activate the integrated database with syncserver-db.enabled. |
| syncstorage.syncserver-db.host | string | `""` | The host name of the database server when using an external database driver. Will be ignored when you activate the integrated database with syncserver-db.enabled. |
| syncstorage.syncserver-db.port | int | `3306` | The port in which the database service is running when using an external database driver. Will be ignored when you activate the integrated database with syncserver-db.enabled. |
| syncstorage.tokenserver-db-lock.config.maxUsers | int | `1` | maximum number of users that are allowed to user your server |
| syncstorage.tokenserver-db-lock.enabled | bool | `false` | enable an init container that locks the tokenserver db from accepting new users if the maximum number of users are registered already |
| syncstorage.tokenserver-db-lock.image.pullPolicy | string | `"Always"` | image pull policy |
| syncstorage.tokenserver-db-lock.image.registry | string | `"ghcr.io"` | image registry |
| syncstorage.tokenserver-db-lock.image.repository | string | `"porelli/firefox-sync"` | image repository |
| syncstorage.tokenserver-db-lock.image.tag | string | `"syncstorage-rs-mysql-init-0.18.2"` | Overrides the image tag |
| syncstorage.tokenserver-db.auth.database | string | `""` | The database name to be used when using an external database for the Tokenserver. Will be ignored when you activate the integrated database with tokenserver-db.enabled. |
| syncstorage.tokenserver-db.auth.existingSecret | string | `""` | Use existing secret for connection url. The secret has to contain the keys `database-password` and `database-url`. |
| syncstorage.tokenserver-db.auth.password | string | `""` | The password credential to be used when using an external database driver. Will be ignored when you activate the integrated database with tokenserver-db.enabled. |
| syncstorage.tokenserver-db.auth.username | string | `""` | The username credential to be used when using an external database driver. Will be ignored when you activate the integrated database with tokenserver-db.enabled. |
| syncstorage.tokenserver-db.host | string | `""` | The host name of the database server when using an external database driver. Will be ignored when you activate the integrated database with tokenserver-db.enabled. |
| syncstorage.tokenserver-db.port | int | `3306` | The port in which the database service is running when using an external database driver. Will be ignored when you activate the integrated database with tokenserver-db.enabled. |
| tokenserver-db.auth.database | string | `"tokenserver"` | The database name to be used when using the integrated MariaDB database. |
| tokenserver-db.auth.password | string | `"tokenserver"` | The password credential to be used when using the integrated MariaDB database. |
| tokenserver-db.auth.username | string | `"tokenserver"` | The username credential to be used when using the integrated MariaDB database. |
| tokenserver-db.enabled | bool | `true` | enable integrated MariaDB™ subchart from Bitnami for the Tokenserver database |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/syncstorage-rs
```

## Upgrading the Chart

### 4.0.0

This major updates the MariaDB subchart to its newest major, 24.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the MariaDB subchart to its newest major, 22.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the MariaDB subchart to its newest major, 21.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

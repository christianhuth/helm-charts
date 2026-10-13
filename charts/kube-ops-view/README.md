# kube-ops-view

A Helm chart for bootstrapping kube-ops-view.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/kube-ops-view
```

## Introduction

Kubernetes Operational View - read-only system dashboard for multiple K8s clusters

This chart bootstraps the [Kubernetes Operational View](https://codeberg.org/hjacobs/kube-ops-view) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/kube-ops-view
```

These commands deploy kube-ops-view on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuring Redis

kube-ops-view only needs a Redis-compatible server for pub/sub and job locking if it runs with more than one replica (`replicaCount`). Otherwise it keeps its state in memory.

### Bundled Valkey

```yaml
replicaCount: 2

valkey:
  enabled: true
```

This deploys a standalone [Valkey](https://valkey.io) instance with the official chart [valkey/valkey](https://github.com/valkey-io/valkey-helm/tree/main/valkey). No operator or other prerequisite is required. All its settings are available under `valkey.*`, see the [values](https://github.com/valkey-io/valkey-helm/tree/main/valkey#values) of the upstream chart.

### Bundled Valkey with authentication

Create a Secret containing the password of the user `default`, which kube-ops-view authenticates as:

```console
kubectl create secret generic kube-ops-view-valkey \
  --from-literal=password='<password>'
```

Reference the Secret in your values:

```yaml
valkey:
  enabled: true
  auth:
    enabled: true
    usersExistingSecret: kube-ops-view-valkey
    aclUsers:
      default:
        permissions: "~* &* +@all"
        passwordKey: password
```

kube-ops-view receives the password as part of its Redis URL, so it must only contain URL-safe characters (`A-Z`, `a-z`, `0-9`, `-`, `.`, `_`, `~`). Note that kube-ops-view logs the Redis URL including the password on startup.

### External Redis or Valkey

```yaml
replicaCount: 2

externalRedis:
  hostname: redis.example.com
  port: 6379
  existingSecret: kube-ops-view-redis
  existingSecretPasswordKey: password
```

Leave `existingSecret` and `password` empty if the server does not require authentication, and set `username` if kube-ops-view should authenticate as an ACL user other than `default`.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| args | list | `[]` |  |
| deploymentStrategy | object | `{}` | Update strategy for the deployment |
| externalRedis.existingSecret | string | `""` | Name of an existing Secret containing the password. The password must only contain URL-safe characters. |
| externalRedis.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalRedis.hostname | string | `""` | Hostname of an external Redis or Valkey server. Used if `valkey.enabled` is false. |
| externalRedis.password | string | `""` | Password of the user. Ignored if `externalRedis.existingSecret` is set. Must only contain URL-safe characters. |
| externalRedis.port | int | `6379` | Port of the external server |
| externalRedis.username | string | `""` | Name of the user. Leave empty to authenticate with a password only. |
| fullnameOverride | string | `""` | String to fully override `"kube-ops-view.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"hjacobs/kube-ops-view"` | image repository |
| image.tag | string | `"23.5.0"` |  |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `kube-ops-view` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
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
| route.main.timeouts | object | `{}` | defines the timeouts that can be configured for an HTTP request |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":1000}` | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |
| valkey.auth.aclUsers | object | `{}` | ACL users. kube-ops-view authenticates as the user `default`. |
| valkey.auth.enabled | bool | `false` | Enable password authentication. Requires the user `default` in `valkey.auth.aclUsers`. Note that kube-ops-view logs the Redis URL including the password on startup. |
| valkey.auth.usersExistingSecret | string | `""` | Name of an existing Secret containing the passwords of the users (key `<user>` or `aclUsers.<user>.passwordKey`) |
| valkey.enabled | bool | `false` | Enable a Valkey instance (official chart valkey/valkey) used by kube-ops-view for pub/sub and job locking. Required if `replicaCount` is greater than 1. |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/kube-ops-view
```

## Upgrading the Chart

### To 9.0.0

This major replaces the Bitnami Redis subchart with the official Valkey chart [valkey/valkey](https://github.com/valkey-io/valkey-helm/tree/main/valkey). Valkey is a fork of Redis and fully compatible with kube-ops-view. The values changed as follows:

- `redis.*` is replaced by `valkey.*` with the values of the upstream chart, e.g. `redis.enabled` is now `valkey.enabled`
- an external server can be configured with `externalRedis.*` instead of passing `--redis-url` via `args`

kube-ops-view only uses Redis for pub/sub and job locking, so no data has to be migrated. The new Valkey instance starts empty.

### To 7.0.0

This major updates the Redis subchart to its newest major, 24.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) you can find more information about the changes introduced in that version.

### To 6.0.0

This major updates the Redis subchart to its newest major, 22.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/8.2/00-RELEASENOTES) you can find more information about the changes introduced in that version.

### To 5.0.0

This major updates the Redis subchart to its newest major, 21.2.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/8.0/00-RELEASENOTES) you can find more information about the changes introduced in that version.

### 4.0.0

This major updates the Redis subchart to its newest major, 20.6.4. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-2000) you can find more information about the changes introduced in that version.

### 3.0.0

This major updates the redis subchart to its newest major, 18.0.4. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1800) you can find more information about the changes introduced in that version.

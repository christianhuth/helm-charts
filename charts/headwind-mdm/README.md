# headwind-mdm

Headwind MDM - an open source mobile device management software for Android

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/headwind-mdm
```

## Introduction

Headwind MDM is a Mobile device management (MDM) system for corporate Android devices, remote access to Android phones and tablets.

This chart bootstraps the [Headwind MDM](https://github.com/h-mdm) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/headwind-mdm
```

These commands deploy Headwind MDM on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| externalPostgresql.auth.database | string | `"mychart"` | Name of the database to use |
| externalPostgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| externalPostgresql.auth.password | string | `"mychart"` | Password to use |
| externalPostgresql.auth.userPasswordKey | string | `""` | Key in the secret containing the password |
| externalPostgresql.auth.username | string | `"mychart"` | Name of the user to use |
| externalPostgresql.hostname | string | `""` | Hostname of the PostgreSQL database |
| externalPostgresql.port | int | `5432` | Port used to connect to PostgreSQL database |
| fullnameOverride | string | `""` | String to fully override `"headwind-mdm.fullname"` |
| headwind.adminEmail | string | `""` | Email of admin user |
| headwind.baseDomain | string | `""` | URL under which Headwind will be available |
| headwind.forceReconfigure | bool | `false` | Subsequent starts of the container skip this step, but you can force the renewal of the configuration |
| headwind.installLanguage | string | `"en"` | Available values: en, ru (en by default) |
| headwind.sharedSecret.existingSecret | string | `""` | An existing secret that contains the shared secret for a premium setup. If this is provided `headwind.sharedSecret.secretValue` is ignored. Key needs to be `shared-secret``. |
| headwind.sharedSecret.secretValue | string | `""` | The shared secret for a premium setup. Ignored if `headwind.sharedSecret.existingSecret` is provided. |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"headwindmdm/hmdm"` | image repository |
| image.tag | string | `"0.1.7"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.ip | string | `""` | ip to resolve public uri behind reverse proxy |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `headwind-mdm` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `false` |  |
| persistence.existingClaim | string | `""` |  |
| persistence.size | string | `"10Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| postgresql.auth.database | string | `"mychart"` | Name for a custom database to create |
| postgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| postgresql.auth.password | string | `"mychart"` | Password for the custom user to create. Ignored if postgresql.auth.existingSecret is provided |
| postgresql.auth.username | string | `"mychart"` | Name for a custom user to create |
| postgresql.enabled | bool | `true` | enable PostgreSQL™ subchart from Bitnami |
| postgresql.image.repository | string | `"bitnamilegacy/postgresql"` | image repository for PostgreSQL™ subchart from Bitnami |
| postgresql.image.tag | string | `"17.6.0-debian-12-r4"` | image tag for PostgreSQL™ subchart from Bitnami |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the headwind pods. |
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
helm install my-release -f values.yaml christianhuth/headwind-mdm
```

## Upgrading the Chart

### To 4.0.0

This major updates the PostgreSQL subchart to its newest major, 18.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#upgrading) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the PostgreSQL subchart to its newest major, 16.4.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1630) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the PostgreSQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1400) you can find more information about the changes introduced in that version.

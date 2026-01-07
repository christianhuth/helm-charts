# freshrss

FreshRSS is a free, self-hostable feed aggregator

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/freshrss
```

## Introduction

FreshRSS is a self-hosted RSS and Atom feed aggregator.

This chart bootstraps [FreshRSS](https://freshrss.org) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/freshrss
```

These commands deploy FreshRSS on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| externalPostgresql.auth.database | string | `""` | Name of the database to use |
| externalPostgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| externalPostgresql.auth.password | string | `""` | Password to use |
| externalPostgresql.auth.userPasswordKey | string | `""` | Key in the secret containing the password |
| externalPostgresql.auth.username | string | `""` | Name of the user to use |
| externalPostgresql.hostname | string | `""` | Hostname of the PostgreSQL database |
| externalPostgresql.port | int | `5432` | Port used to connect to PostgreSQL database |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| freshrss.baseUrl | string | `""` | URL under which FreshRSS will be available. Will use the first Ingress host if Ingress is enabled with `ingress.enabled`. |
| freshrss.cronjob.minutes | string | `"1,31"` | Minutes to run an automatic cronjob to refresh feeds |
| freshrss.cronjob.type | string | `"internal"` | How to run the CronJob to synchronize your Feeds. Supported values are internal and sidecar. |
| freshrss.database.type | string | `"sqlite"` | Database type to use. Supported values are sqlite and postgresql. |
| freshrss.environment | string | `"production"` | Enables additional development information if set to development (increases the level of logging and ensures that errors are displayed). |
| freshrss.initialization.admin.apiPassword | string | `""` | API Password of admin user. Will only be used if initialization is activated. |
| freshrss.initialization.admin.email | string | `""` | Email of admin user. Will only be used if initialization is activated. |
| freshrss.initialization.admin.password | string | `""` | Password of admin user. Will only be used if initialization is activated. |
| freshrss.initialization.admin.username | string | `"admin"` | Username of admin user. Will only be used if initialization is activated. |
| freshrss.initialization.apiEnabled | bool | `true` | enable the FreshRSS API. Will only be used if initialization is activated. |
| freshrss.initialization.enabled | bool | `true` | Use Auto-install for initialization. Make sure to set this to false once the initialization is done. |
| freshrss.initialization.language | string | `"en"` | Language of the FreshRSS UI. Will only be used if initialization is activated. |
| freshrss.persistence.annotations | object | `{}` | Add annotations to the different FreshRSS PVCs |
| freshrss.persistence.data.accessModes | list | `["ReadWriteOnce"]` | Access Modes for the PVC for the data folder |
| freshrss.persistence.data.annotations | object | `{}` | Add annotations to the PVC for the data folder |
| freshrss.persistence.data.enabled | bool | `true` | Enable persistence for the data folder |
| freshrss.persistence.data.existingClaim | string | `""` | Use an existing claim as PVC for the data folder |
| freshrss.persistence.data.size | string | `"5Gi"` | Define the size of the PVC for the data folder |
| freshrss.persistence.data.storageClass | string | `""` | Define the storage class of the PVC for the data folder |
| freshrss.persistence.enabled | bool | `true` | Enable persistence for FreshRSS data |
| freshrss.persistence.extensions.accessModes | list | `["ReadWriteOnce"]` | Access Modes for the PVC for the extensions folder |
| freshrss.persistence.extensions.annotations | object | `{}` | Add annotations to the PVC for the extensions folder |
| freshrss.persistence.extensions.enabled | bool | `true` | Enable persistence for the extensions folder |
| freshrss.persistence.extensions.existingClaim | string | `""` | Use an existing claim as PVC for the extensions folder |
| freshrss.persistence.extensions.size | string | `"5Gi"` | Define the size of the PVC for the extensions folder |
| freshrss.persistence.extensions.storageClass | string | `""` | Define the storage class of the PVC for the extensions folder |
| freshrss.persistence.storageClass | string | `""` | Define the storage class for the different FreshRSS PVCs |
| freshrss.timezone | string | `"Europe/Berlin"` | Timezone |
| fullnameOverride | string | `""` | String to fully override `"freshrss.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"freshrss/freshrss"` | image repository |
| image.tag | string | `"1.28.0"` | Overrides the image tag |
| image.type | string | `"alpine"` | Define which type of image should be used. Supported values are alpine and debian. |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.ip | string | `""` | ip to resolve public uri behind reverse proxy |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | Provide a name in place of `freshrss` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| postgresql.auth.database | string | `""` | Name for a custom database to create |
| postgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| postgresql.auth.password | string | `""` | Password for the custom user to create. Ignored if postgresql.auth.existingSecret is provided |
| postgresql.auth.username | string | `""` | Name for a custom user to create |
| postgresql.enabled | bool | `false` | enable PostgreSQL™ subchart from Bitnami |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the freshrss pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| route.main.additionalRules | list | `[]` | Additional custom rules that can be added to the route |
| route.main.annotations | object | `{}` | Add annotations to the route |
| route.main.apiVersion | string | `"gateway.networking.k8s.io/v1"` | Set the route apiVersion, e.g. gateway.networking.k8s.io/v1 or gateway.networking.k8s.io/v1alpha2 |
| route.main.enabled | bool | `false` | Enables or disables the route |
| route.main.filters | list | `[]` | Filters define the filters that are applied to requests that match this rule. |
| route.main.hostnames | list | `[]` | Hostnames to be matched |
| route.main.httpsRedirect | bool | `false` | adds a filter for redirecting to https (HTTP 301 Moved Permanently). # To redirect HTTP traffic to HTTPS, you need to have a Gateway with both HTTP and HTTPS listeners. # Matches and filters do not take effect if enabled. # Ref. https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/ |
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
helm install my-release -f values.yaml christianhuth/freshrss
```

## Upgrading

### To 2.0.0

This major updates the PostgreSQL subchart to its newest major, 18.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#upgrading) you can find more information about the changes introduced in that version.

## Initialization

This Chart can initialize FreshRSS on the first installation using the attribute `freshrss.initialization.enabled`, which defaults to `true`.
The initialization will configure the database connection and create the admin user for you.

This approach however has two downsides:

  1. Confidential information like admin and database password have to be added to the environment variables `FRESHRSS_INSTALL` and `FRESHRSS_USER` of the Container
  2. Therefore you have to define these passwords using the attributes `freshrss.initialization.admin.apiPassword`, `freshrss.initialization.admin.password`, `postgresql.auth.password` or `externalPostgresql.auth.password` and cannot use existing Kubernetes Secrets to define these values like you would in a GitOps based setup

Make sure to set `freshrss.initialization.enabled=false` after the initialization has finished to remove the environment variables `FRESHRSS_INSTALL` and `FRESHRSS_USER` containing the confidential information again.

The Logs should contain something like the following:

```console
FreshRSS install…
ℹ️ Remember to create the default user: huthcn   ./cli/create-user.php --user huthcn --password 'password' --more-options
ℹ️ Remember to re-apply the appropriate access rights, such as:  sudo cli/access-permissions.sh
✅ FreshRSS successfully installed.
FreshRSS creating user “huthcn”…
FreshRSS[31]: FreshRSS Favicon GET https://github.com/FreshRSS/FreshRSS/
FreshRSS[31]: FreshRSS Favicon GET https://github.githubassets.com/favicons/favicon.svg
ℹ️ Remember to refresh the feeds of the user: huthcn     ./cli/actualize-user.php --user huthcn
ℹ️ Remember to re-apply the appropriate access rights, such as:  sudo cli/access-permissions.sh
✅ FreshRSS user successfully created.
```

You can of course set `freshrss.initialization.enabled=false` right away and initialize FreshRSS yourself using the Web UI.

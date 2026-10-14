# shlink-backend

A PHP-based self-hosted URL shortener that can be used to serve shortened URLs under your own domain.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/shlink-backend
```

## Introduction

This chart bootstraps a self-hosted URL shortener called [Shlink](https://shlink.io) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+
- The [CloudNativePG operator](https://cloudnative-pg.io) if the bundled PostgreSQL database is used (`postgresql.enabled: true`)
- The [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator) if the bundled MariaDB database is used (`mariadb.enabled: true`)

Shlink uses SQLite by default, which needs neither of them. RabbitMQ ([cloudpirates/rabbitmq](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/rabbitmq)) and Valkey ([valkey/valkey](https://github.com/valkey-io/valkey-helm/tree/main/valkey)) are bundled as regular subcharts and don't need an operator.

### Installing the operators

The operators are not part of this chart, as they are installed once per Kubernetes cluster:

```console
# CloudNativePG, for postgresql.enabled
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm upgrade --install cnpg cnpg/cloudnative-pg --namespace cnpg-system --create-namespace --wait

# mariadb-operator, for mariadb.enabled
helm repo add mariadb-operator https://helm.mariadb.com/mariadb-operator
helm upgrade --install mariadb-operator-crds mariadb-operator/mariadb-operator-crds --namespace mariadb-operator --create-namespace
helm upgrade --install mariadb-operator mariadb-operator/mariadb-operator --namespace mariadb-operator --wait
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/shlink-backend
```

These commands deploy Shlink on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuring the Dependencies

Shlink uses SQLite by default and optionally a database server, a Redis-compatible cache and RabbitMQ for real-time updates. Each of them is either bundled with the chart or provided externally. Passwords are read from Secrets, using existing Secrets is recommended for production.

### PostgreSQL

```console
kubectl create secret generic shlink-database \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=shlink \
  --from-literal=password='<password>'
```

```yaml
postgresql:
  enabled: true
  cluster:
    initdb:
      database: shlink
      owner: shlink
      secret:
        name: shlink-database
```

The `username` in the Secret has to match `postgresql.cluster.initdb.owner`. If no Secret is referenced, the operator generates the Secret `<release>-postgresql-app`. See the [values](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster#values) of the upstream chart for all options.

### MariaDB

```console
kubectl create secret generic shlink-database --from-literal=password='<password>'
```

```yaml
mariadb:
  enabled: true
  mariadb:
    passwordSecretKeyRef:
      name: shlink-database
      key: password
      generate: false
```

If no Secret is referenced, the operator generates the Secret `<release>-mariadb-password`. By default the database runs as a Galera cluster with 3 instances. To upgrade to another MariaDB release series, change the tag of `mariadb.mariadb.image`; the operator migrates the system schema, but downgrades are not supported. See the [values](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster) of the upstream chart for all options.

Only one bundled database can be enabled at a time.

### Valkey

```yaml
valkey:
  enabled: true
```

Valkey runs without authentication by default. To require a password for the user `default`, which Shlink authenticates as:

```console
kubectl create secret generic shlink-valkey --from-literal=password='<password>'
```

```yaml
valkey:
  enabled: true
  auth:
    enabled: true
    usersExistingSecret: shlink-valkey
    aclUsers:
      default:
        permissions: "~* &* +@all"
        passwordKey: password
```

Shlink receives the password as part of its Redis server URL, so it must only contain URL-safe characters (`A-Z`, `a-z`, `0-9`, `-`, `.`, `_`, `~`). See the [values](https://github.com/valkey-io/valkey-helm/tree/main/valkey#values) of the upstream chart for all options.

### RabbitMQ

```console
kubectl create secret generic shlink-rabbitmq \
  --from-literal=password='<password>' \
  --from-literal=erlang-cookie='<random string>'
```

```yaml
rabbitmq:
  enabled: true
  auth:
    username: shlink
    existingSecret: shlink-rabbitmq
    existingPasswordKey: password
```

If no Secret is referenced, the chart generates a random password and Erlang cookie in the Secret `<release>-rabbitmq`. By default RabbitMQ runs as a cluster of 3 instances. See the [values](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/rabbitmq#parameters) of the upstream chart for all options.

### External Services

```yaml
externalDatabase:
  type: postgres # mysql, maria, postgres or mssql
  hostname: postgresql.example.com
  database: shlink
  username: shlink
  existingSecret: shlink-database
  existingSecretPasswordKey: password

externalRedis:
  hostname: redis.example.com
  port: 6379
  existingSecret: shlink-redis
  existingSecretPasswordKey: password

externalRabbitmq:
  hostname: rabbitmq.example.com
  username: shlink
  existingSecret: shlink-rabbitmq
  existingSecretPasswordKey: password
```

Instead of `existingSecret` you can set `password`, which lets the chart create the Secret. As for Valkey, the Redis password must only contain URL-safe characters. For Redis Sentinel, point `externalRedis.hostname` to a Sentinel instance and set `externalRedis.sentinelService`.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| config.database.useEncryption | bool | `false` | Whether it is desired to use an encrypted connection with the database or not |
| config.general.basePath | string | `""` | The base path from which you plan to serve Shlink, in case you don’t want to serve it from the root of the domain. It has to start with a bar, like /shlink. Defaults to ''. |
| config.general.cacheNamespace | string | `""` | A prefix used for all cache keys generated by Shlink. It’s important to set a unique value here if you have multiple Shlink instances sharing the same cache store (same server when not using redis, or same redis cluster), otherwise there could be collisions. Defaults to Shlink. |
| config.general.defaultDomain | string | `""` | The default short domain used for this Shlink instance. For example s.test. |
| config.general.initialApiKey | string | `""` | An API key that will be created once during container start-up, with admin permissions. |
| config.general.isHttpsEnabled | bool | `false` | Tells if Shlink is served with https or not (true or false). It’s still up to you to actually serve it with HTTPS. |
| config.general.memoryLimit | string | `""` | The maximum amount of memory that every Shlink process can use. You can provide a number, which will be the amount of memory in bytes, or a number followed by K for kilobytes, M for megabytes or G for gigabytes. You can also provide -1 to set no memory limit. Defaults to 512M. |
| config.general.timezone | string | `""` | A timezone code as defined [in this list](https://www.php.net/manual/en/timezones.php). All dates stored by Shlink (visits, short URL creation, etc) will be considered to be on this timezone. By default, the default timezone set in PHP config will be used, which is UTC in the case of the docker image. |
| config.geolite.licenseKey | string | `""` | The license key used to download new GeoLite2 database files. Go to GeoLite2 license key to know how to generate it. Not providing a license key will completely disable visits geolocation. |
| config.geolite.skipInitialDownload | bool | `false` | If provided with value true, it will skip the initial GeoLite2 db file download, speeding-up the container start-up. As a side effect, first visits on this container will remain un-located until the file finishes downloading in background. |
| config.matomo.auth.apiToken | string | `""` | The API token so that Shlink can call Matomo’s API |
| config.matomo.auth.existingSecret | string | `""` | Use existing secret for the API token details (`config.matomo.auth.apiToken` will be ignored and picked up from this secret). The secret has to contain the key `api-token`. |
| config.matomo.baseUrl | string | `""` | The external Matomo server URL. |
| config.matomo.enabled | bool | `false` | Enable the Matomo integration to sent visits |
| config.matomo.siteId | string | `""` | The site ID to be used for Shlink visits. |
| config.mercure.auth.existingSecret | string | `""` | Use existing secret for the JWT secret details (`config.mercure.auth.jwtSecret` will be ignored and picked up from this secret). The secret has to contain the key `jwt-secret`. |
| config.mercure.auth.jwtSecret | string | `""` | The secret key that was provided to the mercure hub server, in order to be able to generate valid JWTs for publishing/subscribing to that server. |
| config.mercure.enabled | bool | `false` | Enable the Mercure Hub integration. |
| config.mercure.internalHubUrl | string | `""` | An internal URL for a mercure hub. Will be used only when publishing updates to mercure, and does not need to be public. |
| config.mercure.publicHubUrl | string | `""` | The public URL of a mercure hub server to which Shlink will sent updates. This URL will also be served to consumers that want to subscribe to those updates. |
| config.qrCodes.codeForDisabledShortUrls | bool | `true` | Whether generating QR codes should work for disabled short URLs. Disabled short URLs are those which reached the maximum amount of visits, have a validSince date in the future, or a validUntil date in the past. |
| config.qrCodes.defaultColors.background | string | `"#FFFFFF"` | The QR code background color. |
| config.qrCodes.defaultColors.foreground | string | `"#000000"` | The QR code foreground color. |
| config.qrCodes.defaultErrorCorrection | string | `"l"` | One of L (Low), M (Medium), Q (Quartile) or H (High), to determine the default error correction of generated QR codes when the errorCorrection query param is not provided. |
| config.qrCodes.defaultFormat | string | `"png"` | One of png or svg, to determine the default format of generated QR codes when the format query param is not provided. |
| config.qrCodes.defaultLogoUrl | string | `""` | A URL pointing to a logo that will be placed in the middle of the QR code. This one is experimental, as some images might break the QR code. |
| config.qrCodes.defaultMargin | int | `0` | A value greater than 0 to determine the default margin of generated QR codes when the margin query param is not provided. |
| config.qrCodes.defaultRoundBlockSize | bool | `true` | Tells if the block size should be round on QR codes, making it more readable, but potentially adding some extra margin as a side effect. |
| config.qrCodes.defaultSize | int | `300` | A value between 50 and 1000 to determine the default size of generated QR codes when the size query param is not provided. |
| config.redirects.cacheLifetime | int | `30` | Allows to set the amount of seconds that redirects should be cached when redirect status is 301 or 308. |
| config.redirects.defaultBaseUrlRedirect | string | `""` | If a URL is provided here, when a user tries to access Shlink’s base URL, and the visited domain does not have a redirect URL of its own, he/she will be redirected to this value. If this env var is not provided, the user will see a generic 404 - not found page. |
| config.redirects.defaultInvalidShortUrlRedirect | string | `""` | If a URL is provided here, when a user tries to access an invalid short URL, and the visited domain does not have a redirect URL of its own, he/she will be redirected to this value. If this env var is not provided, the user will see a generic 404 - not found page. |
| config.redirects.defaultRegular404Redirect | string | `""` | If a URL is provided here, when a user tries to access a URL not matching any supported by the router, and the visited domain does not have a redirect URL of its own, he/she will be redirected to this value. If this env var is not provided, the user will see a generic 404 - not found page. |
| config.redirects.extraPathMode | string | `"default"` | Determines how Shlink should match short URLs when they start with a known short code. Valid values are default, append and ignore. (See [Extra path forwarding](https://shlink.io/documentation/some-features/#extra-path-forwarding) for more info). |
| config.redirects.statusCode | int | `302` | 301, 302, 308 or 307 (last two since v3.5.0). Determines the status code that should be used on redirects from short to long URLs. Setting 308 or 307 implicitly makes requests to short URLs work regardless the HTTP method. |
| config.redis.pubSubEnabled | bool | `false` | Tells if the configured Redis-compatible server should also be used to publish real-time updates via pub/sub |
| config.robots.allowAllShortUrls | bool | `false` | Whether all short URLs should be allowed via robots.txt or not. If set to true, the crawlable option set in individual short URLs will be ignored. |
| config.robots.userAgents | string | `"*"` | A comma-separated list of allowed user agents via robots.txt. |
| config.trackingVisits.anonymizeRemoteAddr | bool | `true` | Tells if IP addresses from visitors should be obfuscated before storing them in the database. See [Tracking visits](https://shlink.io/documentation/tracking-visits/) for more info. |
| config.trackingVisits.disable | bool | `false` | Tells if visits tracking should be completely disabled. See [Tracking visits](https://shlink.io/documentation/tracking-visits/) for more info. |
| config.trackingVisits.disableIpTracking | bool | `false` | Tells if tracking of the IP address (and therefore visitors location) should be disabled. See [Tracking visits](https://shlink.io/documentation/tracking-visits/) for more info. |
| config.trackingVisits.disableReferrerTracking | bool | `false` | Tells if tracking of the referrer should be disabled. See [Tracking visits](https://shlink.io/documentation/tracking-visits/) for more info. |
| config.trackingVisits.disableTrackingFrom | string | `""` | A comma-separated list of IP address patterns from which all tracking should be disabled. It allows providing fixed IP addresses (100.200.80.40), CIDR blocks (192.168.10.0/24) or wildcard patterns (11.22.*.*) |
| config.trackingVisits.disableTrackingParam | string | `""` | The name of a query param that can be used to visit short URLs avoiding the visit to be tracked. This feature won’t be available if no value is provided. See [Tracking visits](https://shlink.io/documentation/tracking-visits/) for more info. |
| config.trackingVisits.disableUaTracking | bool | `false` | Tells if tracking of the user agent should be disabled. See [Tracking visits](https://shlink.io/documentation/tracking-visits/) for more info. |
| config.trackingVisits.trackOrphanVisits | bool | `true` | Tells if orphan visits should be tracked or not. See [Tracking visits](https://shlink.io/documentation/tracking-visits/) for more info. |
| config.urlShortening.autoResolveTitles | bool | `true` | Used to automatically resolve the short URL’s title based on the title-tag in the long URL |
| config.urlShortening.defaultShortCodesLength | int | `5` | The length you want generated short codes to have. It defaults to 5 and has to be at least 4, so any value smaller than that will fall back to 4. |
| config.urlShortening.deleteShortUrlThreshold | string | `""` | The amount of visits on short URLs which will not allow them to be deleted. If not provided, this restriction will be disabled. |
| config.urlShortening.multiSegmentSlugsEnabled | bool | `false` | Allows to create and handle multi-segment custom slugs when true is provided. See [multi-segment custom slugs](https://shlink.io/documentation/some-features/#multi-segment-custom-slugs) for more information. |
| config.urlShortening.shortUrlMode | string | `"strict"` | Determines how to match short URLs. Valid values are strict or loose. See [short URLs mode](https://shlink.io/documentation/some-features/#short-urls-mode) for more information. |
| config.urlShortening.shortUrlTrailingSlash | bool | `false` | Allows to enable support for trailing slashes in short URLs when true is provided. See [short URLs trailing slash](https://shlink.io/documentation/some-features/#short-urls-trailing-slash) for more information. |
| deploymentStrategy | object | `{}` | Update strategy for the deployment |
| externalDatabase.database | string | `"shlink"` | Name of the database to use |
| externalDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user |
| externalDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalDatabase.hostname | string | `""` | Hostname of the external database. Used if `mariadb.enabled` and `postgresql.enabled` are false. |
| externalDatabase.password | string | `""` | Password of the user. Ignored if `externalDatabase.existingSecret` is set. |
| externalDatabase.port | string | `""` | Port of the external database. Defaults to the default port of the driver. |
| externalDatabase.type | string | `""` | Driver of the external database: `mysql`, `maria`, `postgres` or `mssql`. Shlink uses SQLite if neither a bundled nor an external database is configured. |
| externalDatabase.username | string | `"shlink"` | Name of the user to use |
| externalRabbitmq.existingSecret | string | `""` | Name of an existing Secret containing the password |
| externalRabbitmq.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalRabbitmq.hostname | string | `""` | Hostname of the external RabbitMQ server. Used if `rabbitmq.enabled` is false. |
| externalRabbitmq.password | string | `""` | Password of the user. Ignored if `externalRabbitmq.existingSecret` is set. |
| externalRabbitmq.port | int | `5672` | AMQP port of the external RabbitMQ server |
| externalRabbitmq.useSsl | bool | `false` | Whether the connection is encrypted with SSL/TLS |
| externalRabbitmq.username | string | `"shlink"` | Name of the user to use |
| externalRabbitmq.vhost | string | `"/"` | Virtual host to use |
| externalRedis.existingSecret | string | `""` | Name of an existing Secret containing the password |
| externalRedis.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalRedis.hostname | string | `""` | Hostname of an external Redis or Valkey server. Used if `valkey.enabled` is false. |
| externalRedis.password | string | `""` | Password of the user. Ignored if `externalRedis.existingSecret` is set. Leave empty if the server does not require authentication. |
| externalRedis.port | int | `6379` | Port of the external server |
| externalRedis.sentinelService | string | `""` | Name of a Redis Sentinel service. If set, `externalRedis.hostname` and `externalRedis.port` point to a Sentinel instance. |
| externalRedis.username | string | `""` | Name of the user to use. Leave empty to authenticate with a password only. |
| extraEnv | list | `[]` | additional environment variables to be added to the pods. See https://shlink.io/documentation/environment-variables for a complete list. |
| fullnameOverride | string | `""` | String to fully override `"shlink-backend.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"shlinkio/shlink"` | image repository |
| image.tag | string | `"5.1.7"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| mariadb.enabled | bool | `false` | Enable a MariaDB instance managed by the mariadb-operator. Requires the operator to be installed in the cluster (see README). |
| mariadb.mariadb.database | string | `"shlink"` | Name of the database to create |
| mariadb.mariadb.galera.enabled | bool | `true` | Enable Galera to run multiple instances |
| mariadb.mariadb.image | string | `"mariadb:12.3"` | MariaDB image. The tag only pins the release series (12.3 is the current long-term support release), so restarted instances get its latest patch version. |
| mariadb.mariadb.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest patch version of the release series |
| mariadb.mariadb.passwordSecretKeyRef.generate | bool | `true` | Let the operator generate the Secret with a random password if it does not exist |
| mariadb.mariadb.passwordSecretKeyRef.key | string | `"password"` | Key of the password inside the Secret |
| mariadb.mariadb.passwordSecretKeyRef.name | string | `""` | Name of an existing Secret containing the password of the user. If empty, the Secret `<release>-mariadb-password` is used. |
| mariadb.mariadb.replicas | int | `3` | Number of MariaDB instances. More than one instance requires Galera or replication. |
| mariadb.mariadb.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| mariadb.mariadb.updateStrategy.mariadbAutoUpgradeEnabled | bool | `true` | Run `mariadb-upgrade` on start, so that changing the release series in `image` migrates the system schema. It is a no-op if there is nothing to migrate. |
| mariadb.mariadb.username | string | `"shlink"` | Name of the user to create |
| nameOverride | string | `""` | Provide a name in place of `shlink-backend` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podLabels | object | `{}` | Labels to be added to pods |
| podSecurityContext | object | `{}` | pod-level security context |
| postgresql.cluster.imageName | string | `"ghcr.io/cloudnative-pg/postgresql:18-standard-trixie"` | PostgreSQL image. The tag only pins the major version, so restarted instances get the latest minor version. |
| postgresql.cluster.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest minor version of the major version |
| postgresql.cluster.initdb.database | string | `"shlink"` | Name of the database to create |
| postgresql.cluster.initdb.owner | string | `"shlink"` | Name of the user owning the database |
| postgresql.cluster.instances | int | `3` | Number of PostgreSQL instances (one primary, the others are replicas) |
| postgresql.cluster.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| postgresql.enabled | bool | `false` | Enable a PostgreSQL cluster managed by the CloudNativePG operator. Requires the operator to be installed in the cluster (see README). |
| postgresql.version.postgresql | string | `"18"` | PostgreSQL major version. Has to match the major version of `postgresql.cluster.imageName`. |
| rabbitmq.auth.existingPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| rabbitmq.auth.existingSecret | string | `""` | Name of an existing Secret containing the password of the default user (and the Erlang cookie) |
| rabbitmq.auth.password | string | `""` | Password of the default user. A random password is generated if empty. Ignored if `rabbitmq.auth.existingSecret` is set. |
| rabbitmq.auth.username | string | `"shlink"` | Name of the default user, used by Shlink |
| rabbitmq.enabled | bool | `false` | Enable a RabbitMQ instance (chart cloudpirates/rabbitmq) to publish real-time updates |
| rabbitmq.peerDiscoveryK8sPlugin.enabled | bool | `true` | Enable the Kubernetes peer discovery plugin to form a cluster of multiple instances |
| rabbitmq.replicaCount | int | `3` | Number of RabbitMQ instances. More than one instance requires `rabbitmq.peerDiscoveryK8sPlugin.enabled`. |
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
| route.main.timeouts | object | `{}` | defines the timeouts that can be configured for an HTTP request |
| securityContext | object | `{}` | container-level security context |
| service.port | int | `8080` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |
| valkey.auth.aclUsers | object | `{}` | ACL users. Shlink authenticates as the user `default`, which is required if authentication is enabled. |
| valkey.auth.enabled | bool | `false` | Enable password authentication. Shlink authenticates as the user `default`. |
| valkey.auth.usersExistingSecret | string | `""` | Name of an existing Secret containing the passwords of the users (key `<user>` or `aclUsers.<user>.passwordKey`). Takes precedence over inline passwords. |
| valkey.enabled | bool | `false` | Enable a Valkey instance (official chart valkey/valkey) used by Shlink as cache and for locks |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/shlink-backend
```

## Upgrading the Chart

### To 12.0.0

This major replaces the Bitnami subcharts:

- PostgreSQL is managed by the [CloudNativePG operator](https://cloudnative-pg.io) and MariaDB by the [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator). Install the operator for your database first (see [Prerequisites](#prerequisites)).
- RabbitMQ is deployed with the chart [cloudpirates/rabbitmq](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/rabbitmq) and updated to RabbitMQ 4.3, Redis is replaced by [Valkey](https://valkey.io) with the official chart [valkey/valkey](https://github.com/valkey-io/valkey-helm/tree/main/valkey).
- The bundled MySQL database is removed. Migrate to the bundled MariaDB (a MySQL dump can be restored into MariaDB without changes) or use an external MySQL database with `externalDatabase.type: mysql`.

The values changed as follows:

- `postgresql.auth.*`, `mariadb.auth.*`, `rabbitmq.*` and `redis.*` are replaced by the values of the new upstream charts, `redis.*` moved to `valkey.*` (see [Configuring the Dependencies](#configuring-the-dependencies))
- inline passwords for the bundled databases are no longer supported. Use an existing Secret or let the operator generate one
- `config.database.*` (except `useEncryption`), `config.rabbitmq.*` and `config.redis.*` (except `pubSubEnabled`) are replaced by `externalDatabase.*`, `externalRabbitmq.*` and `externalRedis.*`. `config.database.driver` is now `externalDatabase.type`, and an external service is used if its `hostname` is set
- enabling more than one bundled database now fails instead of silently using the first one

Releases using SQLite (the default) keep their data. If you use a bundled database, the upgrade creates a new, empty one. Valkey (cache) and RabbitMQ (real-time updates) start empty as well, which is fine for Shlink. To take your database along:

1. Dump the database before upgrading. For PostgreSQL:

   ```console
   kubectl exec <release>-postgresql-0 -- sh -c 'PGPASSWORD="$(cat "$POSTGRES_PASSWORD_FILE")" pg_dump --no-owner --no-acl -U "$POSTGRES_USER" -d "$POSTGRES_DATABASE"' > shlink.sql
   ```

   For MariaDB (or MySQL, with `mysqldump` and `MYSQL_*` instead):

   ```console
   kubectl exec <release>-mariadb-0 -- sh -c 'mariadb-dump -u"$MARIADB_USER" -p"$(cat "$MARIADB_PASSWORD_FILE")" "$MARIADB_DATABASE"' > shlink.sql
   ```

2. If you use the bundled RabbitMQ, remove its StatefulSet and volume. The new RabbitMQ uses the same names, so Helm would otherwise try to patch the StatefulSet (which fails) and RabbitMQ would mount the old volume:

   ```console
   kubectl delete statefulset <release>-rabbitmq
   kubectl delete pvc data-<release>-rabbitmq-0
   ```

3. Upgrade the chart with Shlink scaled down, so it does not initialize the new database. Then wait for the database:

   ```console
   helm upgrade <release> christianhuth/shlink-backend --version 12.0.0 -f values.yaml --set replicaCount=0 --wait
   # PostgreSQL
   kubectl wait --for=condition=Ready cluster/<release>-postgresql --timeout=10m
   # MariaDB
   kubectl wait --for=create user/<release>-mariadb-user --timeout=10m
   kubectl wait --for=create grant/<release>-mariadb-user-all --timeout=10m
   kubectl wait --for=condition=Ready user/<release>-mariadb-user grant/<release>-mariadb-user-all --timeout=10m
   ```

4. Restore the dump. For PostgreSQL (use the Secret from `postgresql.cluster.initdb.secret.name` or the generated `<release>-postgresql-app`):

   ```console
   PASSWORD=$(kubectl get secret <release>-postgresql-app -o jsonpath='{.data.password}' | base64 -d)
   PRIMARY=$(kubectl get cluster <release>-postgresql -o jsonpath='{.status.currentPrimary}')
   kubectl exec -i $PRIMARY -c postgres -- env PGPASSWORD="$PASSWORD" psql -v ON_ERROR_STOP=1 -h localhost -U shlink -d shlink < shlink.sql
   ```

   For MariaDB (use the Secret from `mariadb.mariadb.passwordSecretKeyRef` or the generated `<release>-mariadb-password`):

   ```console
   PASSWORD=$(kubectl get secret <release>-mariadb-password -o jsonpath='{.data.password}' | base64 -d)
   kubectl exec -i <release>-mariadb-0 -c mariadb -- mariadb -u shlink --password="$PASSWORD" shlink < shlink.sql
   ```

5. Scale Shlink up again:

   ```console
   helm upgrade <release> christianhuth/shlink-backend --version 12.0.0 -f values.yaml --wait
   ```

6. Once everything works, delete the old PersistentVolumeClaims of the Bitnami database (`data-<release>-postgresql-0`, `data-<release>-mariadb-0` or `data-<release>-mysql-0`) and of Redis (`redis-data-<release>-redis-master-0`).

### To 9.0.0

This major updates the following dependencies:

- MariaDB to its newest major, 24.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.
- PostgreSQL to its newest major, 18.1.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#pgrading) you can find more information about the changes introduced in that version.
- Redis to its newest major, 24.1.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) you can find more information about the changes introduced in that version.

### To 8.0.0

This major updates the following dependencies:

- MariaDB to its newest major, 22.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.
- MySQL to its newest major, 14.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1400) you can find more information about the changes introduced in that version.
- Redis to its newest major, 22.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) you can find more information about the changes introduced in that version.

### To 7.0.0

This major updates the following dependencies:

- MariaDB to its newest major, 21.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.
- MySQL to its newest major, 13.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1300) you can find more information about the changes introduced in that version.
- Redis to its newest major, 21.2.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) you can find more information about the changes introduced in that version.

### To 5.0.0

This major updates the following dependencies:

- MariaDB to its newest major, 20.2.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-2020) you can find more information about the changes introduced in that version.
- MySQL to its newest major, 12.2.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1220) you can find more information about the changes introduced in that version.
- PostgreSQL to its newest major, 16.3.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1630) you can find more information about the changes introduced in that version.
- RabbitMQ to its newest major, 15.2.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq#to-1520) you can find more information about the changes introduced in that version.
- Redis to its newest major, 20.5.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-2050) you can find more information about the changes introduced in that version.

It also upgrades the Shlink Backend to its newest major, 4.4.0 and introduces a new way to define the configuration using the `config.*` Values.
If you have been using the `env` attribute so far to configure Shlink it is strongly recommended to migrate to the corresponding `config.*` Value.
The `env` attribute further has been replaced by an `extraEnv` attribute.

### To 4.0.0

This major updates the PostgreSQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1400) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the Redis subchart to its newest major, 18.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/7.2/00-RELEASENOTES) you can find more information about the changes introduced in that version.

Additionally it updates the MariaDB subchart to its newest major, 16.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-1600) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the RabbitMQ subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq#upgrading) and [here](https://www.rabbitmq.com/upgrade.html) you can find more information about the changes introduced in that version.

### To 1.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

Additionally it updates the RabbitMQ subchart to its newest major, 11.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq#to-1100) you can find more information about the changes introduced in that version.

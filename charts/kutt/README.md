# kutt

Kutt is a free modern URL shortener.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/kutt
```

## Introduction

This chart bootstraps the free modern URL shortener called [Kutt](https://kutt.it) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+
- The [CloudNativePG operator](https://cloudnative-pg.io) if the bundled PostgreSQL database is used (`postgresql.enabled: true`, the default)

### Installing the CloudNativePG operator

The chart bundles a PostgreSQL cluster as a custom resource of the CloudNativePG operator (via the upstream chart [cnpg/cluster](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster)). The operator itself is not part of this chart, as it is installed once per Kubernetes cluster:

```console
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo update
helm upgrade --install cnpg cnpg/cloudnative-pg --namespace cnpg-system --create-namespace --wait
```

Valkey ([valkey/valkey](https://github.com/valkey-io/valkey-helm/tree/main/valkey)) is bundled as a regular subchart and doesn't need an operator.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/kutt
```

These commands deploy Kutt on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuring the Dependencies

Kutt needs a PostgreSQL database and optionally uses a Redis-compatible cache. Both are either bundled with the chart or provided externally. Passwords are read from Secrets, using existing Secrets is recommended for production.

### PostgreSQL

Create a Secret of type `kubernetes.io/basic-auth` containing the credentials of the database owner. The `username` has to match `postgresql.cluster.initdb.owner`:

```console
kubectl create secret generic kutt-database \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=kutt \
  --from-literal=password='<password>'
```

```yaml
postgresql:
  cluster:
    initdb:
      database: kutt
      owner: kutt
      secret:
        name: kutt-database
```

If no Secret is referenced, the operator generates a random password and stores the credentials in the Secret `<release>-postgresql-app`. All other settings of the PostgreSQL cluster (e.g. `postgresql.cluster.instances`, `postgresql.cluster.storage`, backups) are passed to the upstream chart. See its [values](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster#values) for all options.

### Valkey

By default Valkey requires the inline password `kutt` for the user `default`, which Kutt authenticates as. For production, create a Secret containing the password and reference it in your values:

```console
kubectl create secret generic kutt-valkey --from-literal=password='<password>'
```

```yaml
valkey:
  auth:
    enabled: true
    usersExistingSecret: kutt-valkey
    aclUsers:
      default:
        permissions: "~* &* +@all"
        passwordKey: password
        password: ""
```

All other settings are passed to the upstream chart, see its [values](https://github.com/valkey-io/valkey-helm/tree/main/valkey#values). Set `valkey.enabled: false` (and leave `externalRedis.hostname` empty) to run Kutt without a cache.

### External Services

```yaml
postgresql:
  enabled: false

externalDatabase:
  hostname: postgresql.example.com
  port: 5432
  database: kutt
  username: kutt
  existingSecret: kutt-database
  existingSecretPasswordKey: password

valkey:
  enabled: false

externalRedis:
  hostname: redis.example.com
  port: 6379
  existingSecret: kutt-redis
  existingSecretPasswordKey: password
```

Instead of `existingSecret` you can set `password`, which lets the chart create the Secret.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| externalDatabase.database | string | `"kutt"` | Name of the database to use |
| externalDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user |
| externalDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalDatabase.hostname | string | `""` | Hostname of the external PostgreSQL database. Used if `postgresql.enabled` is false. |
| externalDatabase.password | string | `""` | Password of the user. Ignored if `externalDatabase.existingSecret` is set. |
| externalDatabase.port | int | `5432` | Port of the external PostgreSQL database |
| externalDatabase.username | string | `"kutt"` | Name of the user to use |
| externalRedis.existingSecret | string | `""` | Name of an existing Secret containing the password |
| externalRedis.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalRedis.hostname | string | `""` | Hostname of an external Redis or Valkey server. Used if `valkey.enabled` is false. |
| externalRedis.password | string | `""` | Password of the user `default`. Ignored if `externalRedis.existingSecret` is set. Leave empty if the server does not require authentication. |
| externalRedis.port | int | `6379` | Port of the external server |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| extraEnvFrom | list | `[]` | load additional environment variables from ConfigMaps or Secrets |
| fullnameOverride | string | `""` | String to fully override `"kutt.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"kutt/kutt"` | image repository |
| image.tag | string | `"v3.2.6"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| ingress.enabled | bool | `false` | Enable ingress record generation |
| ingress.hosts | list | see [values.yaml](./values.yaml) | An array with the hosts configuration |
| ingress.tls | list | `[]` | An array with the tls configuration |
| kutt.admin.emails | string | `""` | Comma seperated list of email addresses that can access admin actions on settings page |
| kutt.config.disallowAnonymousLinks | bool | `false` | Disable anonymous link creation |
| kutt.config.disallowRegistration | bool | `false` | Disable registration |
| kutt.config.enableRateLimit | bool | `false` | Enable rate limitting for some API routes. If Redis is enabled uses Redis, otherwise, uses memory. |
| kutt.config.linkCustomAlphabet | string | `""` | Alphabet used to generate custom addresses. Default value omits o, O, 0, i, I, l, 1, and j to avoid confusion when reading the URL. |
| kutt.config.linkLength | int | `6` | Generated link length |
| kutt.config.siteName | string | `"Kutt"` | The name of the site where Kutt is hosted |
| kutt.database.client | string | `"pg"` | Which database client to use. This Chart currently only supports PostgreSQL: pg or pg-native. NOTE: pg-native is not installed by default, create your own image to use it. |
| kutt.database.pool.max | int | `10` | Maximum number of database connection pools. Only if you use Postgres or MySQL. |
| kutt.database.pool.min | int | `0` | Minimum number of database connection pools. Only if you use Postgres or MySQL. |
| kutt.database.useSsl | bool | `false` | Whether use SSL for the database connection. Only if you use Postgres or MySQL. |
| kutt.domain.customDomainUseHttps | bool | `false` | Use HTTPS for links with custom domain |
| kutt.domain.defaultDomain | string | `"localhost:3000"` | The domain that this website is on |
| kutt.domain.useFirstIngressHost | bool | `false` | If you use an ingress to expose Kutt you can simply set this to true to use the first hostname defined in the ingress. |
| kutt.jwt.existingSecret | string | `""` | Use existing secret for JWT secret key. The secret has to contain the key `JWT_SECRET`. When it's set the kutt.jwt.key is ignored. |
| kutt.jwt.key | string | `"secret-jwt-key"` | make sure to replace with your own secret key |
| kutt.mail.contactEmail | string | `""` | Support email to show on the app |
| kutt.mail.enabled | bool | `false` | Enable emails, which are used for signup, verifying or changing email address, resetting password, and sending reports. If is disabled, all these functionalities will be disabled too. |
| kutt.mail.existingSecret | string | `""` | Use existing secret for password details. The secret has to contain the key `MAIL_PASSWORD`. When it's set the `kutt.mail.password` is ignored. |
| kutt.mail.from | string | `""` | The email address Kutt will send emails from. |
| kutt.mail.host | string | `"smtp.example.com"` | The host of the external SMTP server that Kutt should use to send emails. |
| kutt.mail.password | string | `""` | The password to authenticate to the smtp host when sending emails. |
| kutt.mail.port | int | `465` | The port used to connect to the smtp host. |
| kutt.mail.reportEmail | string | `""` | The email address that will receive submitted reports. |
| kutt.mail.secure | bool | `false` | If true the connection will use TLS when connecting to server. If false (the default) then TLS is used if server supports the STARTTLS extension. In most cases set this value to true if you are connecting to port 465. For port 587 or 25 keep it false |
| kutt.mail.username | string | `"user@example.com"` | The username to authenticate to the smtp host when sending emails. |
| kutt.recaptcha.existingSecret | string | `""` | Use existing secret for ReCaptacha secrets. The secret has to contain the keys `RECAPTCHA_SITE_KEY` and `RECAPTCHA_SECRET_KEY`. When it's set the kutt.recaptcha.siteKey and kutt.recaptcha.secretKey is ignored. |
| kutt.recaptcha.secretKey | string | `""` | Invisible reCaptcha secret key. Create one in https://www.google.com/recaptcha/intro/ |
| kutt.recaptcha.siteKey | string | `""` | Invisible reCaptcha site key. Create one in https://www.google.com/recaptcha/intro/ |
| nameOverride | string | `""` | Provide a name in place of `kutt` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| postgresql.cluster.imageName | string | `"ghcr.io/cloudnative-pg/postgresql:18-standard-trixie"` | PostgreSQL image. The tag only pins the major version, so restarted instances get the latest minor version. |
| postgresql.cluster.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest minor version of the major version |
| postgresql.cluster.initdb.database | string | `"kutt"` | Name of the database to create |
| postgresql.cluster.initdb.owner | string | `"kutt"` | Name of the user owning the database |
| postgresql.cluster.instances | int | `3` | Number of PostgreSQL instances (one primary, the others are replicas) |
| postgresql.cluster.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| postgresql.enabled | bool | `true` | Enable a PostgreSQL cluster managed by the CloudNativePG operator. Requires the operator to be installed in the cluster (see README). |
| postgresql.version.postgresql | string | `"18"` | PostgreSQL major version. Has to match the major version of `postgresql.cluster.imageName`. |
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
| route.main.timeouts | object | `{}` | defines the timeouts that can be configured for an HTTP request |
| securityContext | object | `{}` | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |
| valkey.auth.aclUsers.default.password | string | `"kutt"` | Inline password of the user `default`. Use `valkey.auth.usersExistingSecret` instead for production. |
| valkey.auth.aclUsers.default.permissions | string | `"~* &* +@all"` | ACL permissions of the user `default` |
| valkey.auth.enabled | bool | `true` | Enable password authentication. Kutt authenticates with a password only, i.e. as the user `default`. |
| valkey.auth.usersExistingSecret | string | `""` | Name of an existing Secret containing the passwords of the users (key `<user>` or `aclUsers.<user>.passwordKey`). Takes precedence over inline passwords. |
| valkey.enabled | bool | `true` | Enable a Valkey instance (official chart valkey/valkey) used by Kutt as cache |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/kutt
```

## Upgrading the Chart

### To 10.0.0

This major replaces the Bitnami subcharts:

- PostgreSQL is managed by the [CloudNativePG operator](https://cloudnative-pg.io) (upstream chart [cnpg/cluster](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster)). Install the operator first (see [Prerequisites](#prerequisites)).
- Redis is replaced by [Valkey](https://valkey.io) with the official chart [valkey/valkey](https://github.com/valkey-io/valkey-helm/tree/main/valkey).

The values changed as follows:

- `postgresql.auth.*` is replaced by the values of the upstream chart, e.g. `postgresql.cluster.initdb.database` and `postgresql.cluster.initdb.owner`
- an inline password for the bundled database is no longer supported. Use an existing Secret or let the operator generate one (see [Configuring the Dependencies](#configuring-the-dependencies))
- `redis.*` is replaced by `valkey.*` with the values of the upstream chart
- `externalPostgresql.*` is renamed to `externalDatabase.*` and `externalRedis.*` is restructured: the `auth.*` keys moved one level up, `userPasswordKey` is renamed to `existingSecretPasswordKey`, and `externalRedis.enabled` / `externalRedis.auth.enabled` are removed (an external server is used if `externalRedis.hostname` is set, authentication if a password or Secret is given)

The upgrade creates a new, empty database. Valkey (cache) starts empty as well, which is fine for Kutt. The Bitnami StatefulSet is removed, but its PersistentVolumeClaim `data-<release>-postgresql-0` is kept. To take your data along:

1. Dump the database before upgrading:

   ```console
   kubectl exec <release>-postgresql-0 -- sh -c 'PGPASSWORD="$(cat "$POSTGRES_PASSWORD_FILE")" pg_dump --no-owner --no-acl -U "$POSTGRES_USER" -d "$POSTGRES_DATABASE"' > kutt.sql
   ```

2. Upgrade the chart with Kutt scaled down, so it does not initialize the new database:

   ```console
   helm upgrade <release> christianhuth/kutt --version 10.0.0 -f values.yaml --set replicaCount=0 --wait
   kubectl wait --for=condition=Ready cluster/<release>-postgresql --timeout=10m
   ```

3. Restore the dump as the database owner. Use the Secret from `postgresql.cluster.initdb.secret.name` or the generated `<release>-postgresql-app`:

   ```console
   PASSWORD=$(kubectl get secret <release>-postgresql-app -o jsonpath='{.data.password}' | base64 -d)
   PRIMARY=$(kubectl get cluster <release>-postgresql -o jsonpath='{.status.currentPrimary}')
   kubectl exec -i $PRIMARY -c postgres -- env PGPASSWORD="$PASSWORD" psql -v ON_ERROR_STOP=1 -h localhost -U kutt -d kutt < kutt.sql
   ```

4. Scale Kutt up again:

   ```console
   helm upgrade <release> christianhuth/kutt --version 10.0.0 -f values.yaml --wait
   ```

5. Once everything works, delete the old PersistentVolumeClaims `data-<release>-postgresql-0` and `redis-data-<release>-redis-master-0`.

### To 8.0.0

This major updates the PostgreSQL subchart to its newest major, 18.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#upgrading) you can find more information about the changes introduced in that version.

It also updates the Redis subchart to its newest major, 24.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) you can find more information about the changes introduced in that version.

### To 7.0.0

This major updates the MariaDB subchart to its newest major, 22.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### To 6.0.0

This major updates the Redis subchart to its newest major, 21.2.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/8.0/00-RELEASENOTES) you can find more information about the changes introduced in that version.

### 5.0.0

This major updates the PostgreSQL subchart to its newest major, 16.4.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1630) you can find more information about the changes introduced in that version.

It also updates the Redis subchart to its newest major, 20.6.4. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-2000) you can find more information about the changes introduced in that version.

### 4.0.0

This major updates the PostgreSQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1400) you can find more information about the changes introduced in that version.

### 3.0.0

This major updates the redis subchart to its newest major, 18.0.4. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-1800) you can find more information about the changes introduced in that version.

### 2.0.0

This major updates the way you define environment variables.

- The section `mail` has been moved to `kutt.mail`
- The section `envSecrets` has been merged into `kutt`:
  - `envSecrets.google` is now `kutt.google`
  - `envSecrets.jwt` is now `kutt.jwt`
  - `envSecrets.recaptcha` is now `kutt.recaptcha`
- The section `env` has been replaced with specific values:
  - `ADMIN_EMAILS` is now `kutt.admin.emails`
  - `CUSTOM_DOMAIN_USE_HTTPS` is now `kutt.domain.customDomainUseHttps`
  - `DEFAULT_DOMAIN` is now `kutt.domain.defaultDomain`
  - `DEFAULT_MAX_STATS_PER_LINK` is now `kutt.config.defaultMaxStatsPerLink`
  - `DISALLOW_ANONYMOUS_LINKS` is now `kutt.config.disallowAnonymousLinks`
  - `DISALLOW_REGISTRATION` is now `kutt.config.disallowRegistration`
  - `LINK_LENGTH` is now `kutt.config.linkLength`
  - `NON_USER_COOLDOWN` is now `kutt.config.nonUserCooldown`
  - `REPORT_EMAIL` is now `kutt.mail.reportEmail`
  - `SITE_NAME` is now `kutt.config.siteName`
  - `USER_LIMIT_PER_DAY` is now `kutt.config.userLimitPerDay`
- You can define additional environment variables using the extraEnv section.

### 1.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

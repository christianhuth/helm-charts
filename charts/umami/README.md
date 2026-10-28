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

- Kubernetes 1.29+
- The [CloudNativePG operator](https://cloudnative-pg.io) if the bundled PostgreSQL database is used (`postgresql.enabled: true`, the default)

### Installing the CloudNativePG operator

The chart bundles a PostgreSQL cluster as a custom resource of the CloudNativePG operator (via the upstream chart [cnpg/cluster](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster)). The operator itself is not part of this chart, as it is installed once per Kubernetes cluster:

```console
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo update
helm upgrade --install cnpg cnpg/cloudnative-pg --namespace cnpg-system --create-namespace --wait
```

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

## Configuring the Database

Umami (since v3) only supports PostgreSQL.

### Bundled PostgreSQL with an existing Secret (recommended)

Create a Secret of type `kubernetes.io/basic-auth` containing the credentials of the database owner. The `username` has to match `postgresql.cluster.initdb.owner`:

```console
kubectl create secret generic umami-database \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=umami \
  --from-literal=password='<password>'
```

```yaml
postgresql:
  cluster:
    initdb:
      database: umami
      owner: umami
      secret:
        name: umami-database
```

Umami receives the password as part of its database URL, so it must only contain URL-safe characters (`A-Z`, `a-z`, `0-9`, `-`, `.`, `_`, `~`). If no Secret is referenced, the operator generates a random password and Umami uses the connection URI from the generated Secret `<release>-postgresql-app`. All other settings of the PostgreSQL cluster (e.g. `postgresql.cluster.instances`, `postgresql.cluster.storage`, backups) are passed to the upstream chart. See its [values](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster#values) for all options.

### External PostgreSQL

```yaml
postgresql:
  enabled: false

externalDatabase:
  hostname: postgresql.example.com
  port: 5432
  database: umami
  username: umami
  existingSecret: umami-database
  existingSecretPasswordKey: password
```

Instead of `externalDatabase.existingSecret` you can set `externalDatabase.password`, which lets the chart create the Secret. As for the bundled database, the password must only contain URL-safe characters. Alternatively, provide the complete database URL (e.g. with additional connection parameters) in a Secret referenced by `database.existingSecret` (key `database.databaseUrlKey`, default `database-url`).

## Two-Factor Authentication

Umami v3 supports two-factor authentication, which requires a 256-bit key to encrypt the secrets of the users:

```console
kubectl create secret generic umami-two-factor --from-literal=two-factor-encryption-key="$(openssl rand -hex 32)"
```

```yaml
umami:
  twoFactor:
    existingSecret: umami-two-factor
```

Keep the key: without it, the two-factor secrets of the users can no longer be decrypted.

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
| database.existingSecret | string | `""` | Name of an existing Secret containing the complete database URL (`postgresql://...`). Takes precedence over `postgresql.*` and `externalDatabase.*`. |
| deploymentStrategy | object | `{}` | Update strategy for the deployment |
| externalDatabase.database | string | `"umami"` | Name of the database to use |
| externalDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user. The password must only contain URL-safe characters. |
| externalDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalDatabase.hostname | string | `""` | Hostname of the external PostgreSQL database. Used if `postgresql.enabled` is false. |
| externalDatabase.password | string | `""` | Password of the user. Ignored if `externalDatabase.existingSecret` is set. Must only contain URL-safe characters. |
| externalDatabase.port | int | `5432` | Port of the external PostgreSQL database |
| externalDatabase.username | string | `"umami"` | Name of the user to use |
| extraEnv | list | `[]` | additional environment variables to be added to the pods. See https://umami.is/docs/environment-variables for a complete list of available variables. Most variables can be set under umami as well. |
| fullnameOverride | string | `""` | String to fully override `"umami.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"ghcr.io"` | image registry |
| image.repository | string | `"umami-software/umami"` | image repository |
| image.tag | string | `"3.4.1"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| ingress.enabled | bool | `false` | Enable ingress record generation |
| ingress.hosts | list | see [values.yaml](./values.yaml) | An array with hosts and paths |
| ingress.tls | list | `[]` | An array with the tls configuration |
| initContainers | object | `{}` | define additional init containers |
| livenessProbe.failureThreshold | int | `3` | Failure threshold for livenessProbe |
| livenessProbe.httpGet.path | string | `"/"` | Path for livenessProbe |
| livenessProbe.initialDelaySeconds | int | `15` | Initial delay seconds for livenessProbe |
| livenessProbe.periodSeconds | int | `10` | Period seconds for livenessProbe |
| livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| livenessProbe.timeoutSeconds | int | `1` | Timeout seconds for livenessProbe |
| nameOverride | string | `""` | Provide a name in place of `umami` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podLabels | object | `{}` | Labels to be added to pods |
| podSecurityContext | object | `{}` | pod-level security context |
| postgresql.cluster.imageName | string | `"ghcr.io/cloudnative-pg/postgresql:18-standard-trixie"` | PostgreSQL image. The tag only pins the major version, so restarted instances get the latest minor version. |
| postgresql.cluster.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest minor version of the major version |
| postgresql.cluster.initdb.database | string | `"umami"` | Name of the database to create |
| postgresql.cluster.initdb.owner | string | `"umami"` | Name of the user owning the database |
| postgresql.cluster.instances | int | `3` | Number of PostgreSQL instances (one primary, the others are replicas) |
| postgresql.cluster.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| postgresql.enabled | bool | `true` | Enable a PostgreSQL cluster managed by the CloudNativePG operator. Requires the operator to be installed in the cluster (see README). |
| postgresql.version.postgresql | string | `"18"` | PostgreSQL major version. Has to match the major version of `postgresql.cluster.imageName`. |
| readinessProbe.failureThreshold | int | `3` | Failure threshold for readinessProbe |
| readinessProbe.httpGet.path | string | `"/"` | Path for readinessProbe |
| readinessProbe.initialDelaySeconds | int | `15` | Initial delay seconds for readinessProbe |
| readinessProbe.periodSeconds | int | `10` | Period seconds for readinessProbe |
| readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| readinessProbe.timeoutSeconds | int | `1` | Timeout seconds for readinessProbe |
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
| securityContext | object | `{"runAsGroup":65533,"runAsNonRoot":true,"runAsUser":1001}` | container-level security context |
| service.port | int | `3000` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe.failureThreshold | int | `30` | Failure threshold for startupProbe |
| startupProbe.httpGet.path | string | `"/"` | Path for startupProbe |
| startupProbe.initialDelaySeconds | int | `30` | Initial delay seconds for startupProbe |
| startupProbe.periodSeconds | int | `10` | Period seconds for startupProbe |
| startupProbe.successThreshold | int | `1` | Success threshold for startupProbe |
| startupProbe.timeoutSeconds | int | `1` | Timeout seconds for startupProbe |
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
| umami.debug | string | `""` | Console logging for specific areas of the application (`DEBUG`). Values include `umami:auth`, `umami:clickhouse`, `umami:kafka`, `umami:middleware`, and `umami:prisma`. |
| umami.disableBotCheck | string | `"1"` | By default bots are excluded from statistics. This disables checking for bots. |
| umami.disableLogin | string | `"1"` | Disables the login page for the application |
| umami.disableTelemetry | string | `"1"` | Umami collects completely anonymous telemetry data in order help improve the application. You can choose to disable this if you don't want to participate. |
| umami.disableUpdates | string | `"1"` | Disables the check for new versions of Umami |
| umami.enableTestConsole | string | `"0"` | Set to "1" to enable the internal test page, {host}/console. Admin access is required. Users can manually fire pageviews and events to their websites. |
| umami.forceSSL | string | `"1"` | This will redirect all requests from http to https in the Umami application. Note, this does not apply to the tracking script. |
| umami.hostname | string | `"0.0.0.0"` | hostname under which Umami will be reached |
| umami.ignoredIpAddresses | string | `""` | You can provide a comma-delimited list of IP address to exclude from data collection. |
| umami.linksUrl | string | `""` | URL of the links feature (short links), e.g. https://links.example.com |
| umami.logQuery | string | `"1"` | If you are running in development mode, this will log database queries to the console for debugging. |
| umami.mcpEnabled | string | `""` | Set to "1" to enable the MCP endpoint (`/mcp`) for AI assistants |
| umami.pixelsUrl | string | `""` | URL of the pixels feature (tracking pixels), e.g. https://pixels.example.com |
| umami.removeDisableLoginEnv | bool | `true` | setting this to true removes the environment variable DISABLE_LOGIN defined in `umami.disableLogin` from the deployment as this caused errors in some setups |
| umami.removeTrailingSlash | string | `"1"` | Removes the trailing slash from all incoming urls. |
| umami.saltRotation | string | `""` | Rotation period of the salt used to anonymize sessions, e.g. `day` or `month`. Defaults to `month`. |
| umami.trackerScriptName | string | `"umami"` | Allows you to assign a custom name to the tracker script different from the default umami. This is to help you avoid some ad-blockers. |
| umami.twoFactor.encryptionKey | string | `""` | 64 hexadecimal characters (256-bit key) to encrypt the two-factor authentication secrets, e.g. generated with `openssl rand -hex 32`. Two-factor authentication is unavailable without a key. Ignored if `umami.twoFactor.existingSecret` is set. |
| umami.twoFactor.existingSecret | string | `""` | Name of an existing Secret containing the key |
| umami.twoFactor.existingSecretKey | string | `"two-factor-encryption-key"` | Key in the existing Secret containing the key |
| umami.useUuidV7 | string | `""` | Set to "1" to use UUIDv7 instead of UUIDv4 for new IDs |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/umami
```

## Upgrading the Chart

### To 8.0.0

This major updates Umami to v3 and replaces the Bitnami PostgreSQL subchart with a PostgreSQL cluster managed by the [CloudNativePG operator](https://cloudnative-pg.io). Install the operator first (see [Prerequisites](#prerequisites)). Read the [release notes of Umami v3](https://github.com/umami-software/umami/releases/tag/v3.0.0) as well.

- **Umami v3 only supports PostgreSQL.** MySQL support (`mysql.*`, `externalDatabase.type`) is removed. If you use MySQL, migrate your data to PostgreSQL with the [official guide](https://umami.is/docs/guides/migrate-mysql-postgresql) before upgrading.
- `postgresql.auth.*` is replaced by the values of the upstream chart [cnpg/cluster](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster), e.g. `postgresql.cluster.initdb.database` and `postgresql.cluster.initdb.owner`. An inline password for the bundled database is no longer supported. Use an existing Secret or let the operator generate one (see [Configuring the Database](#configuring-the-database))
- `externalDatabase.auth.*` moved one level up, and the password is read from a Secret (`externalDatabase.existingSecret` or a Secret created from `externalDatabase.password`)
- the job migrating from Umami v1 to v2 (`umami.migration.v1v2`) and `umami.ignoreHostname` (never read by Umami) are removed
- `umami.debug` and `umami.enableTestConsole` are now passed to Umami. `umami.enableTestConsole` defaults to `"0"`, set it to `"1"` to enable the test console
- new settings of Umami v3: `umami.twoFactor`, `umami.saltRotation`, `umami.useUuidV7`, `umami.mcpEnabled`, `umami.linksUrl` and `umami.pixelsUrl`

Umami migrates the database schema from v2 to v3 on startup. If you use the bundled PostgreSQL, the upgrade creates a new, empty database. The Bitnami StatefulSet is removed, but its PersistentVolumeClaim `data-<release>-postgresql-0` is kept. To take your data along:

1. Dump the database before upgrading:

   ```console
   kubectl exec <release>-postgresql-0 -- sh -c 'PGPASSWORD="$(cat "$POSTGRES_PASSWORD_FILE")" pg_dump --no-owner --no-acl -U "$POSTGRES_USER" -d "$POSTGRES_DATABASE"' > umami.sql
   ```

2. Upgrade the chart with Umami scaled down, so it does not initialize the new database:

   ```console
   helm upgrade <release> christianhuth/umami --version 8.0.0 -f values.yaml --set replicaCount=0 --wait
   kubectl wait --for=condition=Ready cluster/<release>-postgresql --timeout=10m
   ```

3. Restore the dump as the database owner. Use the Secret from `postgresql.cluster.initdb.secret.name` or the generated `<release>-postgresql-app`:

   ```console
   PASSWORD=$(kubectl get secret <release>-postgresql-app -o jsonpath='{.data.password}' | base64 -d)
   PRIMARY=$(kubectl get cluster <release>-postgresql -o jsonpath='{.status.currentPrimary}')
   kubectl exec -i $PRIMARY -c postgres -- env PGPASSWORD="$PASSWORD" psql -v ON_ERROR_STOP=1 -h localhost -U umami -d umami < umami.sql
   ```

4. Scale Umami up again. It applies the v3 migrations to the restored v2 database on startup:

   ```console
   helm upgrade <release> christianhuth/umami --version 8.0.0 -f values.yaml --wait
   ```

5. Once everything works, delete the old PersistentVolumeClaim `data-<release>-postgresql-0`.

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

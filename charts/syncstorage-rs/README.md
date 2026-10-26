# syncstorage-rs

A Helm chart for deploying Mozilla's Firefox Sync Storage server to Kubernetes

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/syncstorage-rs \
  --set syncstorage.masterKey.value='<random secret>' \
  --set syncstorage.config.publicUrl=https://sync.example.com
```

## Introduction

This chart bootstraps the [Mozilla Firefox Sync Storage server](https://github.com/mozilla-services/syncstorage-rs) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It uses the official images of Mozilla, one per database type: [syncserver-mysql](https://github.com/mozilla-services/syncstorage-rs/pkgs/container/syncstorage-rs%2Fsyncserver-mysql) for MariaDB and MySQL (the default) and [syncserver-postgres](https://github.com/mozilla-services/syncstorage-rs/pkgs/container/syncstorage-rs%2Fsyncserver-postgres) for PostgreSQL. Both images are only available for `linux/amd64`.

## Prerequisites

- Kubernetes 1.26+
- The [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator) if the bundled MariaDB databases are used (`syncserver-db.enabled` and `tokenserver-db.enabled`, the default)
- The [CloudNativePG operator](https://cloudnative-pg.io) if the bundled PostgreSQL database is used (`postgresql.enabled: true`)

### Installing the mariadb-operator

The chart bundles the Syncserver and the Tokenserver database as custom resources of the mariadb-operator (via the upstream chart [mariadb-cluster](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster)). The operator itself is not part of this chart, as it is installed once per Kubernetes cluster:

```console
helm upgrade --install mariadb-operator-crds oci://ghcr.io/mariadb-operator/charts/mariadb-operator-crds --namespace mariadb-operator --create-namespace
helm upgrade --install mariadb-operator oci://ghcr.io/mariadb-operator/charts/mariadb-operator --namespace mariadb-operator --wait
```

### Installing the CloudNativePG operator

With `postgresql.enabled: true` the chart bundles a PostgreSQL cluster as a custom resource of the CloudNativePG operator (via the upstream chart [cnpg/cluster](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster)). The operator itself is not part of this chart, as it is installed once per Kubernetes cluster:

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
helm install my-release christianhuth/syncstorage-rs \
  --set syncstorage.masterKey.value='<random secret>' \
  --set syncstorage.config.publicUrl=https://sync.example.com
```

These commands deploy the Mozilla Firefox Sync Storage server on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuring the Sync Server

### Master key

syncstorage-rs derives the secrets signing its tokens from the master key, so the chart requires one. Instead of `syncstorage.masterKey.value` you can reference an existing Secret with the key `master-key`:

```console
kubectl create secret generic syncstorage-master-key \
  --from-literal=master-key="$(openssl rand -hex 32)"
```

```yaml
syncstorage:
  masterKey:
    existingSecret: syncstorage-master-key
```

Changing the master key invalidates the issued tokens, the clients then request new ones.

### Public URL and Firefox

On startup syncstorage-rs registers its public URL as storage node in the Tokenserver database, the clients sync against this URL. The chart takes `syncstorage.config.publicUrl`, or the first host of the Ingress (`https` if it is covered by TLS) or of the HTTPRoute (`https`). It must consist of the scheme and the host only, e.g. `https://sync.example.com`.

To use the server, open `about:config` in Firefox before logging in to your Mozilla account and set `identity.sync.tokenserver.uri` to `https://sync.example.com/1.0/sync/1.5`.

### Limiting the number of users

By default everybody with a Mozilla account can use your server. There are two ways to restrict it:

- `syncstorage.config.allowNewUsers: false` only lets accounts use the server that already synced with it. Leave it enabled until all your accounts synced once.
- `syncstorage.config.nodeCapacity` is the maximum number of accounts the storage node accepts, e.g. `5`. New accounts beyond it are rejected. syncstorage-rs only uses it when it creates the node, so set it before the first start or change it in the Tokenserver database later:

  ```sql
  UPDATE nodes SET capacity = 5, available = GREATEST(5 - current_load, 0) WHERE node = 'https://sync.example.com';
  ```

### Mozilla accounts

By default the Tokenserver verifies the tokens of the clients against the production Mozilla accounts (`syncstorage.config.fxa.emailDomain` and `syncstorage.config.fxa.oauthServerUrl`). Change them only if you run your own Mozilla accounts server. All other settings of syncstorage-rs can be passed as environment variables with `extraEnv`, see the [configuration reference](https://mozilla-services.github.io/syncstorage-rs/config.html).

## Configuring the Databases

syncstorage-rs uses two databases: the Syncserver database (`syncserver-db`) and the Tokenserver database (`tokenserver-db`). Both have to be of the same type, either MariaDB/MySQL or PostgreSQL, matching the image (`image.repository`).

### Bundled MariaDB with an existing Secret (recommended)

By default the chart bundles one MariaDB instance per database. Both are configured the same way, the examples below show the Syncserver database. Create a Secret containing the password of the database user:

```console
kubectl create secret generic syncstorage-syncserver-db \
  --from-literal=password='<password>'
```

Reference the Secret in your values and disable the generation of a password:

```yaml
syncserver-db:
  enabled: true
  mariadb:
    database: syncserver
    username: syncserver
    passwordSecretKeyRef:
      name: syncstorage-syncserver-db
      key: password
      generate: false
```

If no Secret is referenced, the operator generates a random password and stores it in the Secret `<release>-syncserver-db-password`. The connection URL used by syncstorage-rs is created by the operator in the Secret `<release>-syncserver-db` (key `database-url`), with the password URL-encoded.

### Updating MariaDB

The image tags only pin the MariaDB release series (by default the long-term support release 12.3), so restarted instances get the latest patch version of the series. To upgrade to another release series (e.g. the next long-term support release), change the tag of `<db>.mariadb.image`. The operator rolls out the instances one by one and migrates the system schema (`updateStrategy.mariadbAutoUpgradeEnabled`). Downgrades to a previous release series are not supported by MariaDB, so take a backup before upgrading.

By default each database runs as a Galera cluster with 3 instances. All other settings (e.g. `mariadb.replicas`, `mariadb.storage`, backups) are passed to the upstream chart. See its [values](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster) and the [MariaDB API reference](https://github.com/mariadb-operator/mariadb-operator/blob/main/docs/api_reference.md#mariadbspec) for all options.

### Bundled PostgreSQL

The bundled PostgreSQL cluster hosts one database used by the Syncserver and the Tokenserver, like the setup of Mozilla. Disable the MariaDB instances and switch to the PostgreSQL image:

```yaml
image:
  repository: mozilla-services/syncstorage-rs/syncserver-postgres

syncserver-db:
  enabled: false

tokenserver-db:
  enabled: false

postgresql:
  enabled: true
```

If no Secret is referenced, the operator generates the credentials of the database owner in the Secret `<release>-postgresql-app`. To use an existing Secret, create it with the type `kubernetes.io/basic-auth`. The `username` has to match `postgresql.cluster.initdb.owner`:

```console
kubectl create secret generic syncstorage-database \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=syncserver \
  --from-literal=password='<password>'
```

```yaml
postgresql:
  enabled: true
  cluster:
    initdb:
      database: syncserver
      owner: syncserver
      secret:
        name: syncstorage-database
```

syncstorage-rs receives the password as part of its database URLs, so it must only contain URL-safe characters (`A-Z`, `a-z`, `0-9`, `-`, `.`, `_`, `~`). The image tag of `postgresql.cluster.imageName` only pins the major version, so restarted instances get the latest minor version. All other settings of the PostgreSQL cluster (e.g. `postgresql.cluster.instances`, `postgresql.cluster.storage`, backups) are passed to the upstream chart. See its [values](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster#values) for all options.

### External databases

```yaml
syncserver-db:
  enabled: false

externalSyncserverDatabase:
  type: mysql
  hostname: mariadb.example.com
  port: 3306
  database: syncserver
  username: syncserver
  existingSecret: syncstorage-syncserver-db
  existingSecretPasswordKey: password
```

The Tokenserver database is configured the same way with `tokenserver-db` and `externalTokenserverDatabase`. For PostgreSQL set `type: postgres` on both and use the image `mozilla-services/syncstorage-rs/syncserver-postgres`, both may point to the same database. Instead of `existingSecret` you can set `password`, which lets the chart create the Secret. As the connection URL is assembled from the password, it must only contain URL-safe characters (`A-Z`, `a-z`, `0-9`, `-`, `.`, `_`, `~`).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| externalSyncserverDatabase.database | string | `"syncserver"` | Name of the database to use |
| externalSyncserverDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user. The password must only contain URL-safe characters. |
| externalSyncserverDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password of the user |
| externalSyncserverDatabase.hostname | string | `""` | Hostname of the external Syncserver database. Used if neither `syncserver-db.enabled` nor `postgresql.enabled` is true. |
| externalSyncserverDatabase.password | string | `""` | Password of the user. Ignored if `externalSyncserverDatabase.existingSecret` is set. Must only contain URL-safe characters. |
| externalSyncserverDatabase.port | string | `""` | Port of the external Syncserver database. Defaults to 3306 for `mysql` and 5432 for `postgres`. |
| externalSyncserverDatabase.type | string | `"mysql"` | Type of the external Syncserver database: `mysql` (MariaDB or MySQL) or `postgres`. Has to match the type of the Tokenserver database and the image. |
| externalSyncserverDatabase.username | string | `"syncserver"` | Name of the user to use |
| externalTokenserverDatabase.database | string | `"tokenserver"` | Name of the database to use |
| externalTokenserverDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user. The password must only contain URL-safe characters. |
| externalTokenserverDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password of the user |
| externalTokenserverDatabase.hostname | string | `""` | Hostname of the external Tokenserver database. Used if neither `tokenserver-db.enabled` nor `postgresql.enabled` is true. It may be the same database as the Syncserver database. |
| externalTokenserverDatabase.password | string | `""` | Password of the user. Ignored if `externalTokenserverDatabase.existingSecret` is set. Must only contain URL-safe characters. |
| externalTokenserverDatabase.port | string | `""` | Port of the external Tokenserver database. Defaults to 3306 for `mysql` and 5432 for `postgres`. |
| externalTokenserverDatabase.type | string | `"mysql"` | Type of the external Tokenserver database: `mysql` (MariaDB or MySQL) or `postgres`. Has to match the type of the Syncserver database and the image. |
| externalTokenserverDatabase.username | string | `"tokenserver"` | Name of the user to use |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"syncstorage-rs.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"ghcr.io"` | image registry |
| image.repository | string | `"mozilla-services/syncstorage-rs/syncserver-mysql"` | image repository. Mozilla publishes one image per database type: `mozilla-services/syncstorage-rs/syncserver-mysql` for MariaDB and MySQL, `mozilla-services/syncstorage-rs/syncserver-postgres` for PostgreSQL. Both are only available for `linux/amd64`. |
| image.tag | string | `"0.24.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.enabled | bool | `true` | Enable the livenessProbe. It uses `/__lbheartbeat__`, which does not check the databases. |
| livenessProbe.failureThreshold | int | `6` | Failure threshold for livenessProbe |
| livenessProbe.initialDelaySeconds | int | `10` | Initial delay seconds for livenessProbe |
| livenessProbe.periodSeconds | int | `10` | Period seconds for livenessProbe |
| livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| livenessProbe.timeoutSeconds | int | `2` | Timeout in seconds for livenessProbe |
| nameOverride | string | `""` | Provide a name in place of `syncstorage-rs` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| postgresql.cluster.imageName | string | `"ghcr.io/cloudnative-pg/postgresql:18-standard-trixie"` | PostgreSQL image. The tag only pins the major version, so restarted instances get the latest minor version. |
| postgresql.cluster.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest minor version of the major version |
| postgresql.cluster.initdb.database | string | `"syncserver"` | Name of the database to create |
| postgresql.cluster.initdb.owner | string | `"syncserver"` | Name of the user owning the database |
| postgresql.cluster.instances | int | `3` | Number of PostgreSQL instances (one primary, the others are replicas) |
| postgresql.cluster.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| postgresql.enabled | bool | `false` | Enable a PostgreSQL cluster managed by the CloudNativePG operator for the Syncserver and the Tokenserver database, which share one database (like in the setup of Mozilla). Requires the operator to be installed in the cluster and the image `mozilla-services/syncstorage-rs/syncserver-postgres` (see README). |
| postgresql.version.postgresql | string | `"18"` | PostgreSQL major version. Has to match the major version of `postgresql.cluster.imageName`. |
| readinessProbe.enabled | bool | `true` | Enable the readinessProbe. It uses `/__heartbeat__`, which also checks the databases. |
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
| route.main.timeouts | object | `{}` | defines the timeouts that can be configured for an HTTP request |
| securityContext | object | `{}` | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| syncserver-db.enabled | bool | `true` | Enable a MariaDB instance managed by the mariadb-operator for the Syncserver database. Requires the operator to be installed in the cluster (see README). Disable it if `postgresql.enabled` is true. |
| syncserver-db.mariadb.connection.secretTemplate.format | string | `"mysql://{{ .Username }}:{{ urlquery .Password }}@{{ .Host }}:{{ .Port }}/{{ .Database }}"` | Format of the connection URL used by syncstorage-rs. The password is URL-encoded. |
| syncserver-db.mariadb.connection.secretTemplate.key | string | `"database-url"` | Key of the connection URL inside the Secret `<release>-syncserver-db` generated by the operator |
| syncserver-db.mariadb.database | string | `"syncserver"` | Name of the database to create |
| syncserver-db.mariadb.galera.enabled | bool | `true` | Enable Galera to run multiple instances |
| syncserver-db.mariadb.image | string | `"mariadb:12.3"` | MariaDB image. The tag only pins the release series (12.3 is the current long-term support release), so restarted instances get its latest patch version. |
| syncserver-db.mariadb.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest patch version of the release series |
| syncserver-db.mariadb.passwordSecretKeyRef.generate | bool | `true` | Let the operator generate the Secret with a random password if it does not exist |
| syncserver-db.mariadb.passwordSecretKeyRef.key | string | `"password"` | Key of the password inside the Secret |
| syncserver-db.mariadb.passwordSecretKeyRef.name | string | `""` | Name of an existing Secret containing the password of the user. If empty, the Secret `<release>-syncserver-db-password` is used. |
| syncserver-db.mariadb.replicas | int | `3` | Number of MariaDB instances. More than one instance requires Galera or replication. |
| syncserver-db.mariadb.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| syncserver-db.mariadb.updateStrategy.mariadbAutoUpgradeEnabled | bool | `true` | Run `mariadb-upgrade` on start, so that changing the release series in `image` migrates the system schema. It is a no-op if there is nothing to migrate. |
| syncserver-db.mariadb.username | string | `"syncserver"` | Name of the user to create |
| syncstorage.config.allowNewUsers | bool | `true` | Allow new accounts to register. When disabled, only accounts that already synced with this server can use it. |
| syncstorage.config.fxa.emailDomain | string | `"api.accounts.firefox.com"` | Email domain of the Mozilla accounts environment the clients log in to |
| syncstorage.config.fxa.oauthServerUrl | string | `"https://oauth.accounts.firefox.com"` | OAuth server of the Mozilla accounts environment, used to verify the tokens of the clients |
| syncstorage.config.host | string | `"0.0.0.0"` | host to listen for connections |
| syncstorage.config.logLevel | string | `"info"` | The minimum Rust error logging level. Valid values: debug, info, warn, error. |
| syncstorage.config.nodeCapacity | int | `100000` | Maximum number of accounts the storage node (`publicUrl`) accepts. Only used when syncstorage-rs creates the node, see [Limiting the number of users](#limiting-the-number-of-users). |
| syncstorage.config.port | int | `8000` | connection port |
| syncstorage.config.publicUrl | string | `""` | Public URL of the sync server, scheme and host (e.g. `https://sync.example.com`). syncstorage-rs registers it as storage node in the Tokenserver database on startup and the clients sync against it. Defaults to the first host of the Ingress (`https` if it has TLS) or of the HTTPRoute (`https`). |
| syncstorage.config.runTokenserverDbMigrations | bool | `true` | run migrations for the tokenserver database |
| syncstorage.masterKey.existingSecret | string | `""` | Use existing secret for the sync master key (`syncstorage.masterKey.value` will be ignored and picked up from this secret). The secret has to contain the key `master-key`. |
| syncstorage.masterKey.value | string | `""` | The sync master key value. Required if `syncstorage.masterKey.existingSecret` is not set. |
| tokenserver-db.enabled | bool | `true` | Enable a MariaDB instance managed by the mariadb-operator for the Tokenserver database. Requires the operator to be installed in the cluster (see README). Disable it if `postgresql.enabled` is true. |
| tokenserver-db.mariadb.connection.secretTemplate.format | string | `"mysql://{{ .Username }}:{{ urlquery .Password }}@{{ .Host }}:{{ .Port }}/{{ .Database }}"` | Format of the connection URL used by syncstorage-rs. The password is URL-encoded. |
| tokenserver-db.mariadb.connection.secretTemplate.key | string | `"database-url"` | Key of the connection URL inside the Secret `<release>-tokenserver-db` generated by the operator |
| tokenserver-db.mariadb.database | string | `"tokenserver"` | Name of the database to create |
| tokenserver-db.mariadb.galera.enabled | bool | `true` | Enable Galera to run multiple instances |
| tokenserver-db.mariadb.image | string | `"mariadb:12.3"` | MariaDB image. The tag only pins the release series (12.3 is the current long-term support release), so restarted instances get its latest patch version. |
| tokenserver-db.mariadb.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest patch version of the release series |
| tokenserver-db.mariadb.passwordSecretKeyRef.generate | bool | `true` | Let the operator generate the Secret with a random password if it does not exist |
| tokenserver-db.mariadb.passwordSecretKeyRef.key | string | `"password"` | Key of the password inside the Secret |
| tokenserver-db.mariadb.passwordSecretKeyRef.name | string | `""` | Name of an existing Secret containing the password of the user. If empty, the Secret `<release>-tokenserver-db-password` is used. |
| tokenserver-db.mariadb.replicas | int | `3` | Number of MariaDB instances. More than one instance requires Galera or replication. |
| tokenserver-db.mariadb.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| tokenserver-db.mariadb.updateStrategy.mariadbAutoUpgradeEnabled | bool | `true` | Run `mariadb-upgrade` on start, so that changing the release series in `image` migrates the system schema. It is a no-op if there is nothing to migrate. |
| tokenserver-db.mariadb.username | string | `"tokenserver"` | Name of the user to create |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/syncstorage-rs
```

## Upgrading the Chart

### 8.0.0

This major replaces the image `porelli/firefox-sync` with the official images of Mozilla and updates syncstorage-rs from 0.18.2 to 0.24.0. The official images are only available for `linux/amd64`, stay on 7.x if your nodes are `arm64`. The values changed as follows:

- `image.repository` is `mozilla-services/syncstorage-rs/syncserver-mysql` (`image.registry` stays `ghcr.io`)
- `syncstorage.masterKey.value` or `syncstorage.masterKey.existingSecret` is required. syncstorage-rs signed its tokens with an empty secret before, if you didn't set one
- `syncstorage.tokenserver-db-lock` is removed, as its init image only exists for `porelli/firefox-sync`. syncstorage-rs now creates the storage node itself from `syncstorage.config.publicUrl` (defaults to the host of the Ingress or HTTPRoute). To limit the number of users, use `syncstorage.config.nodeCapacity` or `syncstorage.config.allowNewUsers` (see [Limiting the number of users](#limiting-the-number-of-users))
- the Tokenserver verifies the tokens against the production Mozilla accounts (`syncstorage.config.fxa.*`). Remove `SYNC_TOKENSERVER__FXA_EMAIL_DOMAIN` and `SYNC_TOKENSERVER__FXA_OAUTH_SERVER_URL` from `extraEnv` if you set them there
- `externalSyncserverDatabase.port` and `externalTokenserverDatabase.port` default to the port of the new `type` (`mysql` or `postgres`)
- new: the bundled PostgreSQL database (`postgresql.*`), see [Bundled PostgreSQL](#bundled-postgresql)

The databases are kept and migrated by syncstorage-rs on startup, but the Tokenserver database needs a cleanup:

- the init container of 7.x registered the storage node with the bare host (without scheme), which the clients can't use, and installed a trigger limiting the number of users. syncstorage-rs now registers the node with `syncstorage.config.publicUrl` next to it, so the accounts have to be moved to the new node and the trigger has to be removed
- 7.x stored the accounts with the email domain of the stage Mozilla accounts (`api-accounts.stage.mozaws.net`). As the Tokenserver looks up the accounts by it, they have to be renamed to the production domain to keep their data. Skip this statement if you use the stage environment on purpose

Upgrade and clean up the database:

1. Upgrade the chart:

   ```console
   helm upgrade <release> christianhuth/syncstorage-rs --version 8.0.0 -f values.yaml --wait
   ```

2. Clean up the Tokenserver database. Replace `https://sync.example.com` with your public URL, and use the Secret from `tokenserver-db.mariadb.passwordSecretKeyRef` or the generated `<release>-tokenserver-db-password`:

   ```console
   PASSWORD=$(kubectl get secret <release>-tokenserver-db-password -o jsonpath='{.data.password}' | base64 -d)
   kubectl exec -i <release>-tokenserver-db-0 -c mariadb -- mariadb -u tokenserver --password="$PASSWORD" tokenserver <<'EOF'
   SET @node = 'https://sync.example.com';
   DROP TRIGGER IF EXISTS BeforeInsertUser;
   DROP PROCEDURE IF EXISTS CheckUserLimit;
   UPDATE users SET email = REPLACE(email, '@api-accounts.stage.mozaws.net', '@api.accounts.firefox.com') WHERE email LIKE '%@api-accounts.stage.mozaws.net';
   UPDATE users u JOIN nodes n ON n.service = u.service AND n.node = @node SET u.nodeid = n.id WHERE u.nodeid <> n.id;
   UPDATE nodes SET available = 0, downed = 1 WHERE node <> @node;
   UPDATE nodes n SET n.current_load = (SELECT COUNT(DISTINCT u.email) FROM users u WHERE u.nodeid = n.id), n.available = GREATEST(n.capacity - n.current_load, 0) WHERE n.node = @node;
   EOF
   ```

   The clients get the new node with their next token, at the latest after an hour.

To switch to PostgreSQL instead, configure the bundled PostgreSQL database (see [Bundled PostgreSQL](#bundled-postgresql)) in the same upgrade. The Sync data is not migrated: the new databases start empty and Firefox uploads the data of each device again on its next sync. Once everything works, delete the PersistentVolumeClaims of the MariaDB instances (`storage-<release>-syncserver-db-*` and `storage-<release>-tokenserver-db-*`).

### 7.0.0

This major replaces the Bitnami MariaDB subcharts with MariaDB instances managed by the [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator). Install the operator first (see [Prerequisites](#prerequisites)). The values changed as follows:

- `syncserver-db.auth.*` and `tokenserver-db.auth.*` are replaced by the values of the upstream chart [mariadb-cluster](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster), e.g. `syncserver-db.mariadb.database` and `syncserver-db.mariadb.username`
- an inline password for the bundled databases is no longer supported. Use an existing Secret or let the operator generate one (see [Configuring the Databases](#configuring-the-databases))
- `syncstorage.syncserver-db.*` and `syncstorage.tokenserver-db.*` are replaced by `externalSyncserverDatabase.*` and `externalTokenserverDatabase.*`. `existingSecret` now contains the password (key `existingSecretPasswordKey`) instead of the connection URL

The upgrade creates new, empty databases. The Bitnami StatefulSets are removed, but their PersistentVolumeClaims `data-<release>-syncserver-db-0` and `data-<release>-tokenserver-db-0` are kept. To take your data along:

1. Dump both databases before upgrading:

   ```console
   for db in syncserver tokenserver; do
     kubectl exec <release>-$db-db-0 -- sh -c 'mariadb-dump -u"$MARIADB_USER" -p"$(cat "$MARIADB_PASSWORD_FILE")" "$MARIADB_DATABASE"' > $db.sql
   done
   ```

2. Upgrade the chart with the application scaled down, so it does not initialize the new databases. Then wait until the operator has created the databases and users, which happens after the MariaDB instances are ready:

   ```console
   helm upgrade <release> christianhuth/syncstorage-rs --version 7.0.0 -f values.yaml --set replicaCount=0 --wait
   kubectl wait --for=create connection/<release>-syncserver-db --timeout=10m
   kubectl wait --for=create connection/<release>-tokenserver-db --timeout=10m
   kubectl wait --for=condition=Ready connection/<release>-syncserver-db connection/<release>-tokenserver-db --timeout=10m
   ```

3. Restore the dumps. Use the Secrets from `<db>.mariadb.passwordSecretKeyRef` or the generated `<release>-<db>-db-password`:

   ```console
   for db in syncserver tokenserver; do
     PASSWORD=$(kubectl get secret <release>-$db-db-password -o jsonpath='{.data.password}' | base64 -d)
     kubectl exec -i <release>-$db-db-0 -c mariadb -- mariadb -u $db --password="$PASSWORD" $db < $db.sql
   done
   ```

4. Scale the application up again:

   ```console
   helm upgrade <release> christianhuth/syncstorage-rs --version 7.0.0 -f values.yaml --wait
   ```

5. Once everything works, delete the old PersistentVolumeClaims `data-<release>-syncserver-db-0` and `data-<release>-tokenserver-db-0`.

### 6.0.0

This major updates the MariaDB subchart to its newest major, 26.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### 4.0.0

This major updates the MariaDB subchart to its newest major, 24.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the MariaDB subchart to its newest major, 22.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the MariaDB subchart to its newest major, 21.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

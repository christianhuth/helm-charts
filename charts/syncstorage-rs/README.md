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

- Kubernetes 1.26+
- The [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator) if the bundled MariaDB databases are used (`syncserver-db.enabled` and `tokenserver-db.enabled`, the default)

### Installing the mariadb-operator

The chart bundles the Syncserver and the Tokenserver database as custom resources of the mariadb-operator (via the upstream chart [mariadb-cluster](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster)). The operator itself is not part of this chart, as it is installed once per Kubernetes cluster:

```console
helm repo add mariadb-operator https://helm.mariadb.com/mariadb-operator
helm repo update
helm upgrade --install mariadb-operator-crds mariadb-operator/mariadb-operator-crds --namespace mariadb-operator --create-namespace
helm upgrade --install mariadb-operator mariadb-operator/mariadb-operator --namespace mariadb-operator --wait
```

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

## Configuring the Databases

syncstorage-rs uses two databases: the Syncserver database (`syncserver-db`) and the Tokenserver database (`tokenserver-db`). Both are configured the same way, the examples below show the Syncserver database.

### Bundled MariaDB with an existing Secret (recommended)

Create a Secret containing the password of the database user:

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

### Further settings

By default each database runs as a Galera cluster with 3 instances. All other settings (e.g. `mariadb.replicas`, `mariadb.storage`, backups) are passed to the upstream chart. See its [values](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster) and the [MariaDB API reference](https://github.com/mariadb-operator/mariadb-operator/blob/main/docs/api_reference.md#mariadbspec) for all options.

### External MariaDB or MySQL

```yaml
syncserver-db:
  enabled: false

externalSyncserverDatabase:
  hostname: mariadb.example.com
  port: 3306
  database: syncserver
  username: syncserver
  existingSecret: syncstorage-syncserver-db
  existingSecretPasswordKey: password
```

Instead of `existingSecret` you can set `password`, which lets the chart create the Secret. As the connection URL is assembled from the password, it must only contain URL-safe characters (`A-Z`, `a-z`, `0-9`, `-`, `.`, `_`, `~`).

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
| externalSyncserverDatabase.hostname | string | `""` | Hostname of the external Syncserver database. Used if `syncserver-db.enabled` is false. |
| externalSyncserverDatabase.password | string | `""` | Password of the user. Ignored if `externalSyncserverDatabase.existingSecret` is set. Must only contain URL-safe characters. |
| externalSyncserverDatabase.port | int | `3306` | Port of the external Syncserver database |
| externalSyncserverDatabase.username | string | `"syncserver"` | Name of the user to use |
| externalTokenserverDatabase.database | string | `"tokenserver"` | Name of the database to use |
| externalTokenserverDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user. The password must only contain URL-safe characters. |
| externalTokenserverDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password of the user |
| externalTokenserverDatabase.hostname | string | `""` | Hostname of the external Tokenserver database. Used if `tokenserver-db.enabled` is false. |
| externalTokenserverDatabase.password | string | `""` | Password of the user. Ignored if `externalTokenserverDatabase.existingSecret` is set. Must only contain URL-safe characters. |
| externalTokenserverDatabase.port | int | `3306` | Port of the external Tokenserver database |
| externalTokenserverDatabase.username | string | `"tokenserver"` | Name of the user to use |
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
| route.main.timeouts | object | `{}` | defines the timeouts that can be configured for an HTTP request |
| securityContext | object | `{}` | container-level security context |
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| syncserver-db.enabled | bool | `true` | Enable a MariaDB instance managed by the mariadb-operator for the Syncserver database. Requires the operator to be installed in the cluster (see README). |
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
| syncstorage.config.host | string | `"0.0.0.0"` | host to listen for connections |
| syncstorage.config.logLevel | string | `"info"` | The minimum Rust error logging level. Valid values: debug, info, warn, error. |
| syncstorage.config.port | int | `8000` | connection port |
| syncstorage.config.runTokenserverDbMigrations | bool | `true` | run migrations for the tokenserver database |
| syncstorage.masterKey.existingSecret | string | `""` | Use existing secret for the sync master key (`syncstorage.masterKey.value` will be ignored and picked up from this secret). The secret has to contain the key `master-key`. |
| syncstorage.masterKey.value | string | `""` | The sync master key value |
| syncstorage.tokenserver-db-lock.config.maxUsers | int | `1` | maximum number of users that are allowed to user your server |
| syncstorage.tokenserver-db-lock.enabled | bool | `false` | enable an init container that locks the tokenserver db from accepting new users if the maximum number of users are registered already |
| syncstorage.tokenserver-db-lock.image.pullPolicy | string | `"Always"` | image pull policy |
| syncstorage.tokenserver-db-lock.image.registry | string | `"ghcr.io"` | image registry |
| syncstorage.tokenserver-db-lock.image.repository | string | `"porelli/firefox-sync"` | image repository |
| syncstorage.tokenserver-db-lock.image.tag | string | `"syncstorage-rs-mysql-init-0.18.2"` | Overrides the image tag |
| tokenserver-db.enabled | bool | `true` | Enable a MariaDB instance managed by the mariadb-operator for the Tokenserver database. Requires the operator to be installed in the cluster (see README). |
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
   kubectl wait --for=create connection/<release>-syncserver-db connection/<release>-tokenserver-db --timeout=10m
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

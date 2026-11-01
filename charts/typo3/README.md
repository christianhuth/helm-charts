# typo3

TYPO3 — the Professional, Flexible Content Management System

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/typo3
```

## Introduction

This chart bootstraps the Content Management System [TYPO3](https://github.com/TYPO3/typo3) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.26+
- The [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator) if the bundled MariaDB database is used (`mariadb.enabled: true`, the default)

### Installing the mariadb-operator

The chart bundles the database as a custom resource of the mariadb-operator (via the upstream chart [mariadb-cluster](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster)). The operator itself is not part of this chart, as it is installed once per Kubernetes cluster:

```console
helm upgrade --install mariadb-operator-crds oci://ghcr.io/mariadb-operator/charts/mariadb-operator-crds --namespace mariadb-operator --create-namespace
helm upgrade --install mariadb-operator oci://ghcr.io/mariadb-operator/charts/mariadb-operator --namespace mariadb-operator --wait
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/typo3
```

These commands deploy typo3 on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuring TYPO3

The chart uses the [crinis/typo3](https://github.com/crinis/typo3-docker) image for non-Composer ("legacy") TYPO3 projects, which ships the TYPO3 sources. TYPO3 runs rootless as `www-data` and listens on port 8080.

On the first start, i.e. if `typo3conf/system/settings.php` does not exist yet, TYPO3 is set up automatically with the database and the admin user configured in the values (`typo3.setup`, `typo3.admin`). Use `typo3.setup.createSite` to create a site for a given URL during the setup. On every start, an init container updates the database connection in `typo3conf/system/settings.php` from the values (`typo3.modifyConfiguration`), so changing the database or its password needs no manual change of the TYPO3 configuration. The admin password has to satisfy the password policy of TYPO3, a random one is generated if none is given:

```console
kubectl create secret generic typo3-admin --from-literal=password='<password>'
```

```yaml
typo3:
  admin:
    username: admin
    email: admin@example.com
    existingSecret: typo3-admin
```

Set `typo3.scheduler.enabled` to run the TYPO3 scheduler every five minutes in a sidecar container. Uploaded files (`fileadmin`) and the configuration including extensions (`typo3conf`) are persisted in PersistentVolumeClaims (`persistence.*`).

## Configuring the Database

The image supports MariaDB and MySQL.

### Bundled MariaDB with an existing Secret (recommended)

```console
kubectl create secret generic typo3-database --from-literal=password='<password>'
```

```yaml
mariadb:
  mariadb:
    passwordSecretKeyRef:
      name: typo3-database
      key: password
      generate: false
```

If no Secret is referenced, the operator generates a random password and stores it in the Secret `<release>-mariadb-password`. By default the database runs as a Galera cluster with 3 instances. To upgrade to another MariaDB release series, change the tag of `mariadb.mariadb.image`; the operator migrates the system schema, but downgrades are not supported. See the [values](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster) of the upstream chart for all options.

### External MariaDB or MySQL

```yaml
mariadb:
  enabled: false

externalDatabase:
  hostname: mariadb.example.com
  port: 3306
  database: typo3
  username: typo3
  existingSecret: typo3-database
  existingSecretPasswordKey: password
```

Instead of `externalDatabase.existingSecret` you can set `externalDatabase.password`, which lets the chart create the Secret.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| deploymentStrategy | object | `{}` | Update strategy for the deployment. Set `type: Recreate` if the persistence uses `ReadWriteOnce` volumes, as a rolling update starts the new Pod before stopping the old one and it can't mount the volume on another node. |
| externalDatabase.database | string | `"typo3"` | Name of the database to use |
| externalDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user |
| externalDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalDatabase.hostname | string | `""` | Hostname of the external MariaDB or MySQL database. Used if `mariadb.enabled` is false. |
| externalDatabase.password | string | `""` | Password of the user. Ignored if `externalDatabase.existingSecret` is set. |
| externalDatabase.port | int | `3306` | Port of the external database |
| externalDatabase.username | string | `"typo3"` | Name of the user to use |
| fullnameOverride | string | `""` | String to fully override `"typo3.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"crinis/typo3"` | image repository |
| image.tag | string | `"legacy-13.4.37"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.failureThreshold | int | `3` | Failure threshold for livenessProbe |
| livenessProbe.httpGet.path | string | `"/typo3/"` | Path for livenessProbe |
| livenessProbe.initialDelaySeconds | int | `0` | Initial delay seconds for livenessProbe |
| livenessProbe.periodSeconds | int | `10` | Period seconds for livenessProbe |
| livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| livenessProbe.timeoutSeconds | int | `5` | Timeout seconds for livenessProbe |
| mariadb.enabled | bool | `true` | Enable a MariaDB instance managed by the mariadb-operator. Requires the operator to be installed in the cluster (see README). |
| mariadb.mariadb.database | string | `"typo3"` | Name of the database to create |
| mariadb.mariadb.galera.enabled | bool | `true` | Enable Galera to run multiple instances |
| mariadb.mariadb.image | string | `"mariadb:13.0"` | MariaDB image. The tag only pins the release series (13.0 is the current long-term support release), so restarted instances get its latest patch version. |
| mariadb.mariadb.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest patch version of the release series |
| mariadb.mariadb.passwordSecretKeyRef.generate | bool | `true` | Let the operator generate the Secret with a random password if it does not exist |
| mariadb.mariadb.passwordSecretKeyRef.key | string | `"password"` | Key of the password inside the Secret |
| mariadb.mariadb.passwordSecretKeyRef.name | string | `""` | Name of an existing Secret containing the password of the user. If empty, the Secret `<release>-mariadb-password` is used. |
| mariadb.mariadb.replicas | int | `3` | Number of MariaDB instances. More than one instance requires Galera or replication. |
| mariadb.mariadb.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| mariadb.mariadb.updateStrategy.mariadbAutoUpgradeEnabled | bool | `true` | Run `mariadb-upgrade` on start, so that changing the release series in `image` migrates the system schema. It is a no-op if there is nothing to migrate. |
| mariadb.mariadb.username | string | `"typo3"` | Name of the user to create |
| nameOverride | string | `""` | Provide a name in place of `typo3` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| persistence.fileadmin.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| persistence.fileadmin.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| persistence.fileadmin.enabled | bool | `true` | use a PVC to persist fileadmin data |
| persistence.fileadmin.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| persistence.fileadmin.resources | object | `{"requests":{"storage":"5Gi"}}` | represents the minimum and maximum resources the volume should have. |
| persistence.fileadmin.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| persistence.typo3conf.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| persistence.typo3conf.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| persistence.typo3conf.enabled | bool | `true` | use a PVC to persist typo3conf data |
| persistence.typo3conf.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| persistence.typo3conf.resources | object | `{"requests":{"storage":"1Gi"}}` | represents the minimum and maximum resources the volume should have. |
| persistence.typo3conf.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | see [values.yaml](./values.yaml) | pod-level security context. TYPO3 runs rootless as `www-data` (33) and listens on port 8080. The image expects the user to be a member of the root group (`supplementalGroups`), as `/var/www/html` belongs to it. |
| readinessProbe.failureThreshold | int | `3` | Failure threshold for readinessProbe |
| readinessProbe.httpGet.path | string | `"/typo3/"` | Path for readinessProbe |
| readinessProbe.initialDelaySeconds | int | `0` | Initial delay seconds for readinessProbe |
| readinessProbe.periodSeconds | int | `10` | Period seconds for readinessProbe |
| readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| readinessProbe.timeoutSeconds | int | `5` | Timeout seconds for readinessProbe |
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
| securityContext | object | see [values.yaml](./values.yaml) | container-level security context |
| service.port | int | `8080` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe.failureThreshold | int | `60` | Failure threshold for startupProbe |
| startupProbe.httpGet.path | string | `"/typo3/"` | Path for startupProbe |
| startupProbe.initialDelaySeconds | int | `10` | Initial delay seconds for startupProbe |
| startupProbe.periodSeconds | int | `10` | Period seconds for startupProbe |
| startupProbe.successThreshold | int | `1` | Success threshold for startupProbe |
| startupProbe.timeoutSeconds | int | `5` | Timeout seconds for startupProbe |
| tolerations | list | `[]` | Toleration labels for pod assignment |
| typo3.admin.email | string | `"admin@example.com"` | Email address of the admin user created during the initial setup |
| typo3.admin.existingSecret | string | `""` | Name of an existing Secret containing the password of the admin user |
| typo3.admin.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| typo3.admin.password | string | `""` | Password of the admin user. It has to satisfy the password policy of TYPO3 (at least 8 characters with upper and lower case letters, a digit and a special character). A random password is generated if empty. Ignored if `typo3.admin.existingSecret` is set. |
| typo3.admin.username | string | `"admin"` | Username of the admin user created during the initial setup |
| typo3.context | string | `"Production"` | TYPO3 context, `Production` or `Development` |
| typo3.fixFilePermissions | bool | `true` | Set sensible file permissions below `/var/www/html` on every start (`FIX_FILE_PERMISSIONS`). Can take a while with many files. |
| typo3.modifyConfiguration | bool | `true` | Update the database connection in `typo3conf/system/settings.php` from the chart values on every start (init container `prepare`) |
| typo3.projectName | string | `"New TYPO3 Project"` | Name of the TYPO3 project. Only used for the initial setup. |
| typo3.scheduler.enabled | bool | `false` | Run the TYPO3 scheduler every five minutes in a sidecar container |
| typo3.setup.createSite | string | `""` | URL of a site to create during the initial setup, e.g. `https://www.example.com/`. No site is created if empty. |
| typo3.setup.enabled | bool | `true` | Set up TYPO3 on the first start, i.e. if `typo3conf/system/settings.php` does not exist yet (`SETUP_TYPO3`) |
| typo3.setupExtensions | bool | `false` | Set up extensions on every start, e.g. apply database schema changes (`SETUP_EXTENSIONS`) |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/typo3
```

## Upgrading the Chart

### 8.0.0

This major switches the image from [martinhelmich/typo3](https://github.com/martin-helmich/docker-typo3) to [crinis/typo3](https://github.com/crinis/typo3-docker), updates TYPO3 from 12.4 to 13.4 and replaces the Bitnami database subcharts. The values and the behavior changed as follows:

- TYPO3 runs rootless as `www-data` (UID 33) on port 8080 and is served from `/var/www/html/public`. The PersistentVolumeClaims `<release>-typo3-fileadmin` and `<release>-typo3-typo3conf` are kept and mounted at the new paths. Persistence is now enabled by default; keep your previous `persistence.*` values, as existing claims cannot be shrunk.
- the database connection in `typo3conf/system/settings.php` is now updated from the values on every start (see [Configuring TYPO3](#configuring-typo3))
- `mysql.*` and `postgresql.*` are removed. PostgreSQL is no longer supported, as the image lacks its PHP driver.
- `mariadb.*` is replaced by the values of the upstream chart [mariadb-cluster](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster), e.g. `mariadb.mariadb.database` and `mariadb.mariadb.username`. The MariaDB instance is managed by the [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator), install it first (see [Prerequisites](#prerequisites)). An inline password for the bundled database is no longer supported. Use an existing Secret or let the operator generate one (see [Configuring the Database](#configuring-the-database))
- `externalDatabase.auth.*` moved one level up (`externalDatabase.database`, `externalDatabase.username`, `externalDatabase.password`, `externalDatabase.existingSecret`), `externalDatabase.auth.userPasswordKey` is renamed to `externalDatabase.existingSecretPasswordKey` and `externalDatabase.type` is removed

Make sure the extensions in `typo3conf/ext` support TYPO3 13.4 before upgrading, see the [major upgrade guide](https://docs.typo3.org/m/typo3/reference-coreapi/13.4/en-us/Administration/Upgrade/Major/Index.html) of TYPO3. With an external database, only the values and step 5 below apply. The bundled database is replaced by a new, empty one. The Bitnami StatefulSet is removed, but its PersistentVolumeClaim `data-<release>-mysql-0` (or `data-<release>-mariadb-0`) is kept. A dump of the MySQL database can be restored into MariaDB without changes. To take your data along:

1. Dump the database before upgrading. For the bundled MySQL (the previous default):

   ```console
   kubectl exec <release>-mysql-0 -- sh -c 'mysqldump -u"$MYSQL_USER" -p"$(cat "$MYSQL_PASSWORD_FILE")" --no-tablespaces "$MYSQL_DATABASE"' > typo3.sql
   ```

   For the bundled MariaDB (`mariadb.enabled`):

   ```console
   kubectl exec <release>-mariadb-0 -- sh -c 'mariadb-dump -u"$MARIADB_USER" -p"$(cat "$MARIADB_PASSWORD_FILE")" "$MARIADB_DATABASE"' > typo3.sql
   ```

2. Upgrade the chart with TYPO3 scaled down, so it does not access the new database. Then wait until the operator has created the database and its user:

   ```console
   helm upgrade <release> christianhuth/typo3 --version 8.0.0 -f values.yaml --set replicaCount=0 --wait
   kubectl wait --for=create user/<release>-mariadb-user --timeout=10m
   kubectl wait --for=create grant/<release>-mariadb-user-all --timeout=10m
   kubectl wait --for=condition=Ready user/<release>-mariadb-user grant/<release>-mariadb-user-all --timeout=10m
   ```

3. Restore the dump. Use the Secret from `mariadb.mariadb.passwordSecretKeyRef` or the generated `<release>-mariadb-password`:

   ```console
   PASSWORD=$(kubectl get secret <release>-mariadb-password -o jsonpath='{.data.password}' | base64 -d)
   kubectl exec -i <release>-mariadb-0 -c mariadb -- mariadb -u typo3 --password="$PASSWORD" typo3 < typo3.sql
   ```

4. Scale TYPO3 up again. On start, the existing installation is switched to the new database:

   ```console
   helm upgrade <release> christianhuth/typo3 --version 8.0.0 -f values.yaml --wait
   ```

5. Update the database schema of TYPO3 13.4, run the upgrade wizards and flush the caches:

   ```console
   kubectl exec deploy/<release>-typo3 -c typo3 -- /var/www/html/public/typo3/sysext/core/bin/typo3 extension:setup
   kubectl exec deploy/<release>-typo3 -c typo3 -- /var/www/html/public/typo3/sysext/core/bin/typo3 upgrade:run
   kubectl exec deploy/<release>-typo3 -c typo3 -- /var/www/html/public/typo3/sysext/core/bin/typo3 cache:flush
   ```

6. Once everything works, delete the old PersistentVolumeClaim `data-<release>-mysql-0` (or `data-<release>-mariadb-0`).

### 6.0.0

This major updates the MariaDB subchart to its newest major, 24.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

Additionaly it updates the PostgreSQL subchart to its newest major, 18.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#upgrading) you can find more information about the changes introduced in that version.

### 5.0.0

This major updates the MySQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1400) you can find more information about the changes introduced in that version.

Additionally it updates the MariaDB subchart to its newest major, 22.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### 4.0.0

This major updates the MariaDB subchart to its newest major, 21.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### 3.0.0

This major updates the MySQL subchart to its newest major, 12.2.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1220) you can find more information about the changes introduced in that version.

Additionaly it updates the PostgreSQL subchart to its newest major, 16.4.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1630) you can find more information about the changes introduced in that version.

Additionally it updates the MariaDB subchart to its newest major, 20.2.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-2020) you can find more information about the changes introduced in that version.

### 2.0.0

This major updates the TYPO3 Docker Image to its newest major, 12.4. [Here](https://get.typo3.org/release-notes/12.4.0) you can find more information about the changes introduced in that version.

Additionaly it updates the PostgreSQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1400) you can find more information about the changes introduced in that version.

Additionally it updates the MariaDB subchart to its newest major, 16.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#to-1600) you can find more information about the changes introduced in that version.

### 1.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

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

- Kubernetes 1.29+
- The [CloudNativePG operator](https://cloudnative-pg.io) if the bundled PostgreSQL database is used (`freshrss.database.type: postgresql` and `postgresql.enabled: true`)

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
| deploymentStrategy | object | `{}` | Update strategy for the deployment |
| externalDatabase.database | string | `"freshrss"` | Name of the database to use |
| externalDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user |
| externalDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalDatabase.hostname | string | `""` | Hostname of the external PostgreSQL database. Used if `freshrss.database.type` is postgresql and `postgresql.enabled` is false. |
| externalDatabase.password | string | `""` | Password of the user. Ignored if `externalDatabase.existingSecret` is set. |
| externalDatabase.port | int | `5432` | Port of the external PostgreSQL database |
| externalDatabase.username | string | `"freshrss"` | Name of the user to use |
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
| image.tag | string | `"1.30.3"` | Overrides the image tag |
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
| postgresql.cluster.imageName | string | `"ghcr.io/cloudnative-pg/postgresql:18-standard-trixie"` | PostgreSQL image. The tag only pins the major version, so restarted instances get the latest minor version. |
| postgresql.cluster.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest minor version of the major version |
| postgresql.cluster.initdb.database | string | `"freshrss"` | Name of the database to create |
| postgresql.cluster.initdb.owner | string | `"freshrss"` | Name of the user owning the database |
| postgresql.cluster.instances | int | `3` | Number of PostgreSQL instances (one primary, the others are replicas) |
| postgresql.cluster.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| postgresql.enabled | bool | `false` | Enable a PostgreSQL cluster managed by the CloudNativePG operator. Requires `freshrss.database.type: postgresql` and the operator to be installed in the cluster (see README). |
| postgresql.version.postgresql | string | `"18"` | PostgreSQL major version. Has to match the major version of `postgresql.cluster.imageName`. |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the freshrss pods. |
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

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/freshrss
```

## Configuring the Database

FreshRSS uses SQLite by default. To use PostgreSQL, set `freshrss.database.type: postgresql` and either enable the bundled PostgreSQL cluster or configure an external database.

### Bundled PostgreSQL with an existing Secret (recommended)

Create a Secret of type `kubernetes.io/basic-auth` containing the credentials of the database owner. The `username` has to match `postgresql.cluster.initdb.owner`:

```console
kubectl create secret generic freshrss-database \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=freshrss \
  --from-literal=password='<password>'
```

Reference the Secret in your values:

```yaml
freshrss:
  database:
    type: postgresql

postgresql:
  enabled: true
  cluster:
    initdb:
      database: freshrss
      owner: freshrss
      secret:
        name: freshrss-database
```

If no Secret is referenced, the operator generates a random password and stores the credentials in the Secret `<release>-postgresql-app`. All other settings of the PostgreSQL cluster (e.g. `postgresql.cluster.instances`, `postgresql.cluster.storage`, backups) are passed to the upstream chart. See its [values](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster#values) for all options.

The password is passed to the auto-install (see [Initialization](#initialization)) through the environment variable `FRESHRSS_DB_PASSWORD`, which the FreshRSS entrypoint evaluates with the shell. It must therefore not contain spaces, quotes, backslashes, `$` or backticks.

### External PostgreSQL

```yaml
freshrss:
  database:
    type: postgresql

externalDatabase:
  hostname: postgresql.example.com
  port: 5432
  database: freshrss
  username: freshrss
  existingSecret: freshrss-database
  existingSecretPasswordKey: password
```

Instead of `externalDatabase.existingSecret` you can set `externalDatabase.password`, which lets the chart create the Secret.

## Upgrading

### To 3.0.0

This major replaces the Bitnami PostgreSQL subchart with a PostgreSQL cluster managed by the [CloudNativePG operator](https://cloudnative-pg.io). Install the operator first (see [Prerequisites](#prerequisites)). The values changed as follows:

- `postgresql.auth.*` is replaced by the values of the upstream chart [cnpg/cluster](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster), e.g. `postgresql.cluster.initdb.database` and `postgresql.cluster.initdb.owner`
- an inline password for the bundled database is no longer supported. Use an existing Secret or let the operator generate one (see [Configuring the Database](#configuring-the-database))
- `externalPostgresql.*` is renamed to `externalDatabase.*`, `externalPostgresql.auth.*` moved one level up and `userPasswordKey` is renamed to `existingSecretPasswordKey`

Releases using SQLite (the default) are not affected. If you use the bundled PostgreSQL, the upgrade creates a new, empty database. The Bitnami StatefulSet is removed, but its PersistentVolumeClaim `data-<release>-postgresql-0` is kept. FreshRSS stores its database connection in `data/config.php` on its own volume, so it has to be pointed to the new database as well. To take your data along:

1. Dump the database before upgrading:

   ```console
   kubectl exec <release>-postgresql-0 -- sh -c 'PGPASSWORD="$(cat "$POSTGRES_PASSWORD_FILE")" pg_dump --no-owner --no-acl -U "$POSTGRES_USER" -d "$POSTGRES_DATABASE"' > freshrss.sql
   ```

2. Upgrade the chart and wait for the new database. FreshRSS keeps using the connection from its `data/config.php` and skips the auto-install, so it does not initialize the new database:

   ```console
   helm upgrade <release> christianhuth/freshrss --version 3.0.0 -f values.yaml --wait
   kubectl wait --for=condition=Ready cluster/<release>-postgresql --timeout=10m
   ```

3. Restore the dump as the database owner. Use the Secret from `postgresql.cluster.initdb.secret.name` or the generated `<release>-postgresql-app`:

   ```console
   PASSWORD=$(kubectl get secret <release>-postgresql-app -o jsonpath='{.data.password}' | base64 -d)
   PRIMARY=$(kubectl get cluster <release>-postgresql -o jsonpath='{.status.currentPrimary}')
   kubectl exec -i $PRIMARY -c postgres -- env PGPASSWORD="$PASSWORD" psql -v ON_ERROR_STOP=1 -h localhost -U freshrss -d freshrss < freshrss.sql
   ```

4. Point FreshRSS to the new database:

   ```console
   kubectl exec deploy/<release>-freshrss -- sh -c "cd /var/www/FreshRSS && php cli/reconfigure.php --db-host <release>-postgresql-rw --db-base freshrss --db-user freshrss --db-password '$PASSWORD' && ./cli/access-permissions.sh"
   ```

5. Once everything works, delete the old PersistentVolumeClaim `data-<release>-postgresql-0`.

### To 2.0.0

This major updates the PostgreSQL subchart to its newest major, 18.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#upgrading) you can find more information about the changes introduced in that version.

## Initialization

This Chart can initialize FreshRSS on the first installation using the attribute `freshrss.initialization.enabled`, which defaults to `true`.
The initialization will configure the database connection and create the admin user for you.

This approach however has two downsides:

  1. Confidential information like the admin password has to be added to the environment variable `FRESHRSS_USER` of the Container
  2. Therefore you have to define these passwords using the attributes `freshrss.initialization.admin.apiPassword` and `freshrss.initialization.admin.password` and cannot use existing Kubernetes Secrets to define these values like you would in a GitOps based setup

The database password is not affected: it is read from its Secret and only inserted into `FRESHRSS_INSTALL` by Kubernetes when the container starts.

Make sure to set `freshrss.initialization.enabled=false` after the initialization has finished to remove the environment variables `FRESHRSS_INSTALL` and `FRESHRSS_USER` again.

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

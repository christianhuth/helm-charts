# polr

Polr is a quick, modern, and open-source link shortener

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/polr
```

## Introduction

This chart bootstraps a quick, modern and open-source link shortener called [Polr](https://polrproject.org/) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.26+
- The [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator) if the bundled MariaDB database is used (`mariadb.enabled: true`, the default)

### Installing the mariadb-operator

The chart bundles the database as a custom resource of the mariadb-operator (via the upstream chart [mariadb-cluster](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster)). The operator itself is not part of this chart, as it is installed once per Kubernetes cluster:

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
helm install my-release christianhuth/polr
```

These commands deploy Polr on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuring the Database

### Bundled MariaDB with an existing Secret (recommended)

Create a Secret containing the password of the database user and reference it in your values:

```console
kubectl create secret generic polr-database --from-literal=password='<password>'
```

```yaml
mariadb:
  mariadb:
    passwordSecretKeyRef:
      name: polr-database
      key: password
      generate: false
```

If no Secret is referenced, the operator generates a random password and stores it in the Secret `<release>-mariadb-password`. Polr writes the password into its `.env` file on startup, so it must not contain spaces, quotes, `#` or `$`. By default the database runs as a Galera cluster with 3 instances. All other settings are passed to the upstream chart, see its [values](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster) and the [MariaDB API reference](https://github.com/mariadb-operator/mariadb-operator/blob/main/docs/api_reference.md#mariadbspec).

The image tag only pins the MariaDB release series (by default the long-term support release 12.3). To upgrade to another release series, change the tag of `mariadb.mariadb.image`. The operator migrates the system schema on the rollout (`updateStrategy.mariadbAutoUpgradeEnabled`). Downgrades are not supported by MariaDB, so take a backup before upgrading.

### External MariaDB or MySQL

```yaml
mariadb:
  enabled: false

externalDatabase:
  hostname: mariadb.example.com
  port: 3306
  database: polr
  username: polr
  existingSecret: polr-database
  existingSecretPasswordKey: password
```

Instead of `externalDatabase.existingSecret` you can set `externalDatabase.password`, which lets the chart create the Secret.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| admin.email | string | `""` |  |
| admin.existingSecret | string | `""` |  |
| admin.password | string | `"admin"` |  |
| admin.username | string | `"admin"` |  |
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env[0].name | string | `"APP_ADDRESS"` |  |
| env[0].value | string | `"polr.local"` |  |
| env[1].name | string | `"APP_NAME"` |  |
| env[1].value | string | `"Polr"` |  |
| externalDatabase.database | string | `"polr"` | Name of the database to use |
| externalDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user |
| externalDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalDatabase.hostname | string | `""` | Hostname of the external MariaDB or MySQL database. Used if `mariadb.enabled` is false. |
| externalDatabase.password | string | `""` | Password of the user. Ignored if `externalDatabase.existingSecret` is set. |
| externalDatabase.port | int | `3306` | Port of the external database |
| externalDatabase.username | string | `"polr"` | Name of the user to use |
| fullnameOverride | string | `""` | String to fully override `"polr.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"ajanvier/polr"` | image repository |
| image.tag | string | `"2.3.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| mail.enabled | bool | `false` |  |
| mail.existingSecret | string | `""` |  |
| mail.fromAddress | string | `""` |  |
| mail.fromName | string | `""` |  |
| mail.host | string | `""` |  |
| mail.password | string | `""` |  |
| mail.port | string | `""` |  |
| mail.username | string | `""` |  |
| mariadb.enabled | bool | `true` | Enable a MariaDB instance managed by the mariadb-operator. Requires the operator to be installed in the cluster (see README). |
| mariadb.mariadb.database | string | `"polr"` | Name of the database to create |
| mariadb.mariadb.galera.enabled | bool | `true` | Enable Galera to run multiple instances |
| mariadb.mariadb.image | string | `"mariadb:12.3"` | MariaDB image. The tag only pins the release series (12.3 is the current long-term support release), so restarted instances get its latest patch version. |
| mariadb.mariadb.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest patch version of the release series |
| mariadb.mariadb.passwordSecretKeyRef.generate | bool | `true` | Let the operator generate the Secret with a random password if it does not exist |
| mariadb.mariadb.passwordSecretKeyRef.key | string | `"password"` | Key of the password inside the Secret |
| mariadb.mariadb.passwordSecretKeyRef.name | string | `""` | Name of an existing Secret containing the password of the user. If empty, the Secret `<release>-mariadb-password` is used. |
| mariadb.mariadb.replicas | int | `3` | Number of MariaDB instances. More than one instance requires Galera or replication. |
| mariadb.mariadb.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| mariadb.mariadb.updateStrategy.mariadbAutoUpgradeEnabled | bool | `true` | Run `mariadb-upgrade` on start, so that changing the release series in `image` migrates the system schema. It is a no-op if there is nothing to migrate. |
| mariadb.mariadb.username | string | `"polr"` | Name of the user to create |
| nameOverride | string | `""` | Provide a name in place of `polr` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to pods |
| podSecurityContext | object | `{}` | pod-level security context |
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
| service.port | int | `80` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/polr
```

## Upgrading the Chart

### To 5.0.0

This major replaces the Bitnami MySQL subchart with a MariaDB instance managed by the [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator) (upstream chart [mariadb-cluster](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster)). MariaDB is compatible with the MySQL driver used by Polr. Install the operator first (see [Prerequisites](#prerequisites)). The values changed as follows:

- `mysql.*` is replaced by `mariadb.*` with the values of the upstream chart, e.g. `mariadb.mariadb.database` and `mariadb.mariadb.username`
- an inline password for the bundled database is no longer supported. Use an existing Secret or let the operator generate one (see [Configuring the Database](#configuring-the-database))
- `externalDatabase.host` is renamed to `externalDatabase.hostname`, and the key of the password in `externalDatabase.existingSecret` is configurable with `externalDatabase.existingSecretPasswordKey` (previously the fixed key `mysql-password`)

The upgrade creates a new, empty database. The Bitnami StatefulSet is removed, but its PersistentVolumeClaim `data-<release>-mysql-0` is kept. A dump of the MySQL database can be restored into MariaDB without changes. To take your data along:

1. Dump the database before upgrading:

   ```console
   kubectl exec <release>-mysql-0 -- sh -c 'mysqldump -u"$MYSQL_USER" -p"$(cat "$MYSQL_PASSWORD_FILE")" --no-tablespaces "$MYSQL_DATABASE"' > polr.sql
   ```

2. Upgrade the chart with Polr scaled down, so it does not initialize the new database. Then wait until the operator has created the database and its user:

   ```console
   helm upgrade <release> christianhuth/polr --version 5.0.0 -f values.yaml --set replicaCount=0 --wait
   kubectl wait --for=create user/<release>-mariadb-user --timeout=10m
   kubectl wait --for=create grant/<release>-mariadb-user-all --timeout=10m
   kubectl wait --for=condition=Ready user/<release>-mariadb-user grant/<release>-mariadb-user-all --timeout=10m
   ```

3. Restore the dump. Use the Secret from `mariadb.mariadb.passwordSecretKeyRef` or the generated `<release>-mariadb-password`:

   ```console
   PASSWORD=$(kubectl get secret <release>-mariadb-password -o jsonpath='{.data.password}' | base64 -d)
   kubectl exec -i <release>-mariadb-0 -c mariadb -- mariadb -u polr --password="$PASSWORD" polr < polr.sql
   ```

4. Scale Polr up again:

   ```console
   helm upgrade <release> christianhuth/polr --version 5.0.0 -f values.yaml --wait
   ```

5. Once everything works, delete the old PersistentVolumeClaim `data-<release>-mysql-0`.

### To 4.0.0

This major updates the MySQL subchart to its newest major, 14.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1400) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the MySQL subchart to its newest major, 13.0.0: [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#to-1300) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the MySQL subchart to its newest major, 12.2.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mysql#upgrading) and [here](https://dev.mysql.com/doc/relnotes/mysql/8.4/en/) you can find more information about the changes introduced in that version.

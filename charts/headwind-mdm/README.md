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

## Configuring the Database

### Bundled PostgreSQL with an existing Secret (recommended)

Create a Secret of type `kubernetes.io/basic-auth` containing the credentials of the database owner. The `username` has to match `postgresql.cluster.initdb.owner`:

```console
kubectl create secret generic headwind-mdm-database \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=hmdm \
  --from-literal=password='<password>'
```

Reference the Secret in your values:

```yaml
postgresql:
  enabled: true
  cluster:
    initdb:
      database: hmdm
      owner: hmdm
      secret:
        name: headwind-mdm-database
```

If no Secret is referenced, the operator generates a random password and stores the credentials in the Secret `<release>-postgresql-app`.

All other settings of the PostgreSQL cluster (e.g. `postgresql.cluster.instances`, `postgresql.cluster.storage`, backups) are passed to the upstream chart. See its [values](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster#values) for all options.

### External PostgreSQL

```yaml
postgresql:
  enabled: false

externalDatabase:
  hostname: postgresql.example.com
  port: 5432
  database: hmdm
  username: hmdm
  existingSecret: headwind-mdm-database
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
| externalDatabase.database | string | `"hmdm"` | Name of the database to use |
| externalDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user |
| externalDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password of the user |
| externalDatabase.hostname | string | `""` | Hostname of the external PostgreSQL database. Used if `postgresql.enabled` is false. |
| externalDatabase.password | string | `""` | Password of the user. Ignored if `externalDatabase.existingSecret` is set. |
| externalDatabase.port | int | `5432` | Port of the external PostgreSQL database |
| externalDatabase.username | string | `"hmdm"` | Name of the user to use |
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
| image.tag | string | `"0.1.9"` | Overrides the image tag |
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
| postgresql.cluster.imageName | string | `"ghcr.io/cloudnative-pg/postgresql:18-standard-trixie"` | PostgreSQL image. The tag only pins the major version, so restarted instances get the latest minor version. |
| postgresql.cluster.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest minor version of the major version |
| postgresql.cluster.initdb.database | string | `"hmdm"` | Name of the database to create |
| postgresql.cluster.initdb.owner | string | `"hmdm"` | Name of the user owning the database |
| postgresql.cluster.instances | int | `3` | Number of PostgreSQL instances (one primary, the others are replicas) |
| postgresql.cluster.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| postgresql.enabled | bool | `true` | Enable a PostgreSQL cluster managed by the CloudNativePG operator. Requires the operator to be installed in the cluster (see README). |
| postgresql.version.postgresql | string | `"18"` | PostgreSQL major version. Has to match the major version of `postgresql.cluster.imageName`. |
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

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/headwind-mdm
```

## Upgrading the Chart

### To 6.0.0

This major replaces the Bitnami PostgreSQL subchart with a PostgreSQL cluster managed by the [CloudNativePG operator](https://cloudnative-pg.io). Install the operator first (see [Prerequisites](#prerequisites)). The values changed as follows:

- `postgresql.auth.*` and `postgresql.image.*` are replaced by the values of the upstream chart [cnpg/cluster](https://github.com/cloudnative-pg/charts/tree/main/charts/cluster), e.g. `postgresql.cluster.initdb.database` and `postgresql.cluster.initdb.owner`
- an inline password for the bundled database is no longer supported. Use an existing Secret or let the operator generate one (see [Configuring the Database](#configuring-the-database))
- `externalPostgresql.*` is renamed to `externalDatabase.*`, `externalPostgresql.auth.*` moved one level up and `userPasswordKey` is renamed to `existingSecretPasswordKey`

The upgrade creates a new, empty database. The Bitnami StatefulSet is removed, but its PersistentVolumeClaim `data-<release>-postgresql-0` is kept. To take your data along:

1. Dump the database before upgrading:

   ```console
   kubectl exec <release>-postgresql-0 -- sh -c 'PGPASSWORD="$(cat "$POSTGRES_PASSWORD_FILE")" pg_dump --no-owner --no-acl -U "$POSTGRES_USER" -d "$POSTGRES_DATABASE"' > hmdm.sql
   ```

2. Upgrade the chart with the application scaled down, so it does not initialize the new database:

   ```console
   helm upgrade <release> christianhuth/headwind-mdm --version 6.0.0 -f values.yaml --set replicaCount=0 --wait
   kubectl wait --for=condition=Ready cluster/<release>-postgresql --timeout=10m
   ```

3. Restore the dump as the database owner. Use the Secret from `postgresql.cluster.initdb.secret.name` or the generated `<release>-postgresql-app`:

   ```console
   PASSWORD=$(kubectl get secret <release>-postgresql-app -o jsonpath='{.data.password}' | base64 -d)
   kubectl exec -i <release>-postgresql-1 -c postgres -- env PGPASSWORD="$PASSWORD" psql -v ON_ERROR_STOP=1 -h localhost -U hmdm -d hmdm < hmdm.sql
   ```

4. Scale the application up again:

   ```console
   helm upgrade <release> christianhuth/headwind-mdm --version 6.0.0 -f values.yaml --wait
   ```

5. Once everything works, delete the old PersistentVolumeClaim `data-<release>-postgresql-0`.

### To 4.0.0

This major updates the PostgreSQL subchart to its newest major, 18.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#upgrading) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the PostgreSQL subchart to its newest major, 16.4.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1630) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the PostgreSQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1400) you can find more information about the changes introduced in that version.

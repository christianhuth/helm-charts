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

- Kubernetes 1.19+

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

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| externalDatabase.auth.database | string | `"typo3"` | Name of the database to use |
| externalDatabase.auth.existingSecret | string | `""` | Name of existing secret to use for database credentials |
| externalDatabase.auth.password | string | `"typo3"` | Password to use |
| externalDatabase.auth.userPasswordKey | string | `""` | Key in the secret containing the password |
| externalDatabase.auth.username | string | `"typo3"` | Name of the user to use |
| externalDatabase.hostname | string | `""` | Hostname of the database |
| externalDatabase.port | int | `3306` | Port used to connect to database |
| externalDatabase.type | string | `"mysql"` | Type of database |
| fullnameOverride | string | `""` | String to fully override `"typo3.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"martinhelmich/typo3"` | image repository |
| image.tag | string | `"12.4"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| mariadb.auth.database | string | `"typo3"` | Name for a custom database to create |
| mariadb.auth.existingSecret | string | `""` | Name of existing secret to use for MariaDB credentials |
| mariadb.auth.password | string | `"typo3"` | Password for the custom user to create. Ignored if mariadb.auth.existingSecret is provided |
| mariadb.auth.username | string | `"typo3"` | Name for a custom user to create |
| mariadb.enabled | bool | `false` | enable MariaDB™ subchart from Bitnami |
| mysql.auth.database | string | `"typo3"` | Name for a custom database to create |
| mysql.auth.existingSecret | string | `""` | Name of existing secret to use for MySQL credentials |
| mysql.auth.password | string | `"typo3"` | Password for the custom user to create. Ignored if mysql.auth.existingSecret is provided |
| mysql.auth.username | string | `"typo3"` | Name for a custom user to create |
| mysql.enabled | bool | `true` | enable MySQL™ subchart from Bitnami |
| mysql.image.tag | string | `"latest"` | Image tag for the MySQL™ subchart from Bitnami |
| nameOverride | string | `""` | Provide a name in place of `typo3` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| persistence.fileadmin.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| persistence.fileadmin.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| persistence.fileadmin.enabled | bool | `false` | use a PVC to persist fileadmin data |
| persistence.fileadmin.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| persistence.fileadmin.resources | object | `{}` | represents the minimum and maximum resources the volume should have. |
| persistence.fileadmin.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| persistence.typo3conf.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| persistence.typo3conf.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| persistence.typo3conf.enabled | bool | `false` | use a PVC to persist typo3conf data |
| persistence.typo3conf.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| persistence.typo3conf.resources | object | `{}` | represents the minimum and maximum resources the volume should have. |
| persistence.typo3conf.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| postgresql.auth.database | string | `"typo3"` | Name for a custom database to create |
| postgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| postgresql.auth.password | string | `"typo3"` | Password for the custom user to create. Ignored if postgresql.auth.existingSecret is provided |
| postgresql.auth.username | string | `"typo3"` | Name for a custom user to create |
| postgresql.enabled | bool | `false` | enable PostgreSQL™ subchart from Bitnami |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{}` | Resource limits and requests for the headwind pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
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
helm install my-release -f values.yaml christianhuth/typo3
```

## Upgrading the Chart

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

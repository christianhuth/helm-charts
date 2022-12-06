# headwind-mdm

Headwind MDM - an open source mobile device management software for Android

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/headwind-mdm
```

## Introduction

Headwind MDM is a Mobile device management (MDM) system for corporate Android devices, remote access to Android phones and tablets.

This chart bootstraps the [Headwind MDM](https://github.com/h-mdm) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/headwind-mdm
```

These commands deploy Headwind MDM on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                        | Type   | Default                                                                                                                                        | Description                                                                                   |
| ------------------------------------------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| affinity                                   | object | `{}`                                                                                                                                           |                                                                                               |
| autoscaling.enabled                        | bool   | `false`                                                                                                                                        |                                                                                               |
| autoscaling.maxReplicas                    | int    | `100`                                                                                                                                          |                                                                                               |
| autoscaling.minReplicas                    | int    | `1`                                                                                                                                            |                                                                                               |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                                                                                                                                           |                                                                                               |
| externalPostgresql                         | object | `{"auth":{"database":"mychart","existingSecret":"","password":"mychart","userPasswordKey":"","username":"mychart"},"hostname":"","port":5432}` | Values for an existing PostgreSQL database                                                    |
| externalPostgresql.auth.database           | string | `"mychart"`                                                                                                                                    | Name of the database to use                                                                   |
| externalPostgresql.auth.existingSecret     | string | `""`                                                                                                                                           | Name of existing secret to use for PostgreSQL credentials                                     |
| externalPostgresql.auth.password           | string | `"mychart"`                                                                                                                                    | Password to use                                                                               |
| externalPostgresql.auth.userPasswordKey    | string | `""`                                                                                                                                           | Key in the secret containing the password                                                     |
| externalPostgresql.auth.username           | string | `"mychart"`                                                                                                                                    | Name of the user to use                                                                       |
| externalPostgresql.hostname                | string | `""`                                                                                                                                           | Hostname of the PostgreSQL database                                                           |
| externalPostgresql.port                    | int    | `5432`                                                                                                                                         | Port used to connect to PostgreSQL database                                                   |
| fullnameOverride                           | string | `""`                                                                                                                                           |                                                                                               |
| headwind.adminEmail                        | string | `""`                                                                                                                                           |                                                                                               |
| headwind.baseDomain                        | string | `""`                                                                                                                                           |                                                                                               |
| headwind.clientVersion                     | string | `"5.04"`                                                                                                                                       |                                                                                               |
| headwind.downloadCredentials               | bool   | `false`                                                                                                                                        |                                                                                               |
| headwind.hdmUrl                            | string | `"https://h-mdm.com/files/hmdm-5.12.1-os.war"`                                                                                                 |                                                                                               |
| image.pullPolicy                           | string | `"Always"`                                                                                                                                     |                                                                                               |
| image.repository                           | string | `"headwindmdm/hmdm"`                                                                                                                           |                                                                                               |
| image.tag                                  | string | `"0.1.0"`                                                                                                                                      |                                                                                               |
| imagePullSecrets                           | list   | `[]`                                                                                                                                           |                                                                                               |
| ingress.annotations                        | object | `{}`                                                                                                                                           |                                                                                               |
| ingress.className                          | string | `""`                                                                                                                                           |                                                                                               |
| ingress.enabled                            | bool   | `false`                                                                                                                                        |                                                                                               |
| ingress.hosts[0].host                      | string | `"chart-example.local"`                                                                                                                        |                                                                                               |
| ingress.hosts[0].paths[0].path             | string | `"/"`                                                                                                                                          |                                                                                               |
| ingress.hosts[0].paths[0].pathType         | string | `"ImplementationSpecific"`                                                                                                                     |                                                                                               |
| ingress.tls                                | list   | `[]`                                                                                                                                           |                                                                                               |
| nameOverride                               | string | `""`                                                                                                                                           |                                                                                               |
| nodeSelector                               | object | `{}`                                                                                                                                           |                                                                                               |
| persistence.accessModes[0]                 | string | `"ReadWriteOnce"`                                                                                                                              |                                                                                               |
| persistence.annotations                    | object | `{}`                                                                                                                                           |                                                                                               |
| persistence.enabled                        | bool   | `false`                                                                                                                                        |                                                                                               |
| persistence.existingClaim                  | string | `""`                                                                                                                                           |                                                                                               |
| persistence.size                           | string | `"10Gi"`                                                                                                                                       |                                                                                               |
| persistence.storageClass                   | string | `""`                                                                                                                                           |                                                                                               |
| podAnnotations                             | object | `{}`                                                                                                                                           |                                                                                               |
| podSecurityContext                         | object | `{}`                                                                                                                                           |                                                                                               |
| postgresql                                 | object | `{"auth":{"database":"mychart","existingSecret":"","password":"mychart","username":"mychart"},"enabled":true}`                                 | Values for including the subchart PostgreSQL™ from Bitnami                                    |
| postgresql.auth.database                   | string | `"mychart"`                                                                                                                                    | Name for a custom database to create                                                          |
| postgresql.auth.existingSecret             | string | `""`                                                                                                                                           | Name of existing secret to use for PostgreSQL credentials                                     |
| postgresql.auth.password                   | string | `"mychart"`                                                                                                                                    | Password for the custom user to create. Ignored if postgresql.auth.existingSecret is provided |
| postgresql.auth.username                   | string | `"mychart"`                                                                                                                                    | Name for a custom user to create                                                              |
| postgresql.enabled                         | bool   | `true`                                                                                                                                         | enable PostgreSQL™ subchart from Bitnami                                                      |
| replicaCount                               | int    | `1`                                                                                                                                            |                                                                                               |
| resources                                  | object | `{}`                                                                                                                                           |                                                                                               |
| securityContext                            | object | `{}`                                                                                                                                           |                                                                                               |
| service.port                               | int    | `8080`                                                                                                                                         |                                                                                               |
| service.type                               | string | `"ClusterIP"`                                                                                                                                  |                                                                                               |
| serviceAccount.annotations                 | object | `{}`                                                                                                                                           |                                                                                               |
| serviceAccount.create                      | bool   | `true`                                                                                                                                         |                                                                                               |
| serviceAccount.name                        | string | `""`                                                                                                                                           |                                                                                               |
| tolerations                                | list   | `[]`                                                                                                                                           |                                                                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/headwind-mdm
```

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

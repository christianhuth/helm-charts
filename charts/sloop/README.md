# sloop

Kubernetes History Visualization

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/sloop
```

## Introduction

This chart bootstraps [Sloop](https://github.com/salesforce/sloop) a tool for Kubernete History Visualization susing the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/sloop
```

These commands deploy Sloop on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                        | Type   | Default                                                                                                                                                                                             | Description |
| ------------------------------------------ | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| affinity                                   | object | `{}`                                                                                                                                                                                                |             |
| autoscaling.enabled                        | bool   | `false`                                                                                                                                                                                             |             |
| autoscaling.maxReplicas                    | int    | `100`                                                                                                                                                                                               |             |
| autoscaling.minReplicas                    | int    | `1`                                                                                                                                                                                                 |             |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                                                                                                                                                                                                |             |
| clusterRole.additionalApiGroups            | list   | `[]`                                                                                                                                                                                                |             |
| clusterRole.additionalPermissions          | list   | `[]`                                                                                                                                                                                                |             |
| fullnameOverride                           | string | `""`                                                                                                                                                                                                |             |
| image.pullPolicy                           | string | `"Always"`                                                                                                                                                                                          |             |
| image.repository                           | string | `"ghcr.io/salesforce/sloop"`                                                                                                                                                                        |             |
| image.tag                                  | string | `"sha-2ce8bbe"`                                                                                                                                                                                     |             |
| imagePullSecrets                           | list   | `[]`                                                                                                                                                                                                |             |
| ingress.annotations                        | object | `{}`                                                                                                                                                                                                |             |
| ingress.className                          | string | `""`                                                                                                                                                                                                |             |
| ingress.enabled                            | bool   | `false`                                                                                                                                                                                             |             |
| ingress.hosts[0].host                      | string | `"chart-example.local"`                                                                                                                                                                             |             |
| ingress.hosts[0].paths[0].path             | string | `"/"`                                                                                                                                                                                               |             |
| ingress.hosts[0].paths[0].pathType         | string | `"ImplementationSpecific"`                                                                                                                                                                          |             |
| ingress.tls                                | list   | `[]`                                                                                                                                                                                                |             |
| nameOverride                               | string | `""`                                                                                                                                                                                                |             |
| nodeSelector                               | object | `{}`                                                                                                                                                                                                |             |
| persistence.accessModes[0]                 | string | `"ReadWriteOnce"`                                                                                                                                                                                   |             |
| persistence.annotations                    | object | `{}`                                                                                                                                                                                                |             |
| persistence.enabled                        | bool   | `false`                                                                                                                                                                                             |             |
| persistence.existingClaim                  | string | `""`                                                                                                                                                                                                |             |
| persistence.size                           | string | `"10Gi"`                                                                                                                                                                                            |             |
| persistence.storageClass                   | string | `""`                                                                                                                                                                                                |             |
| podAnnotations                             | object | `{}`                                                                                                                                                                                                |             |
| podSecurityContext                         | object | `{}`                                                                                                                                                                                                |             |
| replicaCount                               | int    | `1`                                                                                                                                                                                                 |             |
| resources                                  | object | `{}`                                                                                                                                                                                                |             |
| securityContext                            | object | `{}`                                                                                                                                                                                                |             |
| service.port                               | int    | `80`                                                                                                                                                                                                |             |
| service.type                               | string | `"ClusterIP"`                                                                                                                                                                                       |             |
| serviceAccount.annotations                 | object | `{}`                                                                                                                                                                                                |             |
| serviceAccount.create                      | bool   | `true`                                                                                                                                                                                              |             |
| serviceAccount.name                        | string | `""`                                                                                                                                                                                                |             |
| sloop.config                               | string | `"{\n \"displayContext\": \"cluster\",\n \"defaultNamespace\": \"default\",\n \"defaultKind\": \"Pod\",\n \"defaultLookback\": \"1h\",\n \"leftBarLinks\": [\n ],\n \"resourceLinks\": [\n ]\n}\n"` |             |
| tolerations                                | list   | `[]`                                                                                                                                                                                                |             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/sloop
```

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

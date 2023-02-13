# popeye

Popeye - A Kubernetes Cluster Sanitizer

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/popeye
```

## Introduction

This chart bootstraps the Kubernetes cluster resource sanitizer called [popeye](https://github.com/derailed/popeye) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/popeye
```

These commands deploy popeye on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                         | Type   | Default                                        | Description                                                                                                                     |
| ------------------------------------------- | ------ | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| affinity                                    | object | `{}`                                           | Affinity settings for pod assignment                                                                                            |
| cronJob.clusterName                         | string | `""`                                           |                                                                                                                                 |
| cronJob.history.failedJobsHistoryLimit      | int    | `1`                                            |                                                                                                                                 |
| cronJob.history.successfulJobsHistoryLimit  | int    | `1`                                            |                                                                                                                                 |
| cronJob.outputFormat                        | string | `"standard"`                                   |                                                                                                                                 |
| cronJob.prometheus.basicAuth.enabled        | bool   | `false`                                        | Use authentication against Prometheus Pushgateway                                                                               |
| cronJob.prometheus.basicAuth.existingSecret | string | `""`                                           | Name of existing secret to use for authentication against Prometheus Pushgateway, needs to contain the key pushgateway-password |
| cronJob.prometheus.basicAuth.password       | string | `""`                                           | Password for authentication against Prometheus Pushgateway                                                                      |
| cronJob.prometheus.basicAuth.user           | string | `""`                                           | Username for authentication against Prometheus Pushgateway                                                                      |
| cronJob.prometheus.pushgatewayAddress       | string | `""`                                           |                                                                                                                                 |
| cronJob.s3.bucket                           | string | `""`                                           | bucket name can be the URI and the bucket name path s3://example-bucket                                                         |
| cronJob.s3.endpoint                         | string | `""`                                           | example endpoint: "https://s3.us-east-1.amazonaws.com"                                                                          |
| cronJob.s3.region                           | string | `""`                                           | example region: "us-east-1"                                                                                                     |
| cronJob.schedule                            | string | `"* */1 * * *"`                                |                                                                                                                                 |
| cronJob.spinachConfiguration                | string | `nil`                                          |                                                                                                                                 |
| fullnameOverride                            | string | `""`                                           | String to fully override `"popeye.fullname"`                                                                                    |
| image.pullPolicy                            | string | `"Always"`                                     | image pull policy                                                                                                               |
| image.repository                            | string | `"derailed/popeye"`                            | image repository                                                                                                                |
| image.tag                                   | string | `"v0.11.0"`                                    | Overrides the image tag                                                                                                         |
| imagePullSecrets                            | list   | `[]`                                           | If defined, uses a Secret to pull an image from a private Docker registry or repository.                                        |
| nameOverride                                | string | `""`                                           | Provide a name in place of `popeye`                                                                                             |
| nodeSelector                                | object | `{}`                                           | Node labels for pod assignment                                                                                                  |
| podAnnotations                              | object | `{}`                                           | Annotations to be added to exporter pods                                                                                        |
| podSecurityContext                          | object | `{}`                                           | pod-level security context                                                                                                      |
| resources                                   | object | `{"limits":{"cpu":"1000m","memory":"1000Mi"}}` | Resource limits and requests for the headwind pods.                                                                             |
| securityContext                             | object | `{}`                                           | container-level security context                                                                                                |
| serviceAccount.annotations                  | object | `{}`                                           | Annotations to add to the service account                                                                                       |
| serviceAccount.create                       | bool   | `true`                                         | Specifies whether a service account should be created                                                                           |
| serviceAccount.name                         | string | `""`                                           | The name of the service account to use. If not set and create is true, a name is generated using the fullname template          |
| tolerations                                 | list   | `[]`                                           | Toleration labels for pod assignment                                                                                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/popeye
```

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

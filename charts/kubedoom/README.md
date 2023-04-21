# kubedoom

A Helm chart for Kubedoom

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/kubedoom
```

## Introduction

<INTRODUCTION>

This chart bootstraps [Kubedoom](https://github.com/storax/kubedoom) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/kubedoom
```

These commands deploy Kubedoom on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Accessing Doom

Now start a VNC viewer and connect to the URL of your Kubedoom installation. The password is `idbehold`.

$ vncviewer viewer <URL_OF_KUBEDOOM>

You should now see DOOM! Now if you want to get the job done quickly enter the cheat `idspispopd` and walk through the wall on your right. You should be greeted by your pods as little pink monsters. Press CTRL to fire. If the pistol is not your thing, cheat with `idkfa` and press `5` for a nice surprise. Pause the game with ESC.

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                           | Type   | Default             | Description                                                                                                            |
| --------------------------------------------- | ------ | ------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| affinity                                      | object | `{}`                | Affinity settings for pod assignment                                                                                   |
| autoscaling.enabled                           | bool   | `false`             | Enable Horizontal POD autoscaling                                                                                      |
| autoscaling.maxReplicas                       | int    | `100`               | Maximum number of replicas                                                                                             |
| autoscaling.minReplicas                       | int    | `1`                 | Minimum number of replicas                                                                                             |
| autoscaling.targetCPUUtilizationPercentage    | int    | `80`                | Target CPU utilization percentage                                                                                      |
| autoscaling.targetMemoryUtilizationPercentage | int    | `80`                | Target Memory utilization percentage                                                                                   |
| extraEnv                                      | list   | `[]`                | additional environment variables to be added to the pods                                                               |
| fullnameOverride                              | string | `""`                | String to fully override `"kubedoom.fullname"`                                                                         |
| image.pullPolicy                              | string | `"Always"`          | image pull policy                                                                                                      |
| image.registry                                | string | `"ghcr.io"`         | image registry                                                                                                         |
| image.repository                              | string | `"storax/kubedoom"` | image repository                                                                                                       |
| image.tag                                     | string | `"0.6.0"`           | Overrides the image tag                                                                                                |
| imagePullSecrets                              | list   | `[]`                | If defined, uses a Secret to pull an image from a private Docker registry or repository.                               |
| kubedoom.mode                                 | string | `""`                | You can also kill Namespaces instead of Pods. Simply set this to namespace.                                            |
| kubedoom.namespace                            | string | `""`                | You can limit Kubedoom to deleting pods in a single namespace                                                          |
| nameOverride                                  | string | `""`                | Provide a name in place of `kubedoom`                                                                                  |
| nodeSelector                                  | object | `{}`                | Node labels for pod assignment                                                                                         |
| podAnnotations                                | object | `{}`                | Annotations to be added to the pods                                                                                    |
| podSecurityContext                            | object | `{}`                | pod-level security context                                                                                             |
| replicaCount                                  | int    | `1`                 | Number of replicas                                                                                                     |
| resources                                     | object | `{}`                | Resource limits and requests for the controller pods.                                                                  |
| revisionHistoryLimit                          | int    | `10`                | The number of old ReplicaSets to retain                                                                                |
| securityContext                               | object | `{}`                | container-level security context                                                                                       |
| service.port                                  | int    | `5900`              | Kubernetes port where service is exposed                                                                               |
| service.type                                  | string | `"ClusterIP"`       | Kubernetes service type                                                                                                |
| serviceAccount.annotations                    | object | `{}`                | Annotations to add to the service account                                                                              |
| serviceAccount.create                         | bool   | `true`              | Specifies whether a service account should be created                                                                  |
| serviceAccount.name                           | string | `""`                | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations                                   | list   | `[]`                | Toleration labels for pod assignment                                                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/kubedoom
```

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

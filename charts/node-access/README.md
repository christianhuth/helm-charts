# node-access

A Helm chart to deploy workload to gain direct access to the host of the Kubernetes cluster

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/node-access
```

## Introduction

This chart bootstraps one or multiple Pods to access the host system of a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/node-access
```

These commands deploys one or multiple Pods to access the host system of the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| fullnameOverride | string | `""` | String to fully override `"node-access.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registory |
| image.repository | string | `"busybox"` | image repository |
| image.tag | string | `"1.37.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| nameOverride | string | `""` | Provide a name in place of `node-access` |
| nodeAccess.accessMode | string | `"deployment"` | How to deploy the Pods to access the host system: daemonset or deployment |
| nodeAccess.hostPaths | list | `[]` | List of additional paths on the host that should be mounted into the container |
| nodeAccess.nodePlacement.affinity | object | `{}` | Affinity settings for pod assignment |
| nodeAccess.nodePlacement.nodeName | string | `""` | Request to schedule this pod onto a specific node |
| nodeAccess.nodePlacement.nodeSelector | object | `{}` | Node labels for pod assignment |
| nodeAccess.nodePlacement.tolerations | list | `[]` | Toleration labels for pod assignment |
| nodeAccess.nodePlacement.topologySpreadConstraints | list | `[]` | how a group of pods ought to spread across topology domains |
| podAnnotations | object | `{}` | Annotations to be added to the pods |
| podSecurityContext | object | see [values.yaml](./values.yaml) | pod-level security context |
| replicaCount | int | `1` | Number of replicas. Only used if `accessNode.accessMode` equals `deployment` |
| resources | object | see [values.yaml](./values.yaml) | Resource limits and requests for the controller pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| securityContext | object | see [values.yaml](./values.yaml) | container-level security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/node-access
```

## Deploying to a specific Node

If you want to deploy only to one specific Node you can simply define the `nodeName` using `--set nodeAccess.nodePlacement.nodeName=<NODE_NAME>` or through the values file:

```yaml
nodeAccess:
  accessMode: deployment
  nodePlacement:
    nodeName: <NODE_NAME>
```

## Deploying to all Nodes

If you want to deploy Pods to access all Nodes, the easiest way is to use a DaemonSet instead of a Deployment using `--set nodeAccess.accessMode="daemonset"` or through the values file:

```yaml
nodeAccess:
  accessMode: daemonset
```

## Deploying to a subset of Nodes

If you want to deploy Pods to a subset of Nodes you can use a DaemonSet and a NodeSelector:

```yaml
nodeAccess:
  accessMode: daemonset
  nodePlacement:
    nodeSelector:
      key: value
```

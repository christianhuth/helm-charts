# kubevirt-cloud-controller-manager

Kubernetes cloud-provider for KubeVirt

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/kubevirt-cloud-controller-manager
```

## Introduction

This chart installs the [KubeVirt Cloud Provider](https://github.com/kubevirt/cloud-provider-kubevirt) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/kubevirt-cloud-controller-manager
```

These commands deploy the KubeVirt Cloud Provider on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"kubevirt-cloud-controller-manager.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"quay.io"` | image registory |
| image.repository | string | `"kubevirt/kubevirt-cloud-controller-manager"` | image repository |
| image.tag | string | `"v0.6.0"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| kccm.additionalLabels.enabled | bool | `true` | Adds additional capi labels to the cloud controller manager resources |
| kccm.cloudConfig.instancesV2.enabled | bool | `true` | Whether to use the instancesV2 API for listing and watching instances. This is required for OpenShift 4.13 and later. |
| kccm.cloudConfig.instancesV2.zoneAndRegionEnabled | bool | `false` | Whether to use the zone and region information from the instance metadata. This is required for OpenShift 4.13 and later. |
| kccm.cloudConfig.loadBalancer.creationPollInterval | int | `5` | The interval at which the cloud controller manager polls for the creation of load balancers |
| kccm.cloudConfig.loadBalancer.creationPollTimeout | int | `60` | The timeout for polling for the creation of load balancers |
| kccm.cluster.kubeconfig.content.cluster.ca | string | `""` | The base64-encoded value of the cluster CA |
| kccm.cluster.kubeconfig.content.cluster.server | string | `""` | The address of the CAPI api server in the form https://<host>:<port> |
| kccm.cluster.kubeconfig.content.users.cert | string | `""` | The base64-encoded value of the user certificate |
| kccm.cluster.kubeconfig.content.users.key | string | `""` | The base64-encoded value of the user key |
| kccm.cluster.kubeconfig.existingSecret | string | `""` | The name of the secret containing the kubeconfig to access the CAPI cluster. If not set, will default to "<cluster-name>-kubeconfig" |
| kccm.cluster.name | string | `""` | The name of the cluster to which the cloud controller manager belongs. This is used by the cloud controller manager to watch for changes to the cluster object and update its status accordingly. |
| kccm.cluster.namespace | string | `""` | The namespace in which the cloud controller manager should watch for changes to the cluster object. If not set, the cloud controller manager will watch for changes to the cluster object in the Release namespace. |
| kccm.deploymentMode | string | `"isolated"` | Indicates whether the cloud controller manager is installed outside of the managed cluster (isolated) or inside |
| nameOverride | string | `""` | Provide a name in place of `kubevirt-cloud-controller-manager` |
| nodeSelector | object | `{"node-role.kubernetes.io/control-plane":""}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| podSecurityContext | object | `{}` | pod-level security context |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource limits and requests for the pods. |
| revisionHistoryLimit | int | `0` | The number of old ReplicaSets to retain |
| securityContext | object | `{"privileged":true}` | container-level security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[{"effect":"NoSchedule","key":"node.cloudprovider.kubernetes.io/uninitialized","value":"true"},{"effect":"NoSchedule","key":"node-role.kubernetes.io/control-plane"}]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/kubevirt-cloud-controller-manager
```

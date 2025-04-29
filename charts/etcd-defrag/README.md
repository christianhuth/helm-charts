# etcd-defrag

A Helm chart for running a defragmentation CronJob for ETCD

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/etcd-defrag
```

## Introduction

The process of defragmentation releases storage space blocked by ETCD fragmentation back to the file system.

**Note that defragmentation to a live member blocks the system from reading and writing data while rebuilding its states.**

This chart bootstraps a CronJob to perform periodically [defragmentation for ETCD](https://etcd.io/docs/latest/op-guide/maintenance/#defragmentation) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/etcd-defrag
```

These commands deploy the CronJob on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| defrag.config.auth.enabled | bool | `false` | use username and password for authentication against etcd |
| defrag.config.auth.existingSecret | string | `""` | Name of existing secret to use for authentication credentials. Key needs to be called `etcd-password`. |
| defrag.config.auth.password | string | `""` | password for authentication |
| defrag.config.auth.user | string | `""` | username for authentication |
| defrag.config.clusterWide | bool | `true` | Run defragment operations for all endpoints in the cluster associated with the default endpoint. |
| defrag.config.commandTimeout | string | `""` | timeout for short running command (excluding dial timeout) |
| defrag.config.debug | bool | `false` | enable client-side debug logging |
| defrag.config.dialTimeout | string | `""` | dial timeout for client connections |
| defrag.config.endpoints | list | `[]` | gRPC endpoints |
| defrag.config.insecureSkipTlsVerify | bool | `false` | skip server certificate verification |
| defrag.config.insecureTransport | bool | `true` | disable transport security for client connections |
| defrag.config.pki.ca | string | `""` | certificate authority used for the etcd certificates |
| defrag.config.pki.cert | string | `""` | identify secure client using this TLS certificate |
| defrag.config.pki.existingSecret | string | `""` | Name of existing secret with certificates. Keys needs to be called `ca`, `cert` and `key`. |
| defrag.config.pki.hostAccess.caFilePath | string | `"/etc/kubernetes/pki/etcd/ca.crt"` | file on host containing the certificate authority |
| defrag.config.pki.hostAccess.certFilePath | string | `"/etc/kubernetes/pki/etcd/server.crt"` | file on host containing the server certificate |
| defrag.config.pki.hostAccess.enabled | bool | `false` | get certificates directly from host where the Pod is running |
| defrag.config.pki.hostAccess.keyFilePath | string | `"/etc/kubernetes/pki/etcd/server.key"` | file on host containing the server private key |
| defrag.config.pki.key | string | `""` | identify secure client using this TLS key |
| defrag.config.writeOut | string | `"table"` | set the output format: `fields`, `json`, `protobuf`, `simple`, `table`) |
| defrag.cronjob.concurrencyPolicy | string | `"Forbid"` | Specifies how to treat concurrent executions of a Job. Valid values are: `Allow`, `Forbid` and `Replace`. |
| defrag.cronjob.failedJobsHistoryLimit | string | `"1"` | The number of failed finished jobs to retain. |
| defrag.cronjob.schedule | string | `"0 */1 * * *"` | The schedule in Cron format, see https://en.wikipedia.org/wiki/Cron. |
| defrag.cronjob.startingDeadlineSeconds | string | `"30"` | Optional deadline in seconds for starting the job if it misses scheduled time for any reason. Missed jobs executions will be counted as failed ones. |
| defrag.cronjob.successfulJobsHistoryLimit | string | `"3"` | The number of successful finished jobs to retain. |
| defrag.cronjob.suspend | bool | `false` | This flag tells the controller to suspend subsequent executions, it does not apply to already started executions. |
| defrag.enabled | bool | `true` | create a CronJob for defragmentation |
| defrag.job.activeDeadlineSeconds | string | `""` | Specifies the duration in seconds relative to the startTime that the job may be continuously active before the system tries to terminate it. |
| defrag.job.backoffLimit | string | `""` | Specifies the number of retries before marking this job failed. |
| defrag.job.completionMode | string | `""` | CompletionMode specifies how Pod completions are tracked. It can be: `NonIndexed` or `Indexed`. |
| defrag.job.completions | string | `""` | Specifies the desired number of successfully finished pods the job should be run with. |
| defrag.job.parallelism | string | `""` | Specifies the maximum desired number of pods the job should run at any given time. |
| defrag.job.podFailurePolicy | string | `""` | Specifies the policy of handling failed pods. |
| defrag.job.suspend | bool | `false` | Suspend specifies whether the Job controller should create Pods or not. |
| defrag.job.ttlSecondsAfterFinished | string | `""` | limits the lifetime of a Job that has finished execution |
| defrag.pod.restartPolicy | string | `"OnFailure"` | Restart policy for all containers within the pod. One of `Always`, `OnFailure`, `Never`. |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| extraVolumeMounts | list | `[]` | additional volume mounts to be added to the pods |
| extraVolumes | list | `[]` | additional volumes to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"etcd-defrag.fullname"` |
| hostNetwork | bool | `false` | specify if the CronJob should run on the hostNetwork |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"bitnami/etcd"` | image repository |
| image.tag | string | `"3.5.21"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| nameOverride | string | `""` | Provide a name in place of `etcd-defrag` |
| nodeSelector | object | `{"node-role.kubernetes.io/control-plane":""}` | Node labels for pod assignment |
| podSecurityContext | object | `{}` | pod-level security context |
| resources | object | `{}` | Resource limits and requests for the controller pods. |
| securityContext | object | `{}` | container-level security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/etcd-defrag
```

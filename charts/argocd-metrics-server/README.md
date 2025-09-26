# argocd-metrics-server

A Helm chart for installing the Argo CD Metrics Server, which connects to Prometheus and can be used to display Metrics in the Argo CD UI

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/argocd-metrics-server
```

## Introduction

This chart bootstraps the [ArgoCD Metrics Server](https://github.com/argoproj-labs/argocd-extension-metrics) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+
- Argo CD version 2.6+
- Prometheus

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/argocd-metrics-server
```

These commands deploy the ArgoCD Metrics Server on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"argocd-extension-metrics.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"quay.io"` | image registory |
| image.repository | string | `"argoprojlabs/argocd-extension-metrics"` | image repository |
| image.tag | string | `"v1.0.3"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| nameOverride | string | `""` | Provide a name in place of `argocd-extension-metrics` |
| networkPolicy.additionalAnnotations | object | `{}` | Annotations to be added to the NetworkPolicies |
| networkPolicy.additionalLabels | object | `{}` | Labels to be added to the NetworkPolicies |
| networkPolicy.argocd.enabled | bool | `true` | - allow incoming traffic from Argo CD |
| networkPolicy.argocd.namespaceSelector | object | `{}` | The labels of the namespace where Argo CD is running |
| networkPolicy.argocd.podSelector | object | `{}` | The labels of the Argo CD Pods |
| networkPolicy.dns.enabled | bool | `true` | allow outgoing traffic to the Kubernetes DNS |
| networkPolicy.dns.namespaceSelector | object | `{"kubernetes.io/metadata.name":"kube-system"}` | The labels of the namespace where the Kubernetes DNS is running |
| networkPolicy.dns.podSelector | object | `{"k8s-app":"kube-dns"}` | The labels of the Kubernetes DNS Pods |
| networkPolicy.enabled | bool | `false` | - create a NetworkPolicy resource to limit the allowed traffic |
| networkPolicy.prometheus.enabled | bool | `true` | - allow outgoing traffic to Prometheus |
| networkPolicy.prometheus.podSelector | object | `{"app.kubernetes.io/name":"prometheus"}` | The labels of the Prometheus Pods |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podSecurityContext | object | `{}` | pod-level security context |
| prometheus.dashboards | string | see [values.yaml](./values.yaml) | The dashboards that will be displayed in the Argo CD UI |
| prometheus.namespace | string | `"monitoring"` | The namespace where Prometheus is running |
| prometheus.path | string | `""` | The path of the Prometheus |
| prometheus.port | int | `9090` | The port on which the Prometheus service is listening for traffic |
| prometheus.service | string | `"prometheus-operated"` | The name of the Prometheus service |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{"requests":{"cpu":"100m","memory":"100Mi"}}` | Resource limits and requests for the controller pods. |
| revisionHistoryLimit | int | `0` | The number of old ReplicaSets to retain |
| securityContext | object | `{}` | container-level security context |
| service.port | int | `9003` | Kubernetes port where service is exposed |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/argocd-metrics-server
```

## Configuring Argo CD

After a successful installation of the Argo CD Metrics Server you need to configure Argo CD to display Metrics in the UI.

Assuming you are using the official Argo CD Helm Chart, this can be achieved with the following values:

```yaml
configs:
  # this part configures the UI extension to use the Argo CD Metrics Server
  # make sure to adjust the URL to your installation
  cm:
    extension.config: |-
      extensions:
        - name: metrics
          backend:
            services:
              - url: http://argocd-metrics-server.argo.svc:9003
  # this part enables the proxy extension feature of Argo CD
  params:
    server.enable.proxy.extension: true
  # this part authorizes users to use the Metrics extension
  rbac:
    policy.csv: |
      p, role:readonly, extensions, invoke, metrics, allow
server:
  # this part downloads the UI extension and integrates it into the Argo CD UI
  extensions:
    enabled: true
    extensionList:
      - name: extension-metrics
        env:
          - name: EXTENSION_URL
            value: https://github.com/argoproj-labs/argocd-extension-metrics/releases/download/v1.0.3/extension.tar.gz
          - name: EXTENSION_CHECKSUM_URL
            value: https://github.com/argoproj-labs/argocd-extension-metrics/releases/download/v1.0.3/extension_checksums.txt
```

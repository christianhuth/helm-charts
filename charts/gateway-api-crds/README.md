# gateway-api-crds

Kubernetes Gateway API CustomResourceDefinitions (standard and experimental channel)

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/gateway-api-crds
```

## Introduction

This chart installs the [Gateway API](https://gateway-api.sigs.k8s.io) CustomResourceDefinitions on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It tracks upstream [releases](https://github.com/kubernetes-sigs/gateway-api/releases) and vendors both the `standard` and `experimental` channel CRD bundles, each as its own subchart. Enable exactly one of `standard.enabled`/`experimental.enabled`, and use that subchart's `crds.*` values to opt individual CRDs in or out.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/gateway-api-crds
```

These commands deploy the standard-channel Gateway API CRDs on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Note**: Gateway API CRDs are cluster-scoped. Uninstalling this chart deletes the CRDs, which deletes every `Gateway`/`HTTPRoute`/etc. object cluster-wide. Set `global.resourcePolicy.keep: true` if you want `helm uninstall` to leave the CRDs in place.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| experimental.enabled | bool | `false` | Installs the experimental-channel Gateway API CRDs (includes everything in the standard channel plus newer, less stable resource kinds and fields). |
| global.resourcePolicy.keep | bool | `false` | When `true`, adds the `helm.sh/resource-policy: keep` annotation to every CRD so `helm uninstall` (and rollbacks) won't delete them. |
| standard.enabled | bool | `true` | Installs the standard-channel Gateway API CRDs. Enable exactly one of `standard.enabled`/`experimental.enabled` -- enabling both or neither fails the install with a clear error. |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/gateway-api-crds
```

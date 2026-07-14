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

It tracks upstream [releases](https://github.com/kubernetes-sigs/gateway-api/releases) and vendors both the `standard` and `experimental` channel CRD bundles. Use `channel` to pick which one is installed, and `crds.*` to opt individual CRDs in or out.

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

> **Note**: Gateway API CRDs are cluster-scoped. Uninstalling this chart deletes the CRDs, which deletes every `Gateway`/`HTTPRoute`/etc. object cluster-wide. Set `resourcePolicy.keep: true` if you want `helm uninstall` to leave the CRDs in place.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| channel | string | `"standard"` | Which Gateway API release channel to install CRDs from. `standard` is the stable/production channel; `experimental` additionally includes newer, less stable resource kinds, plus extra experimental fields on some of the standard-channel kinds. |
| crds.backendtlspolicies | bool | `true` | Installs the BackendTLSPolicy CRD. |
| crds.gatewayclasses | bool | `true` | Installs the GatewayClass CRD. |
| crds.gateways | bool | `true` | Installs the Gateway CRD. |
| crds.grpcroutes | bool | `true` | Installs the GRPCRoute CRD. |
| crds.httproutes | bool | `true` | Installs the HTTPRoute CRD. |
| crds.referencegrants | bool | `true` | Installs the ReferenceGrant CRD. |
| crds.tcproutes | bool | `true` | Installs the TCPRoute CRD. Experimental channel only. |
| crds.tlsroutes | bool | `true` | Installs the TLSRoute CRD. Experimental channel only. |
| crds.udproutes | bool | `true` | Installs the UDPRoute CRD. Experimental channel only. |
| crds.xbackendtrafficpolicies | bool | `true` | Installs the XBackendTrafficPolicy CRD. Experimental channel only. |
| crds.xlistenersets | bool | `true` | Installs the XListenerSet CRD. Experimental channel only. |
| crds.xmeshes | bool | `true` | Installs the XMesh CRD. Experimental channel only. |
| resourcePolicy.keep | bool | `false` | When `true`, adds the `helm.sh/resource-policy: keep` annotation to every CRD so `helm uninstall` (and rollbacks) won't delete them. |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/gateway-api-crds
```

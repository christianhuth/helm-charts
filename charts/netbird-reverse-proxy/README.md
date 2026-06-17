# netbird-reverse-proxy

A Helm chart for deploying the NetBird Reverse Proxy, which provides HTTP and HTTPS reverse proxy functionality for NetBird-managed services.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/netbird-reverse-proxy
```

## Introduction

This chart bootstraps the [NetBird Reverse Proxy](https://docs.netbird.io/manage/reverse-proxy) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

The NetBird Reverse Proxy provides reverse proxy functionality for NetBird-managed services. It can be deployed behind an existing Ingress controller or Gateway API route (with cert-manager handling TLS), or exposed directly via a LoadBalancer with built-in ACME (Let's Encrypt) certificate management. See the [Architecture](#architecture) section for guidance on choosing the right topology for your setup.

## Prerequisites

- Kubernetes 1.19+
- A NetBird management server
- A valid proxy token (`NB_PROXY_TOKEN`)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/netbird-reverse-proxy \
  --set proxy.managementAddress="https://my-netbird-management.example.com" \
  --set proxy.domain="my-proxy.example.com" \
  --set proxy.auth.token="my-proxy-token"
```

These commands deploy the NetBird Reverse Proxy on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Architecture

The reverse proxy can be exposed in two ways. Choose the one that fits your infrastructure.

### Topology A: Ingress or HTTPRoute with cert-manager (default)

TLS is terminated by an Ingress controller or Gateway API route. cert-manager issues the certificate. The proxy itself receives plain HTTP from the cluster-internal Ingress backend and forwards it to the NetBird management server. This is the recommended approach if you already operate an Ingress controller.

```
Client → Ingress / HTTPRoute (cert-manager TLS) → reverse-proxy (HTTP) → management server
```

Key settings:

```yaml
proxy:
  acmeCertificates: false   # cert-manager handles TLS, not the proxy
  allowInsecure: true        # proxy accepts plain HTTP from the Ingress backend
  address: ":80"             # listen on HTTP

service:
  type: ClusterIP            # only reachable inside the cluster; Ingress routes to it

persistence:
  enabled: false             # no certificates to store
```

> **Note for gRPC traffic**: The NetBird management server communicates over gRPC (HTTP/2). Make sure your Ingress controller supports it. For nginx, add the annotation `nginx.ingress.kubernetes.io/backend-protocol: "GRPC"`. Gateway API HTTPRoute handles HTTP/2 natively.

### Topology B: LoadBalancer with built-in ACME

The proxy is exposed directly via a cloud LoadBalancer and manages its own TLS certificate using ACME (Let's Encrypt). Port 80 is used for the ACME HTTP-01 challenge; port 443 serves HTTPS traffic. This is the simplest setup when no Ingress controller is available.

```
Client → LoadBalancer IP → reverse-proxy (ACME TLS, port 443) → management server
```

Key settings:

```yaml
proxy:
  acmeCertificates: true     # proxy requests its own certificate from Let's Encrypt
  allowInsecure: false        # proxy terminates TLS itself
  address: ":443"             # listen on HTTPS
  domain: "my-proxy.example.com"  # required for ACME certificate issuance

service:
  type: LoadBalancer          # proxy is directly reachable from outside the cluster

persistence:
  enabled: true               # strongly recommended to avoid hitting Let's Encrypt rate limits
  storageClassName: "my-storage-class"
```

> **Note on replicas**: When using ACME, certificate state is stored locally in the pod. Running more than one replica is not recommended as the certificates are not shared between pods, causing each pod to request its own certificate.

## Certificate Persistence

When using ACME certificates (`proxy.acmeCertificates=true`), certificates are stored in the directory defined by `proxy.certificateDirectory`. By default this uses an `emptyDir` volume, meaning certificates are **lost on pod restarts**, which can trigger repeated ACME challenges and potentially hit Let's Encrypt rate limits.

It is strongly recommended to enable persistence in production:

```console
helm install my-release christianhuth/netbird-reverse-proxy \
  --set persistence.enabled=true \
  --set persistence.storageClassName=my-storage-class
```

## Using an Existing Secret for the Proxy Token

Instead of providing the token in plain text via `proxy.auth.token`, create a Kubernetes Secret first:

```console
kubectl create secret generic my-netbird-proxy-secret --from-literal=token=my-proxy-token
```

Then reference it:

```console
helm install my-release christianhuth/netbird-reverse-proxy \
  --set proxy.auth.existingSecret=my-netbird-proxy-secret
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod assignment |
| autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling. Note: Not recommended when using ACME certificates as certificate state is not shared. |
| autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| extraEnvFrom | list | `[]` | additional environment variables from ConfigMaps or Secrets |
| fullnameOverride | string | `""` | String to fully override `"netbird-reverse-proxy.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"netbirdio/reverse-proxy"` | image repository |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| ingress.enabled | bool | `false` | Enable ingress record generation. Note: This is typically not needed as the reverse proxy handles TLS termination itself. |
| ingress.hosts | list | see [values.yaml](./values.yaml) | An array with hosts and paths |
| ingress.tls | list | `[]` | An array with the tls configuration |
| nameOverride | string | `""` | Provide a name in place of `netbird-reverse-proxy` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| persistence.accessModes | list | `["ReadWriteOnce"]` | The desired access modes the volume should have |
| persistence.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| persistence.enabled | bool | `false` | Enable persistent storage for TLS certificates. Recommended when proxy.acmeCertificates=true to avoid re-requesting certificates on pod restarts. |
| persistence.existingClaim | string | `""` | Provide an existing PersistentVolumeClaim. If set, no new PVC will be created. |
| persistence.resources | object | `{"requests":{"storage":"1Gi"}}` | Represents the minimum and maximum resources the volume should have |
| persistence.storageClassName | string | `""` | Name of the StorageClass required by the claim |
| podAnnotations | object | `{}` | Annotations to be added to the pods |
| podSecurityContext | object | `{}` | pod-level security context |
| proxy.acmeCertificates | bool | `false` | Enable ACME (Let's Encrypt) certificate management (NB_PROXY_ACME_CERTIFICATES). When enabled, certificates are stored in the directory specified by proxy.certificateDirectory. Consider enabling persistence.enabled=true to avoid certificate loss on pod restarts. |
| proxy.address | string | `":80"` | Address the HTTPS proxy listener binds to (NB_PROXY_ADDRESS) |
| proxy.allowInsecure | bool | `true` | Allow insecure (non-TLS) connections to upstream services (NB_PROXY_ALLOW_INSECURE) |
| proxy.auth.existingSecret | string | `""` | Name of an existing secret containing the proxy token. If set, proxy.auth.token will be ignored. The secret must contain a key named `token`. |
| proxy.auth.token | string | `""` | Proxy authentication token (NB_PROXY_TOKEN). It is strongly recommended to use proxy.auth.existingSecret instead of providing the token here. |
| proxy.certificateDirectory | string | `"/certs"` | Directory where TLS certificates are stored (NB_PROXY_CERTIFICATE_DIRECTORY) |
| proxy.domain | string | `""` | Domain name the proxy serves (NB_PROXY_DOMAIN) |
| proxy.logLevel | string | `"info"` | Log level for the proxy (NB_PROXY_LOG_LEVEL) |
| proxy.managementAddress | string | `""` | Address of the NetBird management server (NB_PROXY_MANAGEMENT_ADDRESS) |
| proxy.private | bool | `true` | Whether this is a private proxy (NB_PROXY_PRIVATE) |
| replicaCount | int | `1` | Number of replicas. Note: When using ACME certificates (proxy.acmeCertificates=true), running more than one replica is not recommended as certificate state is not shared between pods. |
| resources | object | `{}` | Resource limits and requests for the controller pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| route.main.additionalRules | list | `[]` | Additional custom rules that can be added to the route |
| route.main.annotations | object | `{}` | Add annotations to the route |
| route.main.apiVersion | string | `"gateway.networking.k8s.io/v1"` | Set the route apiVersion, e.g. gateway.networking.k8s.io/v1 or gateway.networking.k8s.io/v1alpha2 |
| route.main.enabled | bool | `false` | Enables or disables the route |
| route.main.filters | list | `[]` | Filters define the filters that are applied to requests that match this rule. |
| route.main.hostnames | list | `[]` | Hostnames to be matched |
| route.main.httpsRedirect | bool | `false` | adds a filter for redirecting to https (HTTP 301 Moved Permanently). To redirect HTTP traffic to HTTPS, you need to have a Gateway with both HTTP and HTTPS listeners. Matches and filters do not take effect if enabled. Ref. https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/ |
| route.main.kind | string | `"HTTPRoute"` | Set the route kind Valid options are GRPCRoute, HTTPRoute, TCPRoute, TLSRoute, UDPRoute |
| route.main.labels | object | `{}` | Add labels to the route |
| route.main.matches | list | see [values.yaml](./values.yaml) | define conditions used for matching the rule against incoming HTTP requests. |
| route.main.parentRefs | list | `[]` | Parent references (Gateway) |
| route.main.timeouts | object | `{}` | defines the timeouts that can be configured for an HTTP request |
| securityContext | object | `{}` | container-level security context. Note: The proxy needs to bind to ports 80 and 443 which may require elevated privileges depending on your cluster configuration. |
| service.annotations | object | `{}` | Additional annotations for the Service resource |
| service.http.port | int | `80` | Kubernetes service port for HTTP traffic |
| service.https.port | int | `443` | Kubernetes service port for HTTPS traffic |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/netbird-reverse-proxy
```

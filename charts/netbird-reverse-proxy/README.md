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

The NetBird Reverse Proxy provides reverse proxy functionality for NetBird-managed services. **It always terminates TLS itself** - it cannot run behind a load balancer or Gateway that terminates TLS and forwards plain HTTP to it. See the [Architecture](#architecture) section before choosing how to expose it and where its certificate comes from.

## Prerequisites

- Kubernetes 1.19+
- A NetBird management server
- A valid proxy token (`NB_PROXY_TOKEN`)
- Either cert-manager (recommended, for the default certificate source) or a public DNS record and internet-reachable proxy (for the built-in ACME alternative)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/netbird-reverse-proxy \
  --set proxy.managementServer.address="https://my-netbird-management.example.com" \
  --set proxy.domain="my-proxy.example.com" \
  --set proxy.auth.token="my-proxy-token" \
  --set proxy.tls.existingSecret="my-proxy-tls"
```

This installs the chart in its default configuration: a `LoadBalancer` Service, and a TLS certificate sourced from an existing Secret (`my-proxy-tls`, normally created by cert-manager - see [Architecture](#architecture)). The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Architecture

### Why this proxy can't sit behind a normal Ingress

The NetBird Reverse Proxy always terminates TLS itself for client-facing traffic - there is no plain-HTTP listener it can fall back to. This rules out a standard Kubernetes `Ingress` or a Gateway API `HTTPRoute` attached to an HTTPS listener, because both terminate TLS *before* forwarding the request, and would hand the proxy decrypted HTTP it cannot process. [NetBird's own self-hosted docs](https://docs.netbird.io/manage/reverse-proxy) call this out explicitly: they require Traefik configured for **TLS passthrough** in front of the proxy, specifically because passthrough forwards the raw, still-encrypted TLS bytes based on the SNI hostname alone, leaving the proxy to do the actual termination.

A plain Kubernetes `Service` (`ClusterIP`, `NodePort`, or `LoadBalancer`) never terminates TLS - it only ever forwards TCP - so it is passthrough by definition and needs no special configuration. This is why this chart's default exposure is a `LoadBalancer` Service rather than an Ingress.

There are therefore two independent choices to make: where the certificate comes from, and how the proxy is reached from outside the cluster.

### Why `proxy.address` defaults to `:8443`, not `:443`

The proxy's container image runs as a non-root user, and binding a port below 1024 (like 443) as non-root requires the `NET_BIND_SERVICE` capability - which may not be grantable on every cluster (some admission policies or sandboxed runtimes block it even when correctly requested). To avoid that dependency entirely, `proxy.address` defaults to the binary's own non-privileged default, `:8443`. This only changes where the proxy listens *inside* the container - `service.https.port` still defaults to the conventional `443` *externally*: the Service's `https` port has a named `targetPort` that always points at whatever port `proxy.address` resolves to, so clients still connect to `https://your-domain` with no port suffix needed.

If you do need the container to bind a privileged port directly (for example, `proxy.tls.source=acme`, see below), set `proxy.address` back to `:443` and add the `NET_BIND_SERVICE` capability under `securityContext.capabilities.add`.

### `proxy.private`: NetBird-Only services

`proxy.private` (`NB_PROXY_PRIVATE`) advertises this proxy cluster's support for ["NetBird-Only" private services](https://netbird.io/knowledge-hub/netbird-only-private-services) - an opt-in, per-service access-control feature you enable per-service in the NetBird UI/API, not a network-exposure setting. Most deployments don't need it, so it defaults to `false`. Enabling it makes the proxy additionally set up a **hardcoded** `:80`/`:443` listener pair for such services, regardless of what `proxy.address` is set to - so if you enable it, both of those ports need to be bindable (see the `NET_BIND_SERVICE` note above).

### Certificate source: `proxy.tls.source`

**`secret` (default)** - mount an existing Kubernetes `Secret` of type `kubernetes.io/tls` into the certificate directory. This is the natural fit if you already run cert-manager: a cert-manager `Certificate` issues into a Secret with keys `tls.crt` / `tls.key`, which are exactly the filenames the proxy expects by default. The proxy watches the certificate files and hot-reloads them, so cert-manager's automatic renewals are picked up without restarting the pod - no extra glue required.

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-proxy-tls
spec:
  secretName: my-proxy-tls
  dnsNames:
    - my-proxy.example.com
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
```

```yaml
proxy:
  tls:
    source: secret
    existingSecret: my-proxy-tls
```

**`acme`** - the proxy requests and renews its own certificate directly from Let's Encrypt (`NB_PROXY_ACME_CERTIFICATES=true`). No cert-manager dependency, but `proxy.domain` must be set, and the proxy must be reachable from the internet for the challenge. The default challenge type, `tls-alpn-01`, is always validated by Let's Encrypt on **port 443** specifically - that's not configurable - so this source requires setting `proxy.address` back to `:443` (and granting `NET_BIND_SERVICE`, see above) rather than using the chart's non-privileged default. Since certificate state lives on local disk inside the pod:

- enable `persistence.enabled=true` so the certificate survives pod restarts (otherwise every restart re-requests a certificate and can hit Let's Encrypt rate limits)
- keep `replicaCount: 1` and leave `autoscaling.enabled=false` - certificate state is not shared between pods, so each replica would request its own certificate independently

```yaml
proxy:
  address: ":443"
  domain: "my-proxy.example.com"
  tls:
    source: acme

securityContext:
  capabilities:
    add:
      - NET_BIND_SERVICE

persistence:
  enabled: true
  storageClassName: "my-storage-class"
```

**`selfSigned`** - the chart generates a self-signed certificate for `proxy.domain` and stores it in a Secret it manages itself, with no external dependency at all (no cert-manager, no internet access for ACME). The generated certificate is re-used across upgrades (the chart looks up the existing Secret before generating a new one), but is never automatically rotated - delete the generated Secret yourself to force regeneration. This is meant for CI/testing pipelines that can't run cert-manager or reach the internet for ACME, or for fully private/internal deployments where clients don't need a publicly-trusted certificate. It is not a substitute for `secret` in a production setup with real external clients.

```yaml
proxy:
  domain: "my-proxy.example.com"
  tls:
    source: selfSigned
```

### Exposure: `service.type=LoadBalancer`

This is the normal way to run this proxy: the Service gets its own external IP directly from your cloud provider or MetalLB, and since a Service is always L4, passthrough is automatic - no special configuration needed. Pair it with [external-dns](https://github.com/kubernetes-sigs/external-dns) to publish a DNS record for the assigned IP automatically, matching the hostname configured in `proxy.domain` / your certificate:

```yaml
service:
  type: LoadBalancer
  annotations:
    external-dns.alpha.kubernetes.io/hostname: my-proxy.example.com
```

This chart intentionally does not support Ingress or Gateway API routes: both terminate TLS by design, which - as explained above - this proxy cannot run behind. If you need to multiplex several TLS-terminating backends behind a single shared IP via SNI, that is a deliberate, more advanced setup (Gateway API `TLSRoute` with a `Passthrough` listener) that is outside the scope of this chart - the dedicated LoadBalancer above is the supported path.

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
| autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling. Note: Not recommended when using built-in ACME certificates (proxy.tls.source=acme) as certificate state is not shared between pods. |
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
| nameOverride | string | `""` | Provide a name in place of `netbird-reverse-proxy` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| persistence.accessModes | list | `["ReadWriteOnce"]` | The desired access modes the volume should have |
| persistence.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| persistence.enabled | bool | `false` | Enable persistent storage for the certs directory. Only relevant when proxy.tls.source=acme; recommended in that case to avoid re-requesting a certificate on every pod restart. Has no effect when proxy.tls.source=secret, since the certificate is mounted directly from the Secret. |
| persistence.existingClaim | string | `""` | Provide an existing PersistentVolumeClaim. If set, no new PVC will be created. |
| persistence.resources | object | `{"requests":{"storage":"1Gi"}}` | Represents the minimum and maximum resources the volume should have |
| persistence.storageClassName | string | `""` | Name of the StorageClass required by the claim |
| podAnnotations | object | `{}` | Annotations to be added to the pods |
| podSecurityContext | object | see [values.yaml](./values.yaml) | pod-level security context |
| proxy.address | string | `":8443"` | Address the proxy's main TLS listener binds to (NB_PROXY_ADDRESS). The proxy always terminates TLS itself for client-facing traffic - there is no plain-HTTP mode for this listener. Defaults to the binary's own non-privileged default port, so the container never needs to bind a privileged port (<1024) itself; service.https.port still exposes the conventional 443 externally - the Service's named targetPort maps it to whatever numeric port is set here. Must be in ":PORT" form (no host part) - the chart derives the container's port from it. |
| proxy.auth.existingSecret | string | `""` | Name of an existing secret containing the proxy token. If set, proxy.auth.token will be ignored. The secret must contain a key named `token`. |
| proxy.auth.token | string | `""` | Proxy authentication token (NB_PROXY_TOKEN). It is strongly recommended to use proxy.auth.existingSecret instead of providing the token here. |
| proxy.domain | string | `""` | Domain name the proxy serves (NB_PROXY_DOMAIN) |
| proxy.logLevel | string | `"info"` | Log level for the proxy (NB_PROXY_LOG_LEVEL) |
| proxy.managementServer.address | string | `""` | Address of the NetBird management server (NB_PROXY_MANAGEMENT_ADDRESS) |
| proxy.managementServer.allowInsecure | bool | `true` | Allow insecure connections to the management server, e.g. when it presents a self-signed certificate (NB_PROXY_ALLOW_INSECURE). Note: this flag is not documented on docs.netbird.io as of writing; verify its exact behavior against `reverse-proxy --help` for your image version if it matters for your setup. |
| proxy.private | bool | `false` | Advertises this proxy cluster's support for "NetBird-Only" private services (NB_PROXY_PRIVATE) - see https://netbird.io/knowledge-hub/netbird-only-private-services. This is an opt-in, per-service access-control feature configured in the NetBird UI/API, not a network-exposure setting - most deployments don't need it. Enabling it makes the proxy set up an additional, hardcoded :80/:443 listener pair for such services regardless of proxy.address, which requires NET_BIND_SERVICE for both ports rather than just the one proxy.address points at. |
| proxy.tls.certificateDirectory | string | `"/certs"` | Directory where TLS certificate files are read from / stored (NB_PROXY_CERTIFICATE_DIRECTORY). The proxy expects tls.crt and tls.key inside this directory (NB_PROXY_CERTIFICATE_FILE / NB_PROXY_CERTIFICATE_KEY_FILE default to those names) - which is also the default key layout of a Kubernetes Secret of type kubernetes.io/tls, so cert-manager output can be mounted as-is. |
| proxy.tls.existingSecret | string | `""` | Name of an existing Secret of type kubernetes.io/tls containing tls.crt and tls.key. Required when proxy.tls.source=secret. |
| proxy.tls.source | string | `"selfSigned"` | Source of the TLS certificate served to clients. One of: - "secret": mount an existing Kubernetes Secret of type kubernetes.io/tls (e.g. issued by a   cert-manager Certificate resource) into proxy.tls.certificateDirectory. The proxy hot-reloads   the certificate when the file changes on disk, so cert-manager renewals (which update the   Secret, which kubelet syncs to the mounted volume) are picked up without restarting the pod. - "acme": the proxy requests and renews its own certificate via ACME (Let's Encrypt) - sets   NB_PROXY_ACME_CERTIFICATES=true. Requires the proxy to be reachable from the internet and   proxy.domain to be set. The default ACME challenge type (tls-alpn-01) always validates on   port 443 regardless of proxy.address - if you use this source, set proxy.address back to   ":443" (the chart defaults it to ":8443" to avoid needing a privileged port otherwise).   Enable persistence.enabled to avoid re-requesting a certificate (and risking Let's Encrypt   rate limits) on every pod restart. - "selfSigned": the chart generates a self-signed certificate for proxy.domain (required)   and stores it in a Secret it manages itself - no external dependency at all. The generated   certificate is stable across upgrades (re-used if the Secret already exists) but is not   renewed automatically; delete the generated Secret to force regeneration. Intended for   CI/testing or fully private/internal deployments where clients don't need a   publicly-trusted certificate - not a substitute for "secret" in production. |
| replicaCount | int | `1` | Number of replicas. Note: When using built-in ACME certificates (proxy.tls.source=acme), running more than one replica is not recommended as certificate state is not shared between pods. |
| resources | object | `{}` | Resource limits and requests for the controller pods. |
| revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| securityContext | object | see [values.yaml](./values.yaml) | container-level security context. The image's default user is the non-numeric "netbird" user (uid 1000, gid 1000) - runAsUser/ runAsGroup must be set explicitly to numeric values, otherwise the kubelet cannot verify runAsNonRoot against a non-numeric image user and refuses to start the container. No capabilities need to be added by default: proxy.address defaults to the non-privileged ":8443", so the container never binds a port below 1024 itself. If you set proxy.address to a privileged port, enable proxy.private, or otherwise need port 80/443 bound directly inside the container, add the NET_BIND_SERVICE capability here yourself. |
| service.annotations | object | `{}` | Additional annotations for the Service resource. For example, to let external-dns manage a DNS record pointing at this Service's LoadBalancer IP: external-dns.alpha.kubernetes.io/hostname: my-proxy.example.com |
| service.http.port | int | `80` | Kubernetes service port for HTTP traffic. Not used by the proxy's default configuration (proxy.private=false, proxy.tls.source != "acme" with http-01) - kept for parity with NetBird's own example manifest and for setups that do need it (e.g. proxy.private=true, or HTTP-only services configured in the NetBird management UI). |
| service.https.port | int | `443` | Kubernetes service port for HTTPS traffic. Always forwards to the container port derived from proxy.address (see there), regardless of this external port number. |
| service.type | string | `"LoadBalancer"` | Kubernetes service type. LoadBalancer exposes the proxy directly with its own external IP; since a Service always operates at L4, TLS is never terminated by the Service and passes through to the proxy untouched. Combine with external-dns (see service.annotations) to automatically publish a DNS record for the assigned IP. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/netbird-reverse-proxy
```

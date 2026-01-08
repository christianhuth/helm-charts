# maildev

MailDev is a simple way to test your emails during development with an easy to use web interface.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/maildev
```

## Introduction

This chart bootstraps [MailDev](https://maildev.github.io/maildev/) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

MailDev is a simple way to test your project's generated emails during development with an easy-to-use web interface that runs on your machine.

Its main usage is to provide you with a SMTP relay service inside Kubernetes, so other apps can rely on it to send mails externally.

Inside the Namespace where it is deployed, an SMTP service is available: `RELEASE_NAME-smtp:1025`.
To make the SMTP service available for applications running outside of Kubernetes you can set `services.smtp.type` to `NodePort`.

MailDev also provides a Web interface, it can be disabled/enabled using `maildev.config.web.disabled`.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/maildev
```

These commands deploy MailDev on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Test it

Forward your local port to the pod (this will block your terminal, open an additional one).

```console
kubectl port-forward $(kubectl get pod -l "app.kubernetes.io/name=maildev" -o name) 1025
```

Create dummy mail.txt file.

```console
cat <<EOF >> mail.txt
From: Test Maildev <test@maildev.com>
To: Nikola Tesla Tudela <niko@tesla.com>
Subject: Test mail from command line
Date: Fri, 17 Nov 2020 11:26:16

Dear Joe,
Welcome to this example email. What a lovely day.
Cheers!!
EOF
```

Send the mail with curl:

```console
curl smtp://localhost:1025 --mail-from test@maildev.com --mail-rcpt niko@tesla.com --upload-file ./mail.txt
```

The mail should now show up in your inbox.

If you have enabled the logs for mails using `maildev.config.logMailContents=true`, you can also check the logs and see if the mail has been delivered.

```console
kubectl logs $(kubectl get pod -l "app.kubernetes.io/name=maildev" -o name)
```

Output should be something like:

```console
MailDev webapp running at http://0.0.0.0:1080
MailDev SMTP Server running at 0.0.0.0:1025
Received the following mail contents.
```

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
| autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| extraEnv | list | `[]` | additional environment variables to be added to the pods |
| fullnameOverride | string | `""` | String to fully override `"maildev.fullname"` |
| image.pullPolicy | string | `"Always"` | image pull policy |
| image.registry | string | `"docker.io"` | image registry |
| image.repository | string | `"maildev/maildev"` | image repository |
| image.tag | string | `"2.2.1"` | Overrides the image tag |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| ingress.enabled | bool | `false` | Enable ingress record generation |
| ingress.hosts | list | see [values.yaml](./values.yaml) | An array with hosts and paths |
| ingress.tls | list | `[]` | An array with the tls configuration |
| maildev.config.https.cert | string | `""` | The ssl cert file |
| maildev.config.https.enabled | bool | `false` | Switch from http to https protocol |
| maildev.config.https.key | string | `""` | The ssl private key |
| maildev.config.logMailContents | bool | `false` | Log a JSON representation of each incoming mail |
| maildev.config.mailDirectory | string | `"/home/node/maildev-data"` | Directory for persisting mail |
| maildev.config.modes.silent | bool | `true` | Run maildev in silent mode to disable the startup messages |
| maildev.config.modes.verbose | bool | `false` | Run maildev in verbose mode |
| maildev.config.smtp.hideExtensions | string | `""` | Comma separated list of SMTP extensions to NOT advertise (SMTPUTF8, PIPELINING, 8BITMIME) |
| maildev.config.smtp.incoming.existingSecret | string | `""` | Name of an existing secret containing the password for the incoming SMTP mail. If set `maildev.config.smtp.incoming.password` will be ignored. Key needs to be `smtp-incoming-password`. |
| maildev.config.smtp.incoming.password | string | `""` | SMTP password for incoming mail |
| maildev.config.smtp.incoming.tls.cert | string | `""` | Cert for incoming SSL |
| maildev.config.smtp.incoming.tls.enabled | bool | `false` | Use SMTP SSL for incoming emails |
| maildev.config.smtp.incoming.tls.existingSecret | string | `""` | Name of an existing TLS secret containing the cert and key for the incoming SMTP mail. If set `maildev.config.smtp.incoming.tls.cert` and `maildev.config.smtp.incoming.tls.key` will be ignored. Keys need to be `tls.crt` and `tls.key`. |
| maildev.config.smtp.incoming.tls.key | string | `""` | Key for incoming SSL |
| maildev.config.smtp.incoming.username | string | `""` | SMTP user for incoming mail |
| maildev.config.smtp.outgoing.autoRelay.enabled | bool | `false` | Enabling the auto relay mode will automatically send each email to it's recipient without the need to click the "Relay" button. The outgoing email options are required to enable this feature. |
| maildev.config.smtp.outgoing.autoRelay.mail | string | `""` | Optionally define a single email address which Maildev will forward all emails to instead of the original recipient |
| maildev.config.smtp.outgoing.autoRelay.rules | list | `[]` | The additional configuration for what email addresses you would like to allow or deny. |
| maildev.config.smtp.outgoing.existingSecret | string | `""` | Name of an existing secret containing the password for the outgoing SMTP mail. If set `maildev.config.smtp.outgoing.password` will be ignored. Key needs to be `smtp-outgoing-password`. |
| maildev.config.smtp.outgoing.host | string | `""` | SMTP host for outgoing mail |
| maildev.config.smtp.outgoing.password | string | `""` | SMTP password for outgoing mail |
| maildev.config.smtp.outgoing.port | int | `25` | SMTP port for outgoing mail |
| maildev.config.smtp.outgoing.ssl | bool | `false` | Use SMTP SSL for outgoing mail |
| maildev.config.smtp.outgoing.username | string | `""` | SMTP user for outgoing mail |
| maildev.config.web.disabled | bool | `false` | Disable the use of the web interface. Useful for unit testing |
| maildev.config.web.existingSecret | string | `""` | Name of an existing secret containing the password for the GUI. If set `maildev.config.web.password` will be ignored. Key needs to be `web-password`. |
| maildev.config.web.password | string | `""` | Password for the GUI |
| maildev.config.web.username | string | `""` | Username for the GUI |
| maildev.persistence.accessModes | list | `["ReadWriteOnce"]` | The desired access modes the volume should have. |
| maildev.persistence.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| maildev.persistence.cron.config.daysToKeep | int | `15` | How old emails may be before they get deleted |
| maildev.persistence.cron.config.schedule | string | `"0 1 * * *"` | The schedule on which the cronjob should run |
| maildev.persistence.cron.enabled | bool | `false` | Enable the creation of a cronjob to periodically delete old emails |
| maildev.persistence.cron.image.pullPolicy | string | `"Always"` | Image pull policy |
| maildev.persistence.cron.image.registry | string | `"docker.io"` | Image registry |
| maildev.persistence.cron.image.repository | string | `"busybox"` | Image repository |
| maildev.persistence.cron.image.tag | string | `"latest"` | Overrides the image tag |
| maildev.persistence.enabled | bool | `false` | Use a PVC to persist data |
| maildev.persistence.existingClaim | string | `""` | Provide an existing PersistentVolumeClaim |
| maildev.persistence.resources | object | `{"requests":{"storage":"2Gi"}}` | Represents the minimum and maximum resources the volume should have. |
| maildev.persistence.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| nameOverride | string | `""` | Provide a name in place of `maildev` |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| podAnnotations | object | `{}` | Annotations to be added to the pods |
| podSecurityContext | object | `{}` | pod-level security context |
| replicaCount | int | `1` | Number of replicas |
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
| securityContext | object | `{}` | container-level security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| services.smtp.nodePort | int | `0` | You can set the node port for the external SMTP server that should be used or leave it blank to get a random node port. Only active if `services.smtp.type == NodePort` |
| services.smtp.podPort | int | `1025` | Pod port to use for the internal SMTP server |
| services.smtp.port | int | `1025` | Kubernetes service port to use for the internal SMTP server |
| services.smtp.type | string | `"ClusterIP"` | Kubernetes service type for the SMTP server |
| services.web.podPort | int | `1080` | Pod port to use for the web GUI |
| services.web.port | int | `1080` | Kubernetes service port to use for the web GUI |
| services.web.type | string | `"ClusterIP"` | Kubernetes service type for the web GUI |
| tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/maildev
```

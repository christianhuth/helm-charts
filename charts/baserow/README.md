# baserow

Baserow is an open source no-code database and Airtable alternative.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/baserow
```

## Introduction

Baserow is an open source no-code database and Airtable alternative.

This chart bootstraps [Baserow](https://gitlab.com/bramw/baserow) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/baserow
```

These commands deploys Baserow on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| backend.asgi.affinity | object | `{}` | Affinity settings for pod assignment |
| backend.asgi.autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| backend.asgi.autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| backend.asgi.autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| backend.asgi.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| backend.asgi.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| backend.asgi.extraEnv | list | `[]` | additional environment variables to be added to the pods |
| backend.asgi.image.pullPolicy | string | `"Always"` | image pull policy |
| backend.asgi.image.registry | string | `"docker.io"` | image registory |
| backend.asgi.image.repository | string | `"baserow/backend"` | image repository |
| backend.asgi.image.tag | string | `"2.0.6"` | Overrides the image tag |
| backend.asgi.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| backend.asgi.livenessProbe.failureThreshold | int | `3` | Failure threshold for livenessProbe |
| backend.asgi.livenessProbe.initialDelaySeconds | int | `120` | Initial delay seconds for livenessProbe |
| backend.asgi.livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe |
| backend.asgi.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| backend.asgi.livenessProbe.timeoutSeconds | int | `5` | Timeout seconds for livenessProbe |
| backend.asgi.nodeSelector | object | `{}` | Node labels for pod assignment |
| backend.asgi.podAnnotations | object | `{}` | Annotations to be added to the frontend pods |
| backend.asgi.podSecurityContext | object | `{"fsGroup":9999,"runAsGroup":9999,"runAsUser":9999}` | pod-level security context |
| backend.asgi.priorityClassName | string | `""` | Pod priority class name |
| backend.asgi.readinessProbe.failureThreshold | int | `3` | Failure threshold for readinessProbe |
| backend.asgi.readinessProbe.initialDelaySeconds | int | `120` | Initial delay seconds for readinessProbe |
| backend.asgi.readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| backend.asgi.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| backend.asgi.readinessProbe.timeoutSeconds | int | `5` | Timeout seconds for readinessProbe |
| backend.asgi.replicaCount | int | `1` | Number of replicas |
| backend.asgi.resources | object | `{}` | Resource limits and requests for the controller pods. |
| backend.asgi.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| backend.asgi.route.main.additionalRules | list | `[]` | Additional custom rules that can be added to the route |
| backend.asgi.route.main.annotations | object | `{}` | Add annotations to the route |
| backend.asgi.route.main.apiVersion | string | `"gateway.networking.k8s.io/v1"` | Set the route apiVersion, e.g. gateway.networking.k8s.io/v1 or gateway.networking.k8s.io/v1alpha2 |
| backend.asgi.route.main.enabled | bool | `false` | Enables or disables the route |
| backend.asgi.route.main.filters | list | `[]` | Filters define the filters that are applied to requests that match this rule. |
| backend.asgi.route.main.hostnames | list | `[]` | Hostnames to be matched |
| backend.asgi.route.main.httpsRedirect | bool | `false` | adds a filter for redirecting to https (HTTP 301 Moved Permanently). To redirect HTTP traffic to HTTPS, you need to have a Gateway with both HTTP and HTTPS listeners. Matches and filters do not take effect if enabled. Ref. https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/ |
| backend.asgi.route.main.kind | string | `"HTTPRoute"` | Set the route kind Valid options are GRPCRoute, HTTPRoute, TCPRoute, TLSRoute, UDPRoute |
| backend.asgi.route.main.labels | object | `{}` | Add labels to the route |
| backend.asgi.route.main.matches | list | see [values.yaml](./values.yaml) | define conditions used for matching the rule against incoming HTTP requests. |
| backend.asgi.route.main.parentRefs | list | `[]` | Parent references (Gateway) |
| backend.asgi.securityContext | object | `{"runAsGroup":9999,"runAsNonRoot":true,"runAsUser":9999}` | container-level security context |
| backend.asgi.selectorLabels | object | `{}` | Additional labels to add to the pod |
| backend.asgi.service.port | int | `8000` | Kubernetes port where service is exposed |
| backend.asgi.service.type | string | `"ClusterIP"` | Kubernetes service type |
| backend.asgi.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| backend.asgi.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| backend.asgi.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| backend.asgi.tolerations | list | `[]` | Toleration labels for pod assignment |
| backend.celery.affinity | object | `{}` | Affinity settings for pod assignment |
| backend.celery.autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| backend.celery.autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| backend.celery.autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| backend.celery.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| backend.celery.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| backend.celery.extraEnv | list | `[]` | additional environment variables to be added to the pods |
| backend.celery.image.pullPolicy | string | `"Always"` | image pull policy |
| backend.celery.image.registry | string | `"docker.io"` | image registory |
| backend.celery.image.repository | string | `"baserow/backend"` | image repository |
| backend.celery.image.tag | string | `"2.0.6"` | Overrides the image tag |
| backend.celery.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| backend.celery.livenessProbe.initialDelaySeconds | int | `10` | Initial delay seconds for livenessProbe |
| backend.celery.livenessProbe.periodSeconds | int | `10` | Period seconds for livenessProbe |
| backend.celery.livenessProbe.timeoutSeconds | int | `10` | Timeout seconds for livenessProbe |
| backend.celery.nodeSelector | object | `{}` | Node labels for pod assignment |
| backend.celery.podAnnotations | object | `{}` | Annotations to be added to the frontend pods |
| backend.celery.podSecurityContext | object | `{"fsGroup":9999,"runAsGroup":9999,"runAsUser":9999}` | pod-level security context |
| backend.celery.priorityClassName | string | `""` | Pod priority class name |
| backend.celery.readinessProbe.initialDelaySeconds | int | `10` | Initial delay seconds for readinessProbe |
| backend.celery.readinessProbe.periodSeconds | int | `10` | Period seconds for readinessProbe |
| backend.celery.readinessProbe.timeoutSeconds | int | `10` | Timeout seconds for readinessProbe |
| backend.celery.replicaCount | int | `1` | Number of replicas |
| backend.celery.resources | object | `{}` | Resource limits and requests for the controller pods. |
| backend.celery.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| backend.celery.securityContext | object | `{"runAsGroup":9999,"runAsNonRoot":true,"runAsUser":9999}` | container-level security context |
| backend.celery.selectorLabels | object | `{}` | Additional labels to add to the pod |
| backend.celery.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| backend.celery.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| backend.celery.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| backend.celery.tolerations | list | `[]` | Toleration labels for pod assignment |
| backend.config.additionalApps | string | `""` | A comma separated list of additional django applications to add to the INSTALLED_APPS django setting |
| backend.config.airtableImportSoftTimeLimit | string | `"1800"` | The maximum amount of seconds an Airtable migration import job can run. |
| backend.config.amountOfGunicornWorkers | string | `""` | The number of concurrent worker processes used by the Baserow backend gunicorn server to process incoming requests |
| backend.config.aws.accessKeyId | string | `""` | The access key for your AWS account. When set to anything other than empty will switch Baserow to use a S3 compatible bucket for storing user file uploads. |
| backend.config.aws.bucketName | string | `""` | Your Amazon Web Services storage bucket name. |
| backend.config.aws.existingSecret | string | `""` | Name of existing secret to use for AWS credentials like backend.config.aws.accessKeyId and backend.config.aws.secretAccessKey. Keys in secret should be called `access-key-id` and `secret-access-key`. |
| backend.config.aws.s3CustomDomain | string | `""` | Your custom domain where the files can be downloaded from. |
| backend.config.aws.s3EndpointUrl | string | `""` | Custom S3 URL to use when connecting to S3, including scheme. |
| backend.config.aws.s3RegionName | string | `""` | Name of the AWS S3 region to use (eg. eu-west-1) |
| backend.config.aws.secretAccessKey | string | `""` | The access secret key for your AWS account. |
| backend.config.batchRowsSizeLimit | string | `"200"` | Controls how many rows can be created, deleted or updated at once using the batch endpoints. |
| backend.config.celery.amountOfWorkers | string | `""` | The number of concurrent celery worker processes used to process asynchronous tasks. If not set will default to the number of available cores. Each celery process uses memory, to reduce Baserow’s memory footprint consider setting and reducing this variable. |
| backend.config.celery.beatDebugLevel | string | `"INFO"` | The logging level for the celery beat service. |
| backend.config.celery.beatStartupDelay | string | `"15"` | The number of seconds the celery beat worker sleeps before starting up. |
| backend.config.celery.runMinimal | string | `""` | When BASEROW_AMOUNT_OF_WORKERS is 1 and this is set to a non empty value Baserow will not run the export-worker but instead run both the celery export and normal tasks on the normal celery worker. Set this to lower the memory usage of Baserow in expense of performance. |
| backend.config.disableAnonymousPublicViewWsConnections | string | `""` | When sharing views publicly a websocket connection is opened to provide realtime updates to viewers of the public link. To disable this set any non empty value. When disabled publicly shared links will need to be refreshed to see any updates to the view. |
| backend.config.disableModelCache | string | `""` | When set to any non empty value the model cache used to speed up Baserow will be disabled. Useful to enable when debugging Baserow errors if they are possibly caused by the model cache itself. |
| backend.config.dontUpdateFormulasAfterMigration | string | `""` | Baserow’s formulas have an internal version number. When upgrading Baserow if the formula language has also changed then after the database migration has run Baserow will also automatically recalculate all formulas if they have a different version. Set this to any non empty value to disable this automatic update if you would prefer to run the update_formulas management command manually yourself. Formulas might break if you forget to do so after an upgrade of Baserow until and so it is recommended to leave this empty. |
| backend.config.email.existingSecret | string | `""` | Name of existing secret to use for the email password. Key in secret should be called `email-password`. |
| backend.config.email.fromEmail | string | `""` | The email address Baserow will send emails from. |
| backend.config.email.smtp | string | `""` | If set to any non empty value then Baserow will start sending emails using the configuration options below. If not set then Baserow will not send emails and just log them to the Celery worker logs instead. |
| backend.config.email.smtpHost | string | `""` | The host of the external SMTP server that Baserow should use to send emails. |
| backend.config.email.smtpPassword | string | `""` | The password to authenticate to the smtp host when sending emails. |
| backend.config.email.smtpPort | string | `""` | The port used to connect to the smtp host. |
| backend.config.email.smtpUseTls | string | `""` | If set to any non empty value then Baserow will attempt to send emails using TLS. |
| backend.config.email.smtpUser | string | `""` | The username to authenticate to the smtp host when sending emails. |
| backend.config.enableSecureProxySslHeader | string | `""` | Set to any non-empty value to ensure Baserow generates https:// next links provided by paginated API endpoints. Baserow will still work correctly if not enabled, this is purely for giving the correct https url for clients of the API. |
| backend.config.existingSecret | string | `""` | Name of existing secret to use for secret configuration values like backend.config.jwtSigningKey and backend.config.secretKey. Keys in secret should be called `jwt-signing-key` and `secret-key`. |
| backend.config.fileUploadSizeLimit | string | `"1048576"` | The max file size in MB allowed to be uploaded by users into a Baserow File Field. |
| backend.config.hoursUntilTrashPermanentlyDeleted | string | `""` | Items from the trash will be permanently deleted after this number of hours. |
| backend.config.initialCreateSyncTableDataLimit | string | `"5000"` | The maximum number of rows you can import in a synchronous way |
| backend.config.initialTableDataLimit | string | `""` | The amount of rows that can be imported when creating a table. Defaults to empty which means unlimited rows. |
| backend.config.jobs.cleanupIntervalMinutes | string | `"5"` | How often the job cleanup task will run. |
| backend.config.jobs.expirationTimeLimit | string | `"43200"` | How long before a Baserow job will be kept before being cleaned up. |
| backend.config.jobs.softTimeLimit | string | `"1800"` | The number of seconds a Baserow job can run before being terminated. |
| backend.config.jwtSigningKey | string | `""` | The signing key that is used to sign the content of generated tokens. For HMAC signing, this should be a random string with at least as many bits of data as is required by the signing protocol. See https://django-rest-framework-simplejwt.readthedocs.io/en/latest/settings.html#signing-key for more details. |
| backend.config.logging.backendDebug | string | `"off"` | If set to “on” then will enable the non production safe debug mode for the Baserow django backend. |
| backend.config.logging.backendLogLevel | string | `"INFO"` | The default log level used by the backend, supports ERROR, WARNING, INFO, DEBUG, TRACE |
| backend.config.logging.databaseLogLevel | string | `"ERROR"` | The default log level used for database related logs in the backend. Supports the same values as the normal log level. If you also enable BASEROW_BACKEND_DEBUG and set this to DEBUG you will be able to see all SQL queries in the backend logs. |
| backend.config.maxFileImportErrorCount | string | `"30"` | The max number of per row errors than can occur in a file import before an overall failure is declared. |
| backend.config.maxRowReportErrorCount | string | `"30"` | The maximum row error count tolerated before a file import fails. Before this max error count the import will continue and the non failing rows will be imported and after it, no rows are imported at all. |
| backend.config.media.root | string | `"/baserow/media"` | The folder in which the backend will store user uploaded files |
| backend.config.media.url | string | `"$PUBLIC_BACKEND_URL/media/"` | The URL at which user uploaded media files will be made available |
| backend.config.migrateOnStartup | string | `"true"` | If set to “true” when the Baserow backend service starts up it will automatically apply database migrations. Set to any other value to disable. If you disable this then you must remember to manually apply the database migrations when upgrading Baserow to a new version. |
| backend.config.minutesUntilActionCleanedUp | string | `"120"` | How long before actions are cleaned up, actions are used to let you undo/redo so this is effectively the max length of time you can undo/redo can action. |
| backend.config.postgresStartupCheckAttempts | string | `"5"` | When Baserow’s Backend service starts up it first checks to see if the postgres database is available. |
| backend.config.rowPageSizeLimit | string | `"200"` | The maximum number of rows that can be requested at once. |
| backend.config.secretKey | string | `""` | The Secret key used by Django for cryptographic signing such as generating secure password reset links and managing sessions. See https://docs.djangoproject.com/en/3.2/ref/settings/#std:setting-SECRET_KEY for more details. |
| backend.config.snapshotExpirationTimeDays | string | `"360"` | Controls when snapshots expire, set in number of days. Expired snapshots will be automatically deleted. |
| backend.config.syncTemplatesTimeLimit | string | `"1800"` | The number of seconds before the background sync templates job will timeout if not yet completed. |
| backend.config.tokens.accessTokenLifetimeMinutes | string | `"10"` | The number of minutes which specifies how long access tokens are valid. This will be converted in a timedelta value and added to the current UTC time during token generation to obtain the token’s default “exp” claim value. |
| backend.config.tokens.refreshTokenLifetimeHours | string | `"168"` | The number of hours which specifies how long refresh tokens are valid. This will be converted in a timedelta value and added to the current UTC time during token generation to obtain the token’s default “exp” claim value. |
| backend.config.triggerSyncTemplatesAfterMigration | string | `"true"` | If set to “true” when after a migration Baserow will automatically sync all builtin Baserow templates in the background. If you are using a postgres database which is constrained to fewer than 10000 rows then we recommend you disable this as the Baserow templates will go over that row limit. To disable this set to any other value than “true” |
| backend.config.waitInsteadOf409ConflictError | string | `""` | When updating or creating various resources in Baserow if another concurrent operation is ongoing (like a snapshot, duplication, import etc) which would be affected by your modification a 409 HTTP error will be returned. If you instead would prefer Baserow to not return a 409 and just block waiting until the operation finishes and then to perform the requested operation set this flag to any non-empty value. |
| backend.config.webhook.allowPrivateAddress | string | `""` | If set to any non empty value allows webhooks to access all addresses. Enabling this flag is a security risk as it will allow users to send webhook requests to internal addresses on your network. Instead consider using the three variables below first to allow access to only some internal network hostnames or IPs. |
| backend.config.webhook.ipBlacklist | string | `""` | Disabled if backend.config.webhook.allowPrivateAddress is set. List of comma seperated IP addresses or ranges that webhooks will be denied from using after the URL has been resolved to an IP using DNS. |
| backend.config.webhook.ipWhitelist | string | `""` | Disabled if backend.config.webhook.allowPrivateAddress is set. List of comma seperated IP addresses or ranges that webhooks will be allowed to use after the webhook URL has been resolved to an IP using DNS. |
| backend.config.webhook.maxCallLogEntries | string | `"10"` | The maximum number of call log entries stored per webhook. |
| backend.config.webhook.maxConsecutiveTriggerFailures | string | `"8"` | The number of consecutive trigger failures that can occur before a webhook is disabled. |
| backend.config.webhook.maxPerTable | string | `"20"` | The max number of webhooks per Baserow table. |
| backend.config.webhook.maxRetriesPerCall | string | `"8"` | The max number of retries per webhook call. |
| backend.config.webhook.requestTimeoutSeconds | string | `"5"` | How long to wait on making the webhook request before timing out. |
| backend.config.webhook.urlCheckTimeoutSecs | string | `"10"` | Disabled if backend.config.webhook.allowPrivateAddress is set. How long to wait before timing out and returning an error when checking if an url can be accessed for a webhook. |
| backend.config.webhook.urlRegexBlacklist | string | `""` | Disabled if backend.config.webhook.allowPrivateAddress is set. List of comma seperated regexes used to validate user configured webhook URLs, will show the user an error if any regexes match their webhook URL and prevent it from running. |
| backend.ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| backend.ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| backend.ingress.enabled | bool | `false` | Enable ingress record generation for the backend |
| backend.ingress.hostname | string | `""` | The publicly reachable hostname for the backend |
| backend.ingress.paths.asgiPath | string | `"/ws/"` | The path under witch the asgi backend should be reached |
| backend.ingress.paths.wsgiPath | string | `"/"` | The path under witch the wsgi backend should be reached |
| backend.ingress.tls | list | `[]` | An array with the tls configuration |
| backend.persistence.accessModes | list | `["ReadWriteOnce"]` | the desired access modes the volume should have. |
| backend.persistence.annotations | object | `{}` | Annotations to be added to the PersistentVolumeClaim |
| backend.persistence.enabled | bool | `false` | use a PVC to persist file uploads |
| backend.persistence.existingClaim | string | `""` | provide an existing PersistentVolumeClaim |
| backend.persistence.resources | object | `{}` | represents the minimum and maximum resources the volume should have. |
| backend.persistence.storageClassName | string | `""` | Name of the StorageClass required by the claim. |
| backend.wsgi.affinity | object | `{}` | Affinity settings for pod assignment |
| backend.wsgi.autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| backend.wsgi.autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| backend.wsgi.autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| backend.wsgi.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| backend.wsgi.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| backend.wsgi.extraEnv | list | `[]` | additional environment variables to be added to the pods |
| backend.wsgi.image.pullPolicy | string | `"Always"` | image pull policy |
| backend.wsgi.image.registry | string | `"docker.io"` | image registory |
| backend.wsgi.image.repository | string | `"baserow/backend"` | image repository |
| backend.wsgi.image.tag | string | `"2.0.6"` | Overrides the image tag |
| backend.wsgi.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| backend.wsgi.livenessProbe.failureThreshold | int | `3` | Failure threshold for livenessProbe |
| backend.wsgi.livenessProbe.initialDelaySeconds | int | `120` | Initial delay seconds for livenessProbe |
| backend.wsgi.livenessProbe.periodSeconds | int | `530` | Period seconds for livenessProbe |
| backend.wsgi.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| backend.wsgi.livenessProbe.timeoutSeconds | int | `5` | Timeout seconds for livenessProbe |
| backend.wsgi.nodeSelector | object | `{}` | Node labels for pod assignment |
| backend.wsgi.podAnnotations | object | `{}` | Annotations to be added to the frontend pods |
| backend.wsgi.podSecurityContext | object | `{"fsGroup":9999,"runAsGroup":9999,"runAsUser":9999}` | pod-level security context |
| backend.wsgi.priorityClassName | string | `""` | Pod priority class name |
| backend.wsgi.readinessProbe.failureThreshold | int | `3` | Failure threshold for readinessProbe |
| backend.wsgi.readinessProbe.initialDelaySeconds | int | `120` | Initial delay seconds for readinessProbe |
| backend.wsgi.readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| backend.wsgi.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| backend.wsgi.readinessProbe.timeoutSeconds | int | `5` | Timeout seconds for readinessProbe |
| backend.wsgi.replicaCount | int | `1` | Number of replicas |
| backend.wsgi.resources | object | `{}` | Resource limits and requests for the controller pods. |
| backend.wsgi.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| backend.wsgi.route.main.additionalRules | list | `[]` | Additional custom rules that can be added to the route |
| backend.wsgi.route.main.annotations | object | `{}` | Add annotations to the route |
| backend.wsgi.route.main.apiVersion | string | `"gateway.networking.k8s.io/v1"` | Set the route apiVersion, e.g. gateway.networking.k8s.io/v1 or gateway.networking.k8s.io/v1alpha2 |
| backend.wsgi.route.main.enabled | bool | `false` | Enables or disables the route |
| backend.wsgi.route.main.filters | list | `[]` | Filters define the filters that are applied to requests that match this rule. |
| backend.wsgi.route.main.hostnames | list | `[]` | Hostnames to be matched |
| backend.wsgi.route.main.httpsRedirect | bool | `false` | adds a filter for redirecting to https (HTTP 301 Moved Permanently). To redirect HTTP traffic to HTTPS, you need to have a Gateway with both HTTP and HTTPS listeners. Matches and filters do not take effect if enabled. Ref. https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/ |
| backend.wsgi.route.main.kind | string | `"HTTPRoute"` | Set the route kind Valid options are GRPCRoute, HTTPRoute, TCPRoute, TLSRoute, UDPRoute |
| backend.wsgi.route.main.labels | object | `{}` | Add labels to the route |
| backend.wsgi.route.main.matches | list | see [values.yaml](./values.yaml) | define conditions used for matching the rule against incoming HTTP requests. |
| backend.wsgi.route.main.parentRefs | list | `[]` | Parent references (Gateway) |
| backend.wsgi.securityContext | object | `{"runAsGroup":9999,"runAsNonRoot":true,"runAsUser":9999}` | container-level security context |
| backend.wsgi.selectorLabels | object | `{}` | Additional labels to add to the pod |
| backend.wsgi.service.port | int | `8000` | Kubernetes port where service is exposed |
| backend.wsgi.service.type | string | `"ClusterIP"` | Kubernetes service type |
| backend.wsgi.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| backend.wsgi.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| backend.wsgi.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| backend.wsgi.tolerations | list | `[]` | Toleration labels for pod assignment |
| config.maxImportFileSizeMb | string | `"512"` | The maximum file size in mb you can import to create a new table. Default 512Mb. |
| config.maxSnapshotsPerGroup | string | `"-1"` | Controls how many application snapshots can be created per group. |
| config.publicBackendUrl | string | `"http://localhost:8000"` | The publicly accessible URL of the backend. Should include the port if non-standard. |
| config.publicFrontendUrl | string | `"http://localhost:3000"` | The publicly accessible URL of the frontend. Should include the port if non-standard. |
| externalPostgresql.auth.database | string | `"baserow"` | Name of the database to use |
| externalPostgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| externalPostgresql.auth.password | string | `"baserow"` | Password to use |
| externalPostgresql.auth.userPasswordKey | string | `""` | Key in the secret containing the password |
| externalPostgresql.auth.userUsernameKey | string | `""` | Key in the secret containing the username |
| externalPostgresql.auth.username | string | `"baserow"` | Name of the user to use |
| externalPostgresql.hostname | string | `""` | Hostname of the PostgreSQL database |
| externalPostgresql.port | int | `5432` | Port used to connect to PostgreSQL database |
| externalRedis.auth.enabled | bool | `true` | if authentication should be used with external Redis™ |
| externalRedis.auth.existingSecret | string | `""` | Name of existing secret to use for Redis™ credentials |
| externalRedis.auth.password | string | `""` | Password to use |
| externalRedis.auth.userPasswordKey | string | `""` | Key in the secret containing the password |
| externalRedis.hostname | string | `""` | Hostname of Redis™ |
| externalRedis.port | int | `6379` | Port used to connect to Redis |
| frontend.affinity | object | `{}` | Affinity settings for pod assignment |
| frontend.autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| frontend.autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| frontend.autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| frontend.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| frontend.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| frontend.config.additionalModules | string | `""` | A list of file paths to Nuxt module.js files to load as additional Nuxt modules into Baserow on startup. |
| frontend.config.disableGoogleDocsFilePreview | string | `""` | Set to `true` or `1` to disable Google docs file preview. |
| frontend.config.disablePublicUrlCheck | string | `""` | When opening the Baserow login page a check is run to ensure the PUBLIC_BACKEND_URL/BASEROW_PUBLIC_URL variables are set correctly and your browser can correctly connect to the backend. If misconfigured an error is shown. If you wish to disable this check and warning set this to any non empty value. |
| frontend.config.downloadFileViaXhr | string | `"0"` | Set to `1` to force download links to download files via XHR query to bypass `Content-Disposition: inline` that can’t be overridden in another way. If your files are stored under another origin, you also must add CORS headers to your server. |
| frontend.extraEnv | list | `[]` | additional environment variables to be added to the pods |
| frontend.image.pullPolicy | string | `"Always"` | image pull policy |
| frontend.image.registry | string | `"docker.io"` | image registory |
| frontend.image.repository | string | `"baserow/web-frontend"` | image repository |
| frontend.image.tag | string | `"2.0.6"` | Overrides the image tag |
| frontend.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| frontend.ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| frontend.ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| frontend.ingress.enabled | bool | `false` | Enable ingress record generation for the frontend |
| frontend.ingress.hostname | string | `"chart-example.local"` | The publicly reachable hostname for the frontend |
| frontend.ingress.path | string | `"/"` | The path under witch the frontend should be reached |
| frontend.ingress.pathType | string | `"Prefix"` | Valid values: ImplementationSpecific, Exact, Prefix |
| frontend.ingress.tls | list | `[]` | An array with the tls configuration |
| frontend.livenessProbe.initialDelaySeconds | int | `5` | Initial delay seconds for livenessProbe |
| frontend.livenessProbe.periodSeconds | int | `5` | Period seconds for livenessProbe |
| frontend.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| frontend.nodeSelector | object | `{}` | Node labels for pod assignment |
| frontend.podAnnotations | object | `{}` | Annotations to be added to the frontend pods |
| frontend.podSecurityContext | object | `{"fsGroup":9999,"runAsGroup":9999,"runAsUser":9999}` | pod-level security context |
| frontend.priorityClassName | string | `""` | Pod priority class name |
| frontend.readinessProbe.initialDelaySeconds | int | `5` | Initial delay seconds for readinessProbe |
| frontend.readinessProbe.periodSeconds | int | `5` | Period seconds for readinessProbe |
| frontend.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| frontend.replicaCount | int | `1` | Number of replicas |
| frontend.resources | object | `{}` | Resource limits and requests for the controller pods. |
| frontend.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| frontend.route.main.additionalRules | list | `[]` | Additional custom rules that can be added to the route |
| frontend.route.main.annotations | object | `{}` | Add annotations to the route |
| frontend.route.main.apiVersion | string | `"gateway.networking.k8s.io/v1"` | Set the route apiVersion, e.g. gateway.networking.k8s.io/v1 or gateway.networking.k8s.io/v1alpha2 |
| frontend.route.main.enabled | bool | `false` | Enables or disables the route |
| frontend.route.main.filters | list | `[]` | Filters define the filters that are applied to requests that match this rule. |
| frontend.route.main.hostnames | list | `[]` | Hostnames to be matched |
| frontend.route.main.httpsRedirect | bool | `false` | adds a filter for redirecting to https (HTTP 301 Moved Permanently). To redirect HTTP traffic to HTTPS, you need to have a Gateway with both HTTP and HTTPS listeners. Matches and filters do not take effect if enabled. Ref. https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/ |
| frontend.route.main.kind | string | `"HTTPRoute"` | Set the route kind Valid options are GRPCRoute, HTTPRoute, TCPRoute, TLSRoute, UDPRoute |
| frontend.route.main.labels | object | `{}` | Add labels to the route |
| frontend.route.main.matches | list | see [values.yaml](./values.yaml) | define conditions used for matching the rule against incoming HTTP requests. |
| frontend.route.main.parentRefs | list | `[]` | Parent references (Gateway) |
| frontend.securityContext | object | `{"runAsGroup":9999,"runAsNonRoot":true,"runAsUser":9999}` | container-level security context |
| frontend.selectorLabels | object | `{}` | Additional labels to add to the pod |
| frontend.service.port | int | `3000` | Kubernetes port where service is exposed |
| frontend.service.type | string | `"ClusterIP"` | Kubernetes service type |
| frontend.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| frontend.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| frontend.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| frontend.tolerations | list | `[]` | Toleration labels for pod assignment |
| fullnameOverride | string | `""` | String to fully override `"baserow.fullname"` |
| nameOverride | string | `""` | Provide a name in place of `baserow` |
| postgresql.auth.database | string | `"baserow"` | Name for a custom database to create |
| postgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| postgresql.auth.password | string | `"baserow"` | Password for the custom user to create. Ignored if postgresql.auth.existingSecret is provided |
| postgresql.auth.username | string | `"baserow"` | Name for a custom user to create |
| postgresql.enabled | bool | `true` | enable PostgreSQL™ subchart from Bitnami |
| redis.architecture | string | `"standalone"` | Redis® architecture. Allowed values: standalone or replication |
| redis.auth.enabled | bool | `true` | Enable password authentication |
| redis.auth.password | string | `"baserow"` | Redis™ password |
| redis.enabled | bool | `true` | enable Redis™ subchart from Bitnami |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/baserow
```

## Upgrading the Chart

### To 6.0.0

This major updates the Redis subchart to its newest major, 24.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) you can find more information about the changes introduced in that version.

Additionally it updates the PostgreSQL subchart to its newest major, 18.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#upgrading) you can find more information about the changes introduced in that version.

### To 5.0.0

This major updates the Redis subchart to its newest major, 22.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/8.2/00-RELEASENOTES) you can find more information about the changes introduced in that version.

### To 4.0.0

This major updates the Redis subchart to its newest major, 21.2.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/8.0/00-RELEASENOTES) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the Redis subchart to its newest major, 20.6.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#to-2050) you can find more information about the changes introduced in that version.

Additionally it updates the PostgreSQL subchart to its newest major, 16.4.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1630) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the Redis subchart to its newest major, 18.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/7.2/00-RELEASENOTES) you can find more information about the changes introduced in that version.

Additionally it updates the PostgreSQL subchart to its newest major, 14.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql#to-1400) you can find more information about the changes introduced in that version.

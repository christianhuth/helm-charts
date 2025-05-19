# taiga

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.8.2](https://img.shields.io/badge/AppVersion-6.8.2-informational?style=flat-square)

Umami is a simple, fast, privacy-focused alternative to Google Analytics.

**Homepage:** <https://github.com/christianhuth/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| christianhuth | <christian@knell.it> |  |

## Source Code

* <https://github.com/taigaio/taiga-docker>
* <https://taiga.io>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | postgresql | 16.7.4 |
| oci://registry-1.docker.io/bitnamicharts | async-rabbitmq(rabbitmq) | 16.0.2 |
| oci://registry-1.docker.io/bitnamicharts | events-rabbitmq(rabbitmq) | 16.0.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| async-rabbitmq.auth.existingSecret | string | `""` | Use existing secret for password details (`async-rabbitmq.auth.password` will be ignored and picked up from this secret). The secret has to contain the key `rabbitmq-password`. |
| async-rabbitmq.auth.password | string | `"taiga"` | The password credential to be used when using an external database driver. |
| async-rabbitmq.auth.username | string | `"taiga"` | The username credential to be used when using an external database driver. |
| async-rabbitmq.enabled | bool | `true` | enable integrated RabbitMQ™ subchart from Bitnami |
| async-rabbitmq.useSsl | bool | `false` | Whether connection is encrypted with SSL/TLS or not. |
| async-rabbitmq.vhost | string | `"/taiga"` | The RabbitMQ server VHost |
| events-rabbitmq.auth.existingSecret | string | `""` | Use existing secret for password details (`events-rabbitmq.auth.password` will be ignored and picked up from this secret). The secret has to contain the key `rabbitmq-password`. |
| events-rabbitmq.auth.password | string | `"taiga"` | The password credential to be used when using an external database driver. |
| events-rabbitmq.auth.username | string | `"taiga"` | The username credential to be used when using an external database driver. |
| events-rabbitmq.enabled | bool | `true` | enable integrated RabbitMQ™ subchart from Bitnami |
| events-rabbitmq.useSsl | bool | `false` | Whether connection is encrypted with SSL/TLS or not. |
| events-rabbitmq.vhost | string | `"/taiga"` | The RabbitMQ server VHost |
| externalDatabase.auth.database | string | `"taiga"` | Name of the database to use |
| externalDatabase.auth.existingSecret | string | `""` | Name of existing secret to use for database credentials |
| externalDatabase.auth.password | string | `"taiga"` | Password to use |
| externalDatabase.auth.username | string | `"taiga"` | Name of the user to use |
| externalDatabase.host | string | `""` | Hostname of the database |
| externalDatabase.port | int | `5432` | Port used to connect to database |
| fullnameOverride | string | `""` | String to fully override `"taiga.fullname"` |
| nameOverride | string | `""` | Provide a name in place of `taiga` |
| postgresql.auth.database | string | `"taiga"` | Name for a custom database to create |
| postgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| postgresql.auth.password | string | `"taiga"` | Password for the custom user to create. Ignored if postgresql.auth.existingSecret is provided |
| postgresql.auth.username | string | `"taiga"` | Name for a custom user to create |
| postgresql.enabled | bool | `true` | enable PostgreSQL™ subchart from Bitnami |
| taiga.backend.affinity | object | `{}` | Affinity settings for pod assignment |
| taiga.backend.autoscaling.enabled | bool | `false` |  |
| taiga.backend.autoscaling.maxReplicas | int | `100` |  |
| taiga.backend.autoscaling.minReplicas | int | `1` |  |
| taiga.backend.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| taiga.backend.config.app.debug | bool | `false` |  |
| taiga.backend.config.app.defaultProjectSlugPrefix | bool | `false` | Setting this to false removes the username from project slug |
| taiga.backend.config.app.language | string | `"en-us"` |  |
| taiga.backend.config.app.telemetry | bool | `false` | Anonymous Telemetry data is collected in order to learn about the use of Taiga and improve the platform based on real scenarios |
| taiga.backend.config.security.csrfCookieSecure | bool | `true` |  |
| taiga.backend.config.security.sessionCookieSecure | bool | `true` |  |
| taiga.backend.config.webhooks.allowPrivateAddress | bool | `false` |  |
| taiga.backend.config.webhooks.allowRedirects | bool | `false` |  |
| taiga.backend.config.webhooks.enabled | bool | `true` |  |
| taiga.backend.extraEnv | list | `[]` | additional environment variables to be added to the pods |
| taiga.backend.extraEnvFrom | list | `[]` | additional environment variables to be added to the pods from configMaps or secrets |
| taiga.backend.image.pullPolicy | string | `"Always"` | image pull policy |
| taiga.backend.image.registry | string | `"docker.io"` | image registry |
| taiga.backend.image.repository | string | `"taigaio/taiga-back"` | image repository |
| taiga.backend.image.tag | string | `"6.8.2"` | Overrides the image tag |
| taiga.backend.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| taiga.backend.nodeSelector | object | `{}` | Node labels for pod assignment |
| taiga.backend.podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| taiga.backend.podSecurityContext | object | `{}` | pod-level security context |
| taiga.backend.replicaCount | int | `1` | Number of replicas |
| taiga.backend.resources | object | `{}` | Resource limits and requests for the headwind pods. |
| taiga.backend.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| taiga.backend.securityContext | object | `{}` | container-level security context |
| taiga.backend.service.port | int | `8000` | Kubernetes port where service is exposed |
| taiga.backend.service.type | string | `"ClusterIP"` | Kubernetes service type |
| taiga.backend.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| taiga.backend.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| taiga.backend.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| taiga.backend.tolerations | list | `[]` | Toleration labels for pod assignment |
| taiga.common.config.auth.github.clientId | string | `""` |  |
| taiga.common.config.auth.github.clientSecret | string | `""` |  |
| taiga.common.config.auth.github.enabled | bool | `false` | Activate login with GitHub |
| taiga.common.config.auth.github.existingSecret | string | `""` |  |
| taiga.common.config.auth.gitlab.clientId | string | `""` |  |
| taiga.common.config.auth.gitlab.clientSecret | string | `""` |  |
| taiga.common.config.auth.gitlab.enabled | bool | `false` | Activate login with GitLab |
| taiga.common.config.auth.gitlab.existingSecret | string | `""` |  |
| taiga.common.config.auth.gitlab.url | string | `""` |  |
| taiga.common.config.auth.publicRegistration.enabled | bool | `false` | To be able to use Github/Gitlab login/registration, make sure you have public registration activated |
| taiga.common.config.cryptographicSigning.algorithm | string | `"HS256"` |  |
| taiga.common.config.cryptographicSigning.audience | string | `""` |  |
| taiga.common.config.cryptographicSigning.existingSecret | string | `""` | Name of existing secret that contains the secret key for cryptographic signing. Key in secret needs to be called `secret-key`. |
| taiga.common.config.cryptographicSigning.issuer | string | `""` |  |
| taiga.common.config.cryptographicSigning.secretKey | string | `""` | The secret key that will be used in the cryptographic signing |
| taiga.common.config.cryptographicSigning.userIdClaim | string | `"user_id"` |  |
| taiga.common.config.integrations.githubImporter.clientId | string | `""` |  |
| taiga.common.config.integrations.githubImporter.clientSecret | string | `""` |  |
| taiga.common.config.integrations.githubImporter.enabled | bool | `false` | Activating this feature, you will be able to import projects from GitHub |
| taiga.common.config.integrations.githubImporter.existingSecret | string | `""` |  |
| taiga.common.config.integrations.jiraImporter.cert | string | `""` |  |
| taiga.common.config.integrations.jiraImporter.consumerKey | string | `""` |  |
| taiga.common.config.integrations.jiraImporter.enabled | bool | `false` | Activating this feature, you will be able to import projects from Jira |
| taiga.common.config.integrations.jiraImporter.existingSecret | string | `""` |  |
| taiga.common.config.integrations.jiraImporter.publicCert | string | `""` |  |
| taiga.common.config.integrations.slack.enabled | bool | `false` | Enable Slack integration in your Taiga instance |
| taiga.common.config.integrations.trelloImporter.apiKey | string | `""` |  |
| taiga.common.config.integrations.trelloImporter.enabled | bool | `false` | Activating this feature, you will be able to import projects from Trello |
| taiga.common.config.integrations.trelloImporter.existingSecret | string | `""` |  |
| taiga.common.config.integrations.trelloImporter.secretKey | string | `""` |  |
| taiga.common.extraEnv | list | `[]` | additional environment variables to be added to the backend and frontend pods |
| taiga.common.extraEnvFrom | list | `[]` | additional environment variables to be added to the backend and frontend pods from configMaps or secrets |
| taiga.common.ingress.annotations | object | `{}` |  |
| taiga.common.ingress.className | string | `""` |  |
| taiga.common.ingress.enabled | bool | `false` |  |
| taiga.common.ingress.hostname | string | `"chart-example.local"` |  |
| taiga.common.ingress.pathType | string | `"ImplementationSpecific"` |  |
| taiga.common.ingress.tls | bool | `false` |  |
| taiga.common.ingress.tlsSecretName | string | `""` |  |
| taiga.events.affinity | object | `{}` | Affinity settings for pod assignment |
| taiga.events.autoscaling.enabled | bool | `false` |  |
| taiga.events.autoscaling.maxReplicas | int | `100` |  |
| taiga.events.autoscaling.minReplicas | int | `1` |  |
| taiga.events.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| taiga.events.config.app.logLevel | string | `"info"` | Valid log level values: error, warn, info, http, verbose, debug, silly |
| taiga.events.config.app.port | int | `3023` |  |
| taiga.events.config.app.webSocketServerPort | int | `8888` |  |
| taiga.events.extraEnv | list | `[]` | additional environment variables to be added to the pods |
| taiga.events.extraEnvFrom | list | `[]` | additional environment variables to be added to the pods from configMaps or secrets |
| taiga.events.image.pullPolicy | string | `"Always"` | image pull policy |
| taiga.events.image.registry | string | `"docker.io"` | image registry |
| taiga.events.image.repository | string | `"taigaio/taiga-events"` | image repository |
| taiga.events.image.tag | string | `"6.7.0"` | Overrides the image tag |
| taiga.events.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| taiga.events.nodeSelector | object | `{}` | Node labels for pod assignment |
| taiga.events.podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| taiga.events.podSecurityContext | object | `{}` | pod-level security context |
| taiga.events.replicaCount | int | `1` | Number of replicas |
| taiga.events.resources | object | `{}` | Resource limits and requests for the headwind pods. |
| taiga.events.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| taiga.events.securityContext | object | `{}` | container-level security context |
| taiga.events.service.port | int | `8080` | Kubernetes port where service is exposed |
| taiga.events.service.type | string | `"ClusterIP"` | Kubernetes service type |
| taiga.events.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| taiga.events.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| taiga.events.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| taiga.events.tolerations | list | `[]` | Toleration labels for pod assignment |
| taiga.frontend.affinity | object | `{}` | Affinity settings for pod assignment |
| taiga.frontend.autoscaling.enabled | bool | `false` |  |
| taiga.frontend.autoscaling.maxReplicas | int | `100` |  |
| taiga.frontend.autoscaling.minReplicas | int | `1` |  |
| taiga.frontend.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| taiga.frontend.config.app.debug | bool | `false` |  |
| taiga.frontend.config.app.defaultLanguage | string | `"en"` |  |
| taiga.frontend.extraEnv | list | `[]` | additional environment variables to be added to the pods |
| taiga.frontend.extraEnvFrom | list | `[]` | additional environment variables to be added to the pods from configMaps or secrets |
| taiga.frontend.image.pullPolicy | string | `"Always"` | image pull policy |
| taiga.frontend.image.registry | string | `"docker.io"` | image registry |
| taiga.frontend.image.repository | string | `"taigaio/taiga-front"` | image repository |
| taiga.frontend.image.tag | string | `"6.8.2"` | Overrides the image tag |
| taiga.frontend.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| taiga.frontend.nodeSelector | object | `{}` | Node labels for pod assignment |
| taiga.frontend.podAnnotations | object | `{}` | Annotations to be added to exporter pods |
| taiga.frontend.podSecurityContext | object | `{}` | pod-level security context |
| taiga.frontend.replicaCount | int | `1` | Number of replicas |
| taiga.frontend.resources | object | `{}` | Resource limits and requests for the headwind pods. |
| taiga.frontend.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| taiga.frontend.securityContext | object | `{}` | container-level security context |
| taiga.frontend.service.port | int | `80` | Kubernetes port where service is exposed |
| taiga.frontend.service.type | string | `"ClusterIP"` | Kubernetes service type |
| taiga.frontend.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| taiga.frontend.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| taiga.frontend.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| taiga.frontend.tolerations | list | `[]` | Toleration labels for pod assignment |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

# squest

Squest is a self-service portal that works on top of Red Hat Ansible Automation Platform/AWX.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/squest
```

## Introduction

This chart bootstraps [Squest](https://hewlettpackard.github.io/squest) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/squest
```

These commands deploy Squest on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

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
| celery.beat.affinity | object | `{}` | Affinity settings for pod assignment |
| celery.beat.autoscaling.enabled | bool | `false` |  |
| celery.beat.autoscaling.maxReplicas | int | `100` |  |
| celery.beat.autoscaling.minReplicas | int | `1` |  |
| celery.beat.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| celery.beat.config.django.debug | bool | `false` | Django DEBUG mode. |
| celery.beat.config.django.gunicornWorkers | int | `4` | Number of workers used by Gunicorn process in charge of serving client connection. Increase the number of worker threads to serve more clients concurrently |
| celery.beat.extraEnv | list | `[]` | additional environment variables to be added to the pods. See https://hewlettpackard.github.io/squest/latest/configuration/squest_settings for a complete list. |
| celery.beat.extraVolumeMounts | list | `[]` | additional volumeMounts to be added to the pods |
| celery.beat.extraVolumes | list | `[]` | additional volumes to be added to the pods |
| celery.beat.image.pullPolicy | string | `"Always"` | image pull policy |
| celery.beat.image.registry | string | `"quay.io"` | image registry |
| celery.beat.image.repository | string | `"hewlettpackardenterprise/squest"` | image repository |
| celery.beat.image.tag | string | `"2.8.0"` | Overrides the image tag |
| celery.beat.nodeSelector | object | `{}` | Node labels for pod assignment |
| celery.beat.podAnnotations | object | `{}` | Annotations to be added to pods |
| celery.beat.podLabels | object | `{}` | Labels to be added to pods |
| celery.beat.podSecurityContext | object | `{}` | pod-level security context |
| celery.beat.replicaCount | int | `1` | Number of replicas |
| celery.beat.resources | object | `{}` | Resource limits and requests for the pods. |
| celery.beat.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| celery.beat.securityContext | object | `{}` | container-level security context |
| celery.beat.service.port | int | `8080` | Kubernetes port where service is exposed |
| celery.beat.service.type | string | `"ClusterIP"` | Kubernetes service type |
| celery.beat.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| celery.beat.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| celery.beat.serviceAccount.name | string | `""` | The name of the service account to use If not set and create is true, a name is generated using the fullname template |
| celery.beat.tolerations | list | `[]` | Toleration labels for pod assignment |
| celery.worker.affinity | object | `{}` | Affinity settings for pod assignment |
| celery.worker.autoscaling.enabled | bool | `false` |  |
| celery.worker.autoscaling.maxReplicas | int | `100` |  |
| celery.worker.autoscaling.minReplicas | int | `1` |  |
| celery.worker.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| celery.worker.config.django.debug | bool | `false` | Django DEBUG mode. |
| celery.worker.config.django.gunicornWorkers | int | `4` | Number of workers used by Gunicorn process in charge of serving client connection. Increase the number of worker threads to serve more clients concurrently |
| celery.worker.extraEnv | list | `[]` | additional environment variables to be added to the pods. See https://hewlettpackard.github.io/squest/latest/configuration/squest_settings for a complete list. |
| celery.worker.extraVolumeMounts | list | `[]` | additional volumeMounts to be added to the pods |
| celery.worker.extraVolumes | list | `[]` | additional volumes to be added to the pods |
| celery.worker.image.pullPolicy | string | `"Always"` | image pull policy |
| celery.worker.image.registry | string | `"quay.io"` | image registry |
| celery.worker.image.repository | string | `"hewlettpackardenterprise/squest"` | image repository |
| celery.worker.image.tag | string | `"2.8.0"` | Overrides the image tag |
| celery.worker.nodeSelector | object | `{}` | Node labels for pod assignment |
| celery.worker.podAnnotations | object | `{}` | Annotations to be added to pods |
| celery.worker.podLabels | object | `{}` | Labels to be added to pods |
| celery.worker.podSecurityContext | object | `{}` | pod-level security context |
| celery.worker.replicaCount | int | `1` | Number of replicas |
| celery.worker.resources | object | `{}` | Resource limits and requests for the pods. |
| celery.worker.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| celery.worker.securityContext | object | `{}` | container-level security context |
| celery.worker.service.port | int | `8080` | Kubernetes port where service is exposed |
| celery.worker.service.type | string | `"ClusterIP"` | Kubernetes service type |
| celery.worker.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| celery.worker.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| celery.worker.serviceAccount.name | string | `""` | The name of the service account to use If not set and create is true, a name is generated using the fullname template |
| celery.worker.tolerations | list | `[]` | Toleration labels for pod assignment |
| fullnameOverride | string | `""` | String to fully override `"squest.fullname"` |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| mariadb.auth.database | string | `"squest"` | The database name to be used when using the integrated MariaDB database. |
| mariadb.auth.password | string | `"squest"` | The password credential to be used when using the integrated MariaDB database. |
| mariadb.auth.rootPassword | string | `"squest"` | The root password credential to be used when using the integrated MariaDB database. |
| mariadb.auth.username | string | `"squest"` | The username credential to be used when using the integrated MariaDB database. |
| mariadb.enabled | bool | `true` | enable integrated MariaDB™ subchart from Bitnami |
| nameOverride | string | `""` | Provide a name in place of `squest` |
| rabbitmq.auth.password | string | `"squest"` | The password credential to be used when using the integrated RabbitMQ. |
| rabbitmq.auth.username | string | `"squest"` | The username credential to be used when using the integrated RabbitMQ. |
| rabbitmq.enabled | bool | `true` | enable integrated RabbitMQ™ subchart from Bitnami |
| redis.architecture | string | `"standalone"` | Redis™ architecture. Allowed values: `standalone` or `replication` |
| redis.auth.enabled | bool | `true` | Enable password authentication |
| redis.auth.password | string | `"squest"` | The password credential to be used when using the integrated Redis. |
| redis.auth.username | string | `"squest"` | The username credential to be used when using the integrated Redis. |
| redis.enabled | bool | `true` | enable integrated Redis™ subchart from Bitnami |
| squest.affinity | object | `{}` | Affinity settings for pod assignment |
| squest.autoscaling.enabled | bool | `false` |  |
| squest.autoscaling.maxReplicas | int | `100` |  |
| squest.autoscaling.minReplicas | int | `1` |  |
| squest.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| squest.config.database.auth.database | string | `""` | The database name to be used when using an external MariaDB database. Will be ignored when you activate the integrated database with mariadb.enabled. |
| squest.config.database.auth.existingSecret | string | `""` | Use existing secret for password details (`squest.config.database.auth.password` and `squest.config.database.auth.rootPassword` will be ignored and picked up from this secret). The secret has to contain the keys `mariadb-password` and `mariadb-root-password`. |
| squest.config.database.auth.password | string | `""` | The password credential to be used when using an external MariaDB database. |
| squest.config.database.auth.rootPassword | string | `""` | The root password credential to be used when using an external MariaDB database. |
| squest.config.database.auth.username | string | `""` | The username credential to be used when using an external MariaDB database. |
| squest.config.database.host | string | `""` | The host name of the database server when using an external MariaDB database. Will be ignored when you activate the integrated database with mariadb.enabled. |
| squest.config.database.port | int | `3306` | The port in which the database service is running when using an external MariaDB database. Will be ignored when you activate the integrated database with mariadb.enabled. |
| squest.config.django.debug | bool | `false` | Django DEBUG mode. |
| squest.config.django.gunicornWorkers | int | `4` | Number of workers used by Gunicorn process in charge of serving client connection. Increase the number of worker threads to serve more clients concurrently |
| squest.config.localization.dateFormat | string | `"%d %b, %Y %H:%M"` | Change the format of all date in Squest UI. Based on Python strftime. See https://strftime.org for a strftime cheatsheet. |
| squest.config.localization.language | string | `"en-us"` | Django language. See https://docs.djangoproject.com/en/4.2/ref/settings/#language-code for details. |
| squest.config.localization.timezone | string | `"Europe/Berlin"` | Time zone of the server that host Squest service. See https://docs.djangoproject.com/en/4.2/ref/settings/#std:setting-TIME_ZONE for details. |
| squest.config.plugins.fieldValidatorPath | string | `""` | Path to form field validation modules. It is deprecated. Please use squest.config.plugins.surveyValidatorPath instead. |
| squest.config.plugins.surveyValidatorPath | string | `"plugins/survey_validators"` | Path to SurveyValidator modules. |
| squest.config.rabbitmq.auth.existingSecret | string | `""` | Use existing secret for password details (`squest.config.rabbitmq.auth.password` will be ignored and picked up from this secret). The secret has to contain the key `rabbitmq-password`. |
| squest.config.rabbitmq.auth.password | string | `""` | The password credential to be used when using an external database driver. |
| squest.config.rabbitmq.auth.username | string | `""` | The username credential to be used when using an external database driver. |
| squest.config.rabbitmq.host | string | `""` | The RabbitMQ server host name |
| squest.config.rabbitmq.vhost | string | `""` | The RabbitMQ server VHost |
| squest.config.redis.auth.existingSecret | string | `""` | Use existing secret for password details (`squest.config.redis.auth.password` will be ignored and picked up from this secret). The secret has to contain the key `redis-password`. |
| squest.config.redis.auth.password | string | `""` | The password credential to be used when using an external redis server. |
| squest.config.redis.auth.username | string | `""` | The username credential to be used when using an external redis server. |
| squest.config.smtp.auth.existingSecret | string | `""` | Use existing secret for password details (`squest.config.smtp.auth.password` will be ignored and picked up from this secret). The secret has to contain the key `smtp-password`. |
| squest.config.smtp.auth.password | string | `""` | The password credential to be used when using an external SMTP host. |
| squest.config.smtp.auth.username | string | `""` | The username credential to be used when using an external SMTP host. |
| squest.config.smtp.from | string | `"squest@squest.domain.local"` | Domain name used as email sender. |
| squest.config.smtp.host | string | `"localhost"` | The SMTP host to use for sending email. |
| squest.config.smtp.port | int | `25` | Port to use for the SMTP server defined in squest.config.email.host. |
| squest.config.smtp.useSsl | bool | `false` | Whether to use an implicit TLS (secure) connection when talking to the SMTP server defined in squest.config.smtp.host. |
| squest.config.squest.admins | string | `""` | A list of all the email who get code error notifications when squest.config.django.debug=false |
| squest.config.squest.emailNotificationEnabled | string | `""` | Set to True to enable email notifications. The default is based on the squest.config.django.debug value. |
| squest.config.squest.host | string | `"http://squest.domain.local"` | Address of the Squest portal instance. Used in email templates and in metadata sent to Red Hat Ansible Automation Platform/AWX job templates. |
| squest.config.squest.isDevServer | bool | `false` | Set to True to change the navbar and footer color to visually identify a testing instance of Squest. |
| squest.config.squest.maintenanceModeEnabled | bool | `false` | When enabled, only administrators can access squest UI and API. This can be used for example to block new requests by end users from the service catalog. So an administrator can perform operations against the API like migrating instance specs. |
| squest.extraEnv | list | `[]` | additional environment variables to be added to the squest container. See https://hewlettpackard.github.io/squest/latest/configuration/squest_settings for a complete list of available environment variables. |
| squest.extraEnvFrom | list | `[]` | load additional environment variables in the squest container from configMaps or secrets. See https://hewlettpackard.github.io/squest/latest/configuration/squest_settings for a complete list of available environment variables. |
| squest.extraVolumeMounts | list | `[]` | additional volumeMounts to be added to the squest container (nginx and init container have separate extraVolumeMounts) |
| squest.extraVolumes | list | `[]` | additional volumes to be added to the squest pods |
| squest.image.pullPolicy | string | `"Always"` | image pull policy |
| squest.image.registry | string | `"quay.io"` | image registry |
| squest.image.repository | string | `"hewlettpackardenterprise/squest"` | image repository |
| squest.image.tag | string | `"2.8.0"` | Overrides the image tag |
| squest.ingress.annotations | object | `{}` |  |
| squest.ingress.className | string | `""` |  |
| squest.ingress.enabled | bool | `false` |  |
| squest.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| squest.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| squest.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| squest.ingress.tls | list | `[]` |  |
| squest.init.extraEnv | list | `[]` | additional environment variables to be added to the init container. |
| squest.init.extraEnvFrom | list | `[]` | load additional environment variables in the init container from configMaps or secrets. |
| squest.init.extraVolumeMounts | list | `[]` | additional volumeMounts to be added to the init container |
| squest.nginx.extraEnv | list | `[]` | additional environment variables to be added to the nginx container. |
| squest.nginx.extraEnvFrom | list | `[]` | load additional environment variables in the nginx container from configMaps or secrets. |
| squest.nginx.extraVolumeMounts | list | `[]` | additional volumeMounts to be added to the nginx container |
| squest.nginx.image.pullPolicy | string | `"Always"` | image pull policy |
| squest.nginx.image.registry | string | `"docker.io"` | image registry |
| squest.nginx.image.repository | string | `"nginx"` | image repository |
| squest.nginx.image.tag | string | `"1.28.0-alpine"` | Overrides the image tag |
| squest.nodeSelector | object | `{}` | Node labels for pod assignment |
| squest.podAnnotations | object | `{}` | Annotations to be added to pods |
| squest.podLabels | object | `{}` | Labels to be added to pods |
| squest.podSecurityContext | object | `{"fsGroup":999}` | pod-level security context |
| squest.replicaCount | int | `1` | Number of replicas |
| squest.resources | object | `{}` | Resource limits and requests for the pods. |
| squest.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| squest.securityContext | object | `{}` | container-level security context |
| squest.service.port | int | `8080` | Kubernetes port where service is exposed |
| squest.service.type | string | `"ClusterIP"` | Kubernetes service type |
| squest.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| squest.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| squest.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| squest.strategy | string | `"Recreate"` | Upgrade strategy For Deployments, valid values are Recreate (default) and RollingUpdate |
| squest.tolerations | list | `[]` | Toleration labels for pod assignment |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/squest
```

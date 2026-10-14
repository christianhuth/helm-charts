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

- Kubernetes 1.26+
- The [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator) if the bundled MariaDB database is used (`mariadb.enabled: true`, the default)

### Installing the mariadb-operator

The chart bundles the database as a custom resource of the mariadb-operator (via the upstream chart [mariadb-cluster](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster)). The operator itself is not part of this chart, as it is installed once per Kubernetes cluster:

```console
helm repo add mariadb-operator https://helm.mariadb.com/mariadb-operator
helm repo update
helm upgrade --install mariadb-operator-crds mariadb-operator/mariadb-operator-crds --namespace mariadb-operator --create-namespace
helm upgrade --install mariadb-operator mariadb-operator/mariadb-operator --namespace mariadb-operator --wait
```

RabbitMQ ([cloudpirates/rabbitmq](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/rabbitmq)) and Valkey ([valkey/valkey](https://github.com/valkey-io/valkey-helm/tree/main/valkey)) are bundled as regular subcharts and don't need an operator.

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

## Configuring the Dependencies

Squest needs a MariaDB (or MySQL) database, a RabbitMQ message broker and a Redis-compatible cache. Each of them is either bundled with the chart or provided externally. Passwords are read from Secrets, using existing Secrets is recommended for production.

### MariaDB

Create a Secret containing the password of the database user and reference it in your values:

```console
kubectl create secret generic squest-database --from-literal=password='<password>'
```

```yaml
mariadb:
  mariadb:
    passwordSecretKeyRef:
      name: squest-database
      key: password
      generate: false
```

If no Secret is referenced, the operator generates a random password and stores it in the Secret `<release>-mariadb-password`. By default the database runs as a Galera cluster with 3 instances. All other settings are passed to the upstream chart, see its [values](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster) and the [MariaDB API reference](https://github.com/mariadb-operator/mariadb-operator/blob/main/docs/api_reference.md#mariadbspec).

The image tag only pins the MariaDB release series (by default the long-term support release 12.3). To upgrade to another release series, change the tag of `mariadb.mariadb.image`. The operator migrates the system schema on the rollout (`updateStrategy.mariadbAutoUpgradeEnabled`). Downgrades are not supported by MariaDB, so take a backup before upgrading.

### RabbitMQ

Create a Secret containing the password of the RabbitMQ user and reference it in your values. Squest builds its broker URL from the password without encoding it, so it must only contain URL-safe characters (`A-Z`, `a-z`, `0-9`, `-`, `.`, `_`, `~`):

```console
kubectl create secret generic squest-rabbitmq \
  --from-literal=password='<password>' \
  --from-literal=erlang-cookie='<random string>'
```

```yaml
rabbitmq:
  auth:
    username: squest
    existingSecret: squest-rabbitmq
    existingPasswordKey: password
```

If no Secret is referenced, the chart generates a random password and Erlang cookie and stores them in the Secret `<release>-rabbitmq`. By default RabbitMQ runs as a cluster of 3 instances. All other settings are passed to the upstream chart, see its [values](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/rabbitmq#parameters).

### Valkey

By default Valkey requires the inline password `squest` for the user `default`. For production, create a Secret containing the password and reference it in your values:

```console
kubectl create secret generic squest-valkey --from-literal=password='<password>'
```

```yaml
valkey:
  auth:
    enabled: true
    usersExistingSecret: squest-valkey
    aclUsers:
      default:
        permissions: "~* &* +@all"
        passwordKey: password
        password: ""
```

Like for RabbitMQ, the password must only contain URL-safe characters. All other settings are passed to the upstream chart, see its [values](https://github.com/valkey-io/valkey-helm/tree/main/valkey#values).

### External Services

Disable the bundled service and configure the external one with `externalDatabase.*`, `externalRabbitmq.*` or `externalRedis.*`, e.g.:

```yaml
mariadb:
  enabled: false

externalDatabase:
  hostname: mariadb.example.com
  port: 3306
  database: squest
  username: squest
  existingSecret: squest-database
  existingSecretPasswordKey: password
```

Instead of `existingSecret` you can set `password`, which lets the chart create the Secret.

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
| celery.beat.image.tag | string | `"2.8.4"` | Overrides the image tag |
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
| celery.worker.image.tag | string | `"2.8.4"` | Overrides the image tag |
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
| externalDatabase.database | string | `"squest"` | Name of the database to use |
| externalDatabase.existingSecret | string | `""` | Name of an existing Secret containing the password of the user |
| externalDatabase.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalDatabase.hostname | string | `""` | Hostname of the external MariaDB or MySQL database. Used if `mariadb.enabled` is false. |
| externalDatabase.password | string | `""` | Password of the user. Ignored if `externalDatabase.existingSecret` is set. |
| externalDatabase.port | int | `3306` | Port of the external database |
| externalDatabase.username | string | `"squest"` | Name of the user to use |
| externalRabbitmq.existingSecret | string | `""` | Name of an existing Secret containing the password. The password must only contain URL-safe characters. |
| externalRabbitmq.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalRabbitmq.hostname | string | `""` | Hostname of the external RabbitMQ server. Used if `rabbitmq.enabled` is false. |
| externalRabbitmq.password | string | `""` | Password of the user. Ignored if `externalRabbitmq.existingSecret` is set. Must only contain URL-safe characters. |
| externalRabbitmq.port | int | `5672` | AMQP port of the external RabbitMQ server |
| externalRabbitmq.username | string | `"squest"` | Name of the user to use |
| externalRabbitmq.vhost | string | `"/"` | Virtual host to use |
| externalRedis.existingSecret | string | `""` | Name of an existing Secret containing the password. The password must only contain URL-safe characters. |
| externalRedis.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalRedis.hostname | string | `""` | Hostname of the external Redis or Valkey server. Used if `valkey.enabled` is false. |
| externalRedis.password | string | `""` | Password of the user. Ignored if `externalRedis.existingSecret` is set. Must only contain URL-safe characters. |
| externalRedis.port | int | `6379` | Port of the external server |
| externalRedis.username | string | `"default"` | Name of the user to use |
| fullnameOverride | string | `""` | String to fully override `"squest.fullname"` |
| imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| mariadb.enabled | bool | `true` | Enable a MariaDB instance managed by the mariadb-operator. Requires the operator to be installed in the cluster (see README). |
| mariadb.mariadb.database | string | `"squest"` | Name of the database to create |
| mariadb.mariadb.galera.enabled | bool | `true` | Enable Galera to run multiple instances |
| mariadb.mariadb.image | string | `"mariadb:12.3"` | MariaDB image. The tag only pins the release series (12.3 is the current long-term support release), so restarted instances get its latest patch version. |
| mariadb.mariadb.imagePullPolicy | string | `"Always"` | Pull the image on every start to get the latest patch version of the release series |
| mariadb.mariadb.passwordSecretKeyRef.generate | bool | `true` | Let the operator generate the Secret with a random password if it does not exist |
| mariadb.mariadb.passwordSecretKeyRef.key | string | `"password"` | Key of the password inside the Secret |
| mariadb.mariadb.passwordSecretKeyRef.name | string | `""` | Name of an existing Secret containing the password of the user. If empty, the Secret `<release>-mariadb-password` is used. |
| mariadb.mariadb.replicas | int | `3` | Number of MariaDB instances. More than one instance requires Galera or replication. |
| mariadb.mariadb.storage.size | string | `"8Gi"` | Size of the PVC of each instance |
| mariadb.mariadb.updateStrategy.mariadbAutoUpgradeEnabled | bool | `true` | Run `mariadb-upgrade` on start, so that changing the release series in `image` migrates the system schema. It is a no-op if there is nothing to migrate. |
| mariadb.mariadb.username | string | `"squest"` | Name of the user to create |
| nameOverride | string | `""` | Provide a name in place of `squest` |
| rabbitmq.auth.existingPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| rabbitmq.auth.existingSecret | string | `""` | Name of an existing Secret containing the password of the default user (and the Erlang cookie) |
| rabbitmq.auth.password | string | `""` | Password of the default user. A random password is generated if empty. Ignored if `rabbitmq.auth.existingSecret` is set. |
| rabbitmq.auth.username | string | `"squest"` | Name of the default user, used by Squest |
| rabbitmq.config.extraConfiguration | string | `"deprecated_features.permit.transient_nonexcl_queues = true\n"` | Additional RabbitMQ configuration. Celery uses transient non-exclusive queues (remote control, events), which RabbitMQ denies by default since 4.3. |
| rabbitmq.enabled | bool | `true` | Enable a RabbitMQ instance (chart cloudpirates/rabbitmq) |
| rabbitmq.peerDiscoveryK8sPlugin.enabled | bool | `true` | Enable the Kubernetes peer discovery plugin to form a cluster of multiple instances |
| rabbitmq.replicaCount | int | `3` | Number of RabbitMQ instances. More than one instance requires `rabbitmq.peerDiscoveryK8sPlugin.enabled`. |
| squest.affinity | object | `{}` | Affinity settings for pod assignment |
| squest.autoscaling.enabled | bool | `false` |  |
| squest.autoscaling.maxReplicas | int | `100` |  |
| squest.autoscaling.minReplicas | int | `1` |  |
| squest.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| squest.config.django.debug | bool | `false` | Django DEBUG mode. |
| squest.config.django.gunicornWorkers | int | `4` | Number of workers used by Gunicorn process in charge of serving client connection. Increase the number of worker threads to serve more clients concurrently |
| squest.config.localization.dateFormat | string | `"%d %b, %Y %H:%M"` | Change the format of all date in Squest UI. Based on Python strftime. See https://strftime.org for a strftime cheatsheet. |
| squest.config.localization.language | string | `"en-us"` | Django language. See https://docs.djangoproject.com/en/4.2/ref/settings/#language-code for details. |
| squest.config.localization.timezone | string | `"Europe/Berlin"` | Time zone of the server that host Squest service. See https://docs.djangoproject.com/en/4.2/ref/settings/#std:setting-TIME_ZONE for details. |
| squest.config.plugins.fieldValidatorPath | string | `""` | Path to form field validation modules. It is deprecated. Please use squest.config.plugins.surveyValidatorPath instead. |
| squest.config.plugins.surveyValidatorPath | string | `"plugins/survey_validators"` | Path to SurveyValidator modules. |
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
| squest.image.tag | string | `"2.8.4"` | Overrides the image tag |
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
| squest.nginx.image.tag | string | `"1.31.6-alpine"` | Overrides the image tag |
| squest.nodeSelector | object | `{}` | Node labels for pod assignment |
| squest.podAnnotations | object | `{}` | Annotations to be added to pods |
| squest.podLabels | object | `{}` | Labels to be added to pods |
| squest.podSecurityContext | object | `{"fsGroup":999}` | pod-level security context |
| squest.replicaCount | int | `1` | Number of replicas |
| squest.resources | object | `{}` | Resource limits and requests for the pods. |
| squest.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| squest.route.main.additionalRules | list | `[]` | Additional custom rules that can be added to the route |
| squest.route.main.annotations | object | `{}` | Add annotations to the route |
| squest.route.main.apiVersion | string | `"gateway.networking.k8s.io/v1"` | Set the route apiVersion, e.g. gateway.networking.k8s.io/v1 or gateway.networking.k8s.io/v1alpha2 |
| squest.route.main.enabled | bool | `false` | Enables or disables the route |
| squest.route.main.filters | list | `[]` | Filters define the filters that are applied to requests that match this rule. |
| squest.route.main.hostnames | list | `[]` | Hostnames to be matched |
| squest.route.main.httpsRedirect | bool | `false` | adds a filter for redirecting to https (HTTP 301 Moved Permanently). To redirect HTTP traffic to HTTPS, you need to have a Gateway with both HTTP and HTTPS listeners. Matches and filters do not take effect if enabled. Ref. https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/ |
| squest.route.main.kind | string | `"HTTPRoute"` | Set the route kind Valid options are GRPCRoute, HTTPRoute, TCPRoute, TLSRoute, UDPRoute |
| squest.route.main.labels | object | `{}` | Add labels to the route |
| squest.route.main.matches | list | see [values.yaml](./values.yaml) | define conditions used for matching the rule against incoming HTTP requests. |
| squest.route.main.parentRefs | list | `[]` | Parent references (Gateway) |
| squest.route.main.timeouts | object | `{}` | defines the timeouts that can be configured for an HTTP request |
| squest.securityContext | object | `{}` | container-level security context |
| squest.service.port | int | `8080` | Kubernetes port where service is exposed |
| squest.service.type | string | `"ClusterIP"` | Kubernetes service type |
| squest.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| squest.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| squest.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| squest.strategy | string | `"Recreate"` | Upgrade strategy For Deployments, valid values are Recreate (default) and RollingUpdate |
| squest.tolerations | list | `[]` | Toleration labels for pod assignment |
| valkey.auth.aclUsers.default.password | string | `"squest"` | Inline password of the user `default`. Use `valkey.auth.usersExistingSecret` instead for production. |
| valkey.auth.aclUsers.default.permissions | string | `"~* &* +@all"` | ACL permissions of the user `default` |
| valkey.auth.enabled | bool | `true` | Enable password authentication. Squest authenticates as the user `default`. |
| valkey.auth.usersExistingSecret | string | `""` | Name of an existing Secret containing the passwords of the users (key `<user>` or `aclUsers.<user>.passwordKey`). Takes precedence over inline passwords. |
| valkey.enabled | bool | `true` | Enable a Valkey instance (official chart valkey/valkey) used by Squest as cache |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/squest
```

## Upgrading the Chart

### To 7.0.0

This major replaces the Bitnami subcharts:

- MariaDB is managed by the [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator) (upstream chart [mariadb-cluster](https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster)). Install the operator first (see [Prerequisites](#prerequisites)).
- RabbitMQ is deployed with the chart [cloudpirates/rabbitmq](https://github.com/CloudPirates-io/helm-charts/tree/main/charts/rabbitmq) and updated to RabbitMQ 4.3.
- Redis is replaced by [Valkey](https://valkey.io) with the official chart [valkey/valkey](https://github.com/valkey-io/valkey-helm/tree/main/valkey).

The values changed as follows:

- `mariadb.*`, `rabbitmq.*` and `redis.*` are replaced by the values of the new upstream charts, `redis.*` moved to `valkey.*` (see [Configuring the Dependencies](#configuring-the-dependencies))
- an inline password for the bundled MariaDB is no longer supported. Use an existing Secret or let the operator generate one
- `squest.config.database.*`, `squest.config.rabbitmq.*` and `squest.config.redis.*` are replaced by `externalDatabase.*`, `externalRabbitmq.*` and `externalRedis.*`
- Squest receives the RabbitMQ settings as `RABBITMQ_*` instead of `CELERY_BROKER_URL`, and `DB_ROOT_PASSWORD` is no longer set

The upgrade creates a new, empty database. Valkey (cache) and RabbitMQ (pending tasks) start empty as well, which is fine for Squest. To take your database along:

1. Dump the database before upgrading:

   ```console
   kubectl exec <release>-mariadb-0 -- sh -c 'mariadb-dump -u"$MARIADB_USER" -p"$(cat "$MARIADB_PASSWORD_FILE")" "$MARIADB_DATABASE"' > squest.sql
   ```

2. Remove the Bitnami RabbitMQ StatefulSet and its volume. The new RabbitMQ uses the same names, so Helm would otherwise try to patch the StatefulSet (which fails) and RabbitMQ would mount the old volume:

   ```console
   kubectl delete statefulset <release>-rabbitmq
   kubectl delete pvc data-<release>-rabbitmq-0
   ```

3. Upgrade the chart with Squest scaled down, so it does not initialize the new database. Then wait until the operator has created the database and its user:

   ```console
   helm upgrade <release> christianhuth/squest --version 7.0.0 -f values.yaml \
     --set squest.replicaCount=0 --set celery.worker.replicaCount=0 --set celery.beat.replicaCount=0 --wait
   kubectl wait --for=create user/<release>-mariadb-user grant/<release>-mariadb-user-all --timeout=10m
   kubectl wait --for=condition=Ready user/<release>-mariadb-user grant/<release>-mariadb-user-all --timeout=10m
   ```

4. Restore the dump. Use the Secret from `mariadb.mariadb.passwordSecretKeyRef` or the generated `<release>-mariadb-password`:

   ```console
   PASSWORD=$(kubectl get secret <release>-mariadb-password -o jsonpath='{.data.password}' | base64 -d)
   kubectl exec -i <release>-mariadb-0 -c mariadb -- mariadb -u squest --password="$PASSWORD" squest < squest.sql
   ```

5. Scale Squest up again:

   ```console
   helm upgrade <release> christianhuth/squest --version 7.0.0 -f values.yaml --wait
   ```

6. Once everything works, delete the old PersistentVolumeClaims `data-<release>-mariadb-0` and `redis-data-<release>-redis-master-0`.

### To 4.0.0

This major updates the Redis subchart to its newest major, 24.1.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) you can find more information about the changes introduced in that version.

Additionally it updates the MariaDB subchart to its newest major, 24.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### To 3.0.0

This major updates the Redis subchart to its newest major, 22.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/8.2/00-RELEASENOTES) you can find more information about the changes introduced in that version.

Additionally it updates the MariaDB subchart to its newest major, 22.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

### To 2.0.0

This major updates the Redis subchart to its newest major, 21.2.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/redis#upgrading) and [here](https://raw.githubusercontent.com/redis/redis/8.0/00-RELEASENOTES) you can find more information about the changes introduced in that version.

Additionally it updates the MariaDB subchart to its newest major, 21.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mariadb#upgrading) you can find more information about the changes introduced in that version.

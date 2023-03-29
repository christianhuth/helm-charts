# kutt

Kutt is a free modern URL shortener.

## TL;DR;

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/kutt
```

## Introduction

This chart bootstraps the free modern URL shortener called [Kutt](https://kutt.it) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianknell https://christianknell.github.io/helm-charts
helm repo update
helm install my-release christianknell/kutt
```

These commands deploy Kutt on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key                                        | Type   | Default                                                                                       | Description                                                                                                            |
| ------------------------------------------ | ------ | --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| affinity                                   | object | `{}`                                                                                          | Affinity settings for pod assignment                                                                                   |
| autoscaling.enabled                        | bool   | `false`                                                                                       | Enable Horizontal POD autoscaling                                                                                      |
| autoscaling.maxReplicas                    | int    | `100`                                                                                         | Maximum number of replicas                                                                                             |
| autoscaling.minReplicas                    | int    | `1`                                                                                           | Minimum number of replicas                                                                                             |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                                                                                          | Target CPU utilization percentage                                                                                      |
| externalPostgresql.auth.database           | string | `"kutt"`                                                                                      | Name of the database to use                                                                                            |
| externalPostgresql.auth.existingSecret     | string | `""`                                                                                          | Name of existing secret to use for PostgreSQL credentials                                                              |
| externalPostgresql.auth.password           | string | `"kutt"`                                                                                      | Password to use                                                                                                        |
| externalPostgresql.auth.userPasswordKey    | string | `""`                                                                                          | Key in the secret containing the password                                                                              |
| externalPostgresql.auth.username           | string | `"kutt"`                                                                                      | Name of the user to use                                                                                                |
| externalPostgresql.hostname                | string | `""`                                                                                          | Hostname of the PostgreSQL database                                                                                    |
| externalPostgresql.port                    | int    | `5432`                                                                                        | Port used to connect to PostgreSQL database                                                                            |
| externalRedis.auth.enabled                 | bool   | `true`                                                                                        | if authentication should be used with external Redis™                                                                  |
| externalRedis.auth.existingSecret          | string | `""`                                                                                          | Name of existing secret to use for Redis™ credentials                                                                  |
| externalRedis.auth.password                | string | `""`                                                                                          | Password to use                                                                                                        |
| externalRedis.auth.userPasswordKey         | string | `""`                                                                                          | Key in the secret containing the password                                                                              |
| externalRedis.hostname                     | string | `""`                                                                                          | Hostname of Redis™                                                                                                     |
| externalRedis.port                         | int    | `6379`                                                                                        | Port used to connect to Redis                                                                                          |
| extraEnv                                   | list   | `[]`                                                                                          | additional environment variables to be added to the pods                                                               |
| fullnameOverride                           | string | `""`                                                                                          | String to fully override `"kutt.fullname"`                                                                             |
| image.pullPolicy                           | string | `"Always"`                                                                                    | image pull policy                                                                                                      |
| image.repository                           | string | `"kutt/kutt"`                                                                                 | image repository                                                                                                       |
| image.tag                                  | string | `"v2.7.4"`                                                                                    | Overrides the image tag                                                                                                |
| imagePullSecrets                           | list   | `[]`                                                                                          | If defined, uses a Secret to pull an image from a private Docker registry or repository.                               |
| ingress.annotations                        | object | `{}`                                                                                          | Additional annotations for the Ingress resource                                                                        |
| ingress.className                          | string | `""`                                                                                          | IngressClass that will be be used to implement the Ingress                                                             |
| ingress.enabled                            | bool   | `false`                                                                                       | Enable ingress record generation                                                                                       |
| ingress.hosts                              | list   | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | An array with the hosts configuration                                                                                  |
| ingress.tls                                | list   | `[]`                                                                                          | An array with the tls configuration                                                                                    |
| kutt.admin.emails                          | string | `""`                                                                                          | Comma seperated list of email addresses that can access admin actions on settings page                                 |
| kutt.config.defaultMaxStatsPerLink         | string | `"5000"`                                                                                      | Max number of visits for each link to have detailed stats                                                              |
| kutt.config.disallowAnonymousLinks         | bool   | `false`                                                                                       | Disable anonymous link creation                                                                                        |
| kutt.config.disallowRegistration           | bool   | `false`                                                                                       | Disable registration                                                                                                   |
| kutt.config.linkLength                     | int    | `6`                                                                                           | Generated link length                                                                                                  |
| kutt.config.nonUserCooldown                | int    | `0`                                                                                           | Create a cooldown for non-logged in users in minutes. Set 0 to disable.                                                |
| kutt.config.siteName                       | string | `"Kutt"`                                                                                      | The name of the site where Kutt is hosted                                                                              |
| kutt.config.userLimitPerDay                | int    | `50`                                                                                          | The daily limit for each user                                                                                          |
| kutt.domain.customDomainUseHttps           | bool   | `false`                                                                                       | Use HTTPS for links with custom domain                                                                                 |
| kutt.domain.defaultDomain                  | string | `"localhost:3000"`                                                                            | The domain that this website is on                                                                                     |
| kutt.domain.useFirstIngressHost            | bool   | `false`                                                                                       | If you use an ingress to expose Kutt you can simply set this to true to use the first hostname defined in the ingress. |
| kutt.google.analytics                      | string | `""`                                                                                          |                                                                                                                        |
| kutt.google.analyticsUniversal             | string | `""`                                                                                          |                                                                                                                        |
| kutt.google.existingSecret                 | string | `""`                                                                                          |                                                                                                                        |
| kutt.google.safeBrowsingKey                | string | `""`                                                                                          |                                                                                                                        |
| kutt.jwt.existingSecret                    | string | `""`                                                                                          |                                                                                                                        |
| kutt.jwt.key                               | string | `"secret-jwt-key"`                                                                            |                                                                                                                        |
| kutt.mail.contactEmail                     | string | `""`                                                                                          | Support email to show on the app                                                                                       |
| kutt.mail.existingSecret                   | string | `""`                                                                                          |                                                                                                                        |
| kutt.mail.from                             | string | `""`                                                                                          |                                                                                                                        |
| kutt.mail.host                             | string | `""`                                                                                          |                                                                                                                        |
| kutt.mail.password                         | string | `""`                                                                                          |                                                                                                                        |
| kutt.mail.port                             | string | `""`                                                                                          |                                                                                                                        |
| kutt.mail.reportEmail                      | string | `""`                                                                                          | The email address that will receive submitted reports.                                                                 |
| kutt.mail.secure                           | bool   | `false`                                                                                       |                                                                                                                        |
| kutt.mail.username                         | string | `""`                                                                                          |                                                                                                                        |
| kutt.recaptcha.existingSecret              | string | `""`                                                                                          |                                                                                                                        |
| kutt.recaptcha.secretKey                   | string | `""`                                                                                          |                                                                                                                        |
| kutt.recaptcha.siteKey                     | string | `""`                                                                                          |                                                                                                                        |
| nameOverride                               | string | `""`                                                                                          | Provide a name in place of `kutt`                                                                                      |
| nodeSelector                               | object | `{}`                                                                                          | Node labels for pod assignment                                                                                         |
| podAnnotations                             | object | `{}`                                                                                          | Annotations to be added to exporter pods                                                                               |
| podSecurityContext                         | object | `{}`                                                                                          | pod-level security context                                                                                             |
| postgresql.auth.database                   | string | `"kutt"`                                                                                      | Name for a custom database to create                                                                                   |
| postgresql.auth.existingSecret             | string | `""`                                                                                          | Name of existing secret to use for PostgreSQL credentials                                                              |
| postgresql.auth.password                   | string | `"kutt"`                                                                                      | Password for the custom user to create. Ignored if postgresql.auth.existingSecret is provided                          |
| postgresql.auth.username                   | string | `"kutt"`                                                                                      | Name for a custom user to create                                                                                       |
| postgresql.enabled                         | bool   | `true`                                                                                        | enable PostgreSQL™ subchart from Bitnami                                                                               |
| redis.architecture                         | string | `"standalone"`                                                                                | Redis® architecture. Allowed values: standalone or replication                                                         |
| redis.auth.enabled                         | bool   | `true`                                                                                        | Enable password authentication                                                                                         |
| redis.auth.password                        | string | `"kutt"`                                                                                      | Redis™ password                                                                                                        |
| redis.enabled                              | bool   | `true`                                                                                        | enable Redis™ subchart from Bitnami                                                                                    |
| replicaCount                               | int    | `1`                                                                                           | Number of replicas                                                                                                     |
| resources                                  | object | `{}`                                                                                          | Resource limits and requests for the pods.                                                                             |
| revisionHistoryLimit                       | int    | `10`                                                                                          | The number of old ReplicaSets to retain                                                                                |
| securityContext                            | object | `{}`                                                                                          | container-level security context                                                                                       |
| service.port                               | int    | `80`                                                                                          | Kubernetes port where service is exposed                                                                               |
| service.type                               | string | `"ClusterIP"`                                                                                 | Kubernetes service type                                                                                                |
| serviceAccount.annotations                 | object | `{}`                                                                                          | Annotations to add to the service account                                                                              |
| serviceAccount.create                      | bool   | `true`                                                                                        | Specifies whether a service account should be created                                                                  |
| serviceAccount.name                        | string | `""`                                                                                          | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations                                | list   | `[]`                                                                                          | Toleration labels for pod assignment                                                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianknell/kutt
```

## Upgrading the Chart

### 2.0.0

This major updates the way you define environment variables.

- The section `mail` has been moved to `kutt.mail`
- The section `envSecrets` has been merged into `kutt`:
  - `envSecrets.google` is now `kutt.google`
  - `envSecrets.jwt` is now `kutt.jwt`
  - `envSecrets.recaptcha` is now `kutt.recaptcha`
- The section `env` has been replaced with specific values:
  - `ADMIN_EMAILS` is now `kutt.admin.emails`
  - `CUSTOM_DOMAIN_USE_HTTPS` is now `kutt.domain.customDomainUseHttps`
  - `DEFAULT_DOMAIN` is now `kutt.domain.defaultDomain`
  - `DEFAULT_MAX_STATS_PER_LINK` is now `kutt.config.defaultMaxStatsPerLink`
  - `DISALLOW_ANONYMOUS_LINKS` is now `kutt.config.disallowAnonymousLinks`
  - `DISALLOW_REGISTRATION` is now `kutt.config.disallowRegistration`
  - `LINK_LENGTH` is now `kutt.config.linkLength`
  - `NON_USER_COOLDOWN` is now `kutt.config.nonUserCooldown`
  - `REPORT_EMAIL` is now `kutt.mail.reportEmail`
  - `SITE_NAME` is now `kutt.config.siteName`
  - `USER_LIMIT_PER_DAY` is now `kutt.config.userLimitPerDay`
- You can define additional environment variables using the extraEnv section.

### 1.0.0

This major updates the PostgreSQL subchart to its newest major, 12.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#to-1200) you can find more information about the changes introduced in that version.

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

# countly

Countly is a product analytics platform that helps teams track, analyze and act-on their user actions and behaviour on mobile, web and desktop applications.

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/countly
```

## Introduction

This chart bootstraps the product analytics platform [Countly](https://github.com/Countly/countly-server) with its API and frontend on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.26+
- The [MongoDB Controllers for Kubernetes](https://github.com/mongodb/mongodb-kubernetes) if the bundled MongoDB is used (`mongodb.enabled: true`, the default)

### Installing the MongoDB Controllers for Kubernetes

The chart bundles MongoDB as a replica set managed by the operator (via the chart [mongodb-community](https://github.com/christianhuth/helm-charts/tree/main/charts/mongodb-community)). The operator itself is not part of this chart, as it is installed once per Kubernetes cluster. By default it only watches its own namespace, so set `operator.watchNamespace` to `*` or to a comma-separated list of namespaces:

```console
helm repo add mongodb https://mongodb.github.io/helm-charts
helm repo update
helm upgrade --install mongodb-kubernetes mongodb/mongodb-kubernetes --namespace mongodb-operator --create-namespace --set operator.watchNamespace="*" --wait
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/countly
```

These commands deploy Countly on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation. On the first visit of the frontend, Countly asks to create the first admin user.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuring MongoDB

Countly stores its data in the databases `countly`, `countly_drill`, `countly_fs` and `countly_out`.

### Bundled Replica Set

`mongodb.mongodb` is the spec of the `MongoDBCommunity` resource, see the chart [mongodb-community](https://github.com/christianhuth/helm-charts/tree/main/charts/mongodb-community) for all options. Countly connects with the first user in `mongodb.mongodb.users`, whose password is generated if it has no `passwordSecretRef`. To use an existing Secret instead, repeat the user with the reference:

```console
kubectl create secret generic countly-mongodb --from-literal=password='<password>'
```

```yaml
mongodb:
  mongodb:
    users:
      - name: countly
        db: admin
        passwordSecretRef:
          name: countly-mongodb
          key: password
        roles:
          - {name: readWrite, db: countly}
          - {name: readWrite, db: countly_drill}
          - {name: readWrite, db: countly_fs}
          - {name: readWrite, db: countly_out}
          - {name: clusterMonitor, db: admin}
```

By default the replica set has 3 members.

### External MongoDB

```yaml
mongodb:
  enabled: false

externalMongodb:
  hostname: mongodb.example.com
  port: 27017
  replicaSet: rs0
  username: countly
  existingSecret: countly-mongodb
  existingSecretPasswordKey: password
  options:
    authSource: admin
```

Instead of `externalMongodb.existingSecret` you can set `externalMongodb.password`, which lets the chart create the Secret. Without `externalMongodb.username`, Countly connects without authentication.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.affinity | object | `{}` | Affinity settings for pod assignment |
| api.autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| api.autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| api.autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| api.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| api.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| api.extraEnv | list | `[]` | additional environment variables to be added to the api pods |
| api.image.pullPolicy | string | `"Always"` | image pull policy |
| api.image.registry | string | `"docker.io"` | image registry |
| api.image.repository | string | `"countly/api"` | image repository |
| api.image.tag | string | `"25.05.4"` | Overrides the image tag |
| api.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| api.livenessProbe.failureThreshold | int | `6` | Failure threshold for livenessProbe |
| api.livenessProbe.initialDelaySeconds | int | `60` | Initial delay seconds for livenessProbe |
| api.livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe |
| api.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| api.livenessProbe.timeoutSeconds | int | `2` | Timeout in seconds for livenessProbe |
| api.nodeSelector | object | `{}` | Node labels for pod assignment |
| api.podAnnotations | object | `{}` | Annotations to be added to the frontend pods |
| api.podSecurityContext | object | `{}` | pod-level security context |
| api.priorityClassName | string | `""` | Pod priority class name |
| api.readinessProbe.failureThreshold | int | `6` | Failure threshold for readinessProbe |
| api.readinessProbe.initialDelaySeconds | int | `60` | Initial delay seconds for readinessProbe |
| api.readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| api.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| api.readinessProbe.timeoutSeconds | int | `2` | Timeout in seconds for readinessProbe |
| api.replicaCount | int | `1` | Number of replicas |
| api.resources | object | see [values.yaml](./values.yaml) | Resource limits and requests for the controller pods. |
| api.revisionHistoryLimit | int | `10` | The number of old ReplicaSets to retain |
| api.route.main.additionalRules | list | `[]` | Additional custom rules that can be added to the route |
| api.route.main.annotations | object | `{}` | Add annotations to the route |
| api.route.main.apiVersion | string | `"gateway.networking.k8s.io/v1"` | Set the route apiVersion, e.g. gateway.networking.k8s.io/v1 or gateway.networking.k8s.io/v1alpha2 |
| api.route.main.enabled | bool | `false` | Enables or disables the route |
| api.route.main.filters | list | `[]` | Filters define the filters that are applied to requests that match this rule. |
| api.route.main.hostnames | list | `[]` | Hostnames to be matched |
| api.route.main.httpsRedirect | bool | `false` | adds a filter for redirecting to https (HTTP 301 Moved Permanently). To redirect HTTP traffic to HTTPS, you need to have a Gateway with both HTTP and HTTPS listeners. Matches and filters do not take effect if enabled. Ref. https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/ |
| api.route.main.kind | string | `"HTTPRoute"` | Set the route kind Valid options are GRPCRoute, HTTPRoute, TCPRoute, TLSRoute, UDPRoute |
| api.route.main.labels | object | `{}` | Add labels to the route |
| api.route.main.matches | list | see [values.yaml](./values.yaml) | define conditions used for matching the rule against incoming HTTP requests. |
| api.route.main.parentRefs | list | `[]` | Parent references (Gateway) |
| api.route.main.timeouts | object | `{}` | defines the timeouts that can be configured for an HTTP request |
| api.securityContext | object | `{}` | container-level security context |
| api.selectorLabels | object | `{}` | Additional labels to add to the pod |
| api.service.port | int | `3000` | Kubernetes port where service is exposed |
| api.service.type | string | `"ClusterIP"` | Kubernetes service type |
| api.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| api.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| api.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| api.tolerations | list | `[]` | Toleration labels for pod assignment |
| config.api.mail.auth.existingSecret | string | `""` | Use existing secret for password details. The secret has to contain the key `mail-password`. When it's set the `config.api.mail.auth.password` is ignored. |
| config.api.mail.auth.password | string | `""` | The password to authenticate to the smtp host when sending emails. |
| config.api.mail.auth.username | string | `""` | The username to authenticate to the smtp host when sending emails. |
| config.api.mail.enabled | bool | `false` | Enable sending of emails |
| config.api.mail.from | string | `""` | The email address Countly will send emails from. |
| config.api.mail.host | string | `""` | The host of the external SMTP server that Countly should use to send emails. |
| config.api.mail.port | int | `0` | The port used to connect to the smtp host. |
| externalMongodb.database | string | `"countly"` | Name of the database. Countly stores further data in the databases `countly_drill`, `countly_fs` and `countly_out`. |
| externalMongodb.existingSecret | string | `""` | Name of an existing Secret containing the password of the user |
| externalMongodb.existingSecretPasswordKey | string | `"password"` | Key in the existing Secret containing the password |
| externalMongodb.hostname | string | `""` | Hostname of the external MongoDB server or of a member of its replica set |
| externalMongodb.options | object | `{}` | Additional options of the MongoDB driver, e.g. `authSource: admin` or `tls: true` |
| externalMongodb.password | string | `""` | Password of the user. Ignored if `externalMongodb.existingSecret` is set. |
| externalMongodb.port | int | `27017` | Port of the external MongoDB server |
| externalMongodb.replicaSet | string | `""` | Name of the replica set of the external MongoDB server, if any |
| externalMongodb.username | string | `""` | Username to connect with. Leave empty if the server does not require authentication. |
| extraEnv | list | `[]` | additional environment variables to be added to both api and frontend pods |
| frontend.affinity | object | `{}` | Affinity settings for pod assignment |
| frontend.autoscaling.enabled | bool | `false` | Enable Horizontal POD autoscaling |
| frontend.autoscaling.maxReplicas | int | `100` | Maximum number of replicas |
| frontend.autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| frontend.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| frontend.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| frontend.extraEnv | list | `[]` | additional environment variables to be added to the frontend pods |
| frontend.image.pullPolicy | string | `"Always"` | image pull policy |
| frontend.image.registry | string | `"docker.io"` | image registry |
| frontend.image.repository | string | `"countly/frontend"` | image repository |
| frontend.image.tag | string | `"25.05.4"` | Overrides the image tag |
| frontend.imagePullSecrets | list | `[]` | If defined, uses a Secret to pull an image from a private Docker registry or repository. |
| frontend.livenessProbe.failureThreshold | int | `6` | Failure threshold for livenessProbe |
| frontend.livenessProbe.initialDelaySeconds | int | `60` | Initial delay seconds for livenessProbe |
| frontend.livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe |
| frontend.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| frontend.livenessProbe.timeoutSeconds | int | `2` | Timeout in seconds for livenessProbe |
| frontend.nodeSelector | object | `{}` | Node labels for pod assignment |
| frontend.podAnnotations | object | `{}` | Annotations to be added to the frontend pods |
| frontend.podSecurityContext | object | `{}` | pod-level security context |
| frontend.priorityClassName | string | `""` | Pod priority class name |
| frontend.readinessProbe.failureThreshold | int | `6` | Failure threshold for readinessProbe |
| frontend.readinessProbe.initialDelaySeconds | int | `60` | Initial delay seconds for readinessProbe |
| frontend.readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| frontend.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| frontend.readinessProbe.timeoutSeconds | int | `2` | Timeout in seconds for readinessProbe |
| frontend.replicaCount | int | `1` | Number of replicas |
| frontend.resources | object | see [values.yaml](./values.yaml) | Resource limits and requests for the controller pods. |
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
| frontend.route.main.timeouts | object | `{}` | defines the timeouts that can be configured for an HTTP request |
| frontend.securityContext | object | `{}` | container-level security context |
| frontend.selectorLabels | object | `{}` | Additional labels to add to the pod |
| frontend.service.port | int | `3000` | Kubernetes port where service is exposed |
| frontend.service.type | string | `"ClusterIP"` | Kubernetes service type |
| frontend.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| frontend.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| frontend.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| frontend.tolerations | list | `[]` | Toleration labels for pod assignment |
| fullnameOverride | string | `""` | String to fully override `"baserow.fullname"` |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource |
| ingress.className | string | `""` | IngressClass that will be be used to implement the Ingress |
| ingress.enabled | bool | `false` | Enable ingress record generation |
| ingress.hostname | string | `""` | The publicly reachable hostname |
| ingress.pathType | string | `"Prefix"` | Valid values: ImplementationSpecific, Exact, Prefix |
| ingress.tls | list | `[]` | An array with the tls configuration |
| mongodb.enabled | bool | `true` | Deploy a MongoDB replica set with the chart [mongodb-community](https://github.com/christianhuth/helm-charts/tree/main/charts/mongodb-community). Requires the MongoDB Controllers for Kubernetes (see README). |
| mongodb.mongodb.users | list | see [values.yaml](./values.yaml) | Users of the replica set. Countly connects with the first user, which needs access to all databases of Countly. |
| nameOverride | string | `""` | Provide a name in place of `baserow` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/countly
```

## Upgrading the Chart

### To 6.0.0

This major replaces the Bitnami MongoDB subchart with a replica set managed by the [MongoDB Controllers for Kubernetes](https://github.com/mongodb/mongodb-kubernetes) (chart [mongodb-community](https://github.com/christianhuth/helm-charts/tree/main/charts/mongodb-community)). Install the operator first (see [Prerequisites](#prerequisites)). The values changed as follows:

- `mongodb.*` is replaced by the values of the chart mongodb-community, `mongodb.mongodb` is the spec of the `MongoDBCommunity` resource. `mongodb.architecture`, `mongodb.auth.*` and `mongodb.useStatefulSet` are removed.
- the bundled MongoDB requires authentication. Countly connects with the first user in `mongodb.mongodb.users`, whose password is generated (see [Bundled Replica Set](#bundled-replica-set))
- `externalMongodb.auth.database` moved to `externalMongodb.database`. Authentication (`externalMongodb.username`, `password`, `existingSecret`, `existingSecretPasswordKey`), `externalMongodb.replicaSet` and further driver options (`externalMongodb.options`) can be configured.
- `frontend.extraEnv` is applied to the frontend, which previously received `api.extraEnv`

The upgrade creates a new, empty replica set. The Bitnami StatefulSet is removed, but its PersistentVolumeClaim `datadir-<release>-mongodb-0` is kept. To take your data along:

1. Dump the databases before upgrading (with `mongodb.useStatefulSet: false`, use `deploy/<release>-mongodb` instead of `<release>-mongodb-0`):

   ```console
   kubectl exec <release>-mongodb-0 -- mongodump --archive --gzip > countly.archive.gz
   ```

2. Upgrade the chart with Countly scaled down, so it does not initialize the new databases. Then wait until the replica set is running:

   ```console
   helm upgrade <release> christianhuth/countly --version 6.0.0 -f values.yaml --set api.replicaCount=0 --set frontend.replicaCount=0 --wait
   kubectl wait --for=jsonpath='{.status.phase}'=Running mongodbcommunity/<release>-mongodb --timeout=10m
   ```

3. Restore the databases of Countly with its user. Use the Secret from its `passwordSecretRef` or the generated `<release>-mongodb-countly-password`:

   ```console
   PASSWORD=$(kubectl get secret <release>-mongodb-countly-password -o jsonpath='{.data.password}' | base64 -d)
   kubectl exec -i <release>-mongodb-0 -c mongod -- mongorestore --archive --gzip --host <release>-mongodb/<release>-mongodb-svc:27017 \
     --username countly --password "$PASSWORD" --authenticationDatabase admin --nsInclude='countly*.*' < countly.archive.gz
   ```

4. Scale Countly up again:

   ```console
   helm upgrade <release> christianhuth/countly --version 6.0.0 -f values.yaml --wait
   ```

5. Once everything works, delete the old PersistentVolumeClaim `datadir-<release>-mongodb-0`.

### To 5.0.0

This major updates the MongoDB subchart to its newest major, 19.0.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mongodb#upgrading) you can find more information about the changes introduced in that version.

### To 4.0.0

This major updates the MongoDB subchart to its newest major, 18.2.0. [Here](https://github.com/bitnami/charts/tree/main/bitnami/mongodb#upgrading) you can find more information about the changes introduced in that version.

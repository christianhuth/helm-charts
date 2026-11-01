# mongodb-community

MongoDB Community replica sets managed by the MongoDB Controllers for Kubernetes (mongodb-kubernetes)

## TL;DR;

```console
helm repo add christianhuth https://charts.christianhuth.de
helm repo update
helm install my-release christianhuth/mongodb-community
```

## Introduction

This chart deploys a MongoDB Community replica set as a `MongoDBCommunity` resource of the [MongoDB Controllers for Kubernetes](https://github.com/mongodb/mongodb-kubernetes) (`mongodb-kubernetes`) using the [Helm](https://helm.sh) package manager. The values below `mongodb` are rendered as the spec of the resource, so all of its fields are supported. The chart adds what the operator expects to exist: generated passwords for users and the ServiceAccount of the database pods.

## Prerequisites

- Kubernetes 1.26+
- The [MongoDB Controllers for Kubernetes](https://github.com/mongodb/mongodb-kubernetes), watching the namespace of the release

### Installing the Operator

The operator is installed once per Kubernetes cluster. By default it only watches its own namespace, so set `operator.watchNamespace` to `*` or to a comma-separated list of namespaces:

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
helm install my-release christianhuth/mongodb-community
```

These commands deploy a replica set with 3 members on the Kubernetes cluster in the default configuration. The [Values](#values) section lists the values that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```console
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. The PersistentVolumeClaims of the replica set are kept.

## Configuring the Replica Set

See the [documentation](https://github.com/mongodb/mongodb-kubernetes/tree/master/docs/mongodbcommunity) of the operator for all options of `mongodb`.

### Users

Users without `passwordSecretRef` get a random password, which the chart stores in the Secret `<fullname>-<name>-password` and keeps on upgrades. The operator applies changes of the password in the Secret and stores the connection strings of each user in the Secret `<fullname>-<db>-<name>` (keys `connectionString.standard`, `connectionString.standardSrv`, `username` and `password`):

```yaml
mongodb:
  users:
    - name: app
      db: admin
      roles:
        - name: readWrite
          db: app
    - name: admin
      db: admin
      passwordSecretRef:
        name: mongodb-admin
        key: password
      roles:
        - name: root
          db: admin
```

### Storage and Resources

The operator creates the volumes `data-volume` (10G) and `logs-volume` (2G) and the containers `mongod` and `mongodb-agent`. Both can be adjusted with `mongodb.statefulSet`, which is merged into the StatefulSet of the operator:

```yaml
mongodb:
  statefulSet:
    spec:
      volumeClaimTemplates:
        - metadata:
            name: data-volume
          spec:
            resources:
              requests:
                storage: 50Gi
      template:
        spec:
          containers:
            - name: mongod
              resources:
                requests:
                  cpu: 500m
                  memory: 1Gi
```

### TLS

The certificate of the members has to be valid for `*.<fullname>-svc.<namespace>.svc.cluster.local`:

```yaml
mongodb:
  security:
    tls:
      enabled: true
      certificateKeySecretRef:
        name: mongodb-tls # Secret of type kubernetes.io/tls
      caConfigMapRef:
        name: mongodb-ca # ConfigMap with the key ca.crt
```

### Monitoring

Setting `mongodb.prometheus` exposes the metrics of each member on port 9216 with basic authentication. Without `passwordSecretRef`, the chart generates the password in the Secret `<fullname>-prometheus`. `serviceMonitor.enabled` creates a ServiceMonitor for the Prometheus Operator:

```yaml
mongodb:
  prometheus:
    username: prometheus
serviceMonitor:
  enabled: true
```

### MongoDB Search

`search.enabled` deploys MongoDB Search for full-text and vector search as a `MongoDBSearch` resource. The chart adds the user `search-sync-source` used by the search nodes to the replica set and generates its password.

## Using the Chart as a Dependency

Charts using this chart as a dependency can call its named templates `mongodb-community.hostname`, `.port`, `.replicaSetName`, `.userPasswordSecretName`, `.userPasswordSecretKey` and `.userConnectionStringSecretName` with the context of the subchart, e.g. for the alias `mongodb`:

```yaml
{{ include "mongodb-community.userConnectionStringSecretName" (dict "context" .Subcharts.mongodb "user" "app") }}
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraManifests | list | `[]` | Additional manifests to deploy. Strings are rendered with `tpl`. |
| fullnameOverride | string | `""` | String to fully override `"mongodb-community.fullname"`. It is the name of the MongoDBCommunity resource and of its replica set. |
| mongodb.members | int | `3` | Number of members of the replica set |
| mongodb.security.authentication.modes | list | `["SCRAM"]` | Authentication mechanisms. `SCRAM` enables SCRAM-SHA-256 and SCRAM-SHA-1, `X509` requires TLS. |
| mongodb.type | string | `"ReplicaSet"` | Type of the deployment. MongoDB Community only supports replica sets. |
| mongodb.users | list | `[]` | Users of the database. If a user has no `passwordSecretRef`, the chart generates a password and stores it in the Secret `<fullname>-<name>-password` (key `password`). `scramCredentialsSecretName` defaults to `<fullname>-<name>`. |
| mongodb.version | string | `"9.0.4"` | MongoDB version. The operator requires the exact version and runs the image `quay.io/mongodb/mongodb-community-server:<version>-ubi8`. |
| nameOverride | string | `""` | Provide a name in place of `mongodb-community` |
| search.enabled | bool | `false` | Deploy MongoDB Search (MongoDBSearch resource) for full-text and vector search. Adds the user `search-sync-source` used by the search nodes to the replica set. |
| search.spec | object | see [values.yaml](./values.yaml) | Spec of the MongoDBSearch resource, rendered as is. See the [CRD](https://github.com/mongodb/mongodb-kubernetes/blob/master/helm_chart/crds/mongodb.com_mongodbsearch.yaml) for all options. |
| serviceAccount.annotations | object | `{}` | Annotations of the ServiceAccount |
| serviceAccount.create | bool | `true` | Create the ServiceAccount, Role and RoleBinding for the database pods, which need access to their Secrets and Pods |
| serviceAccount.name | string | `""` | Name of the ServiceAccount. If empty, `<fullname>-database` is used if `serviceAccount.create` is true, otherwise the operator's default `mongodb-kubernetes-appdb`. |
| serviceMonitor.enabled | bool | `false` | Create a ServiceMonitor for the Prometheus Operator. Requires `mongodb.prometheus` to be configured. |
| serviceMonitor.interval | string | `"30s"` | Interval at which metrics are scraped |
| serviceMonitor.labels | object | `{}` | Additional labels of the ServiceMonitor, e.g. to match the `serviceMonitorSelector` of Prometheus |
| serviceMonitor.scrapeTimeout | string | `"10s"` | Timeout of a scrape |
| serviceMonitor.tlsConfig | object | `{}` | TLS configuration of the scrapes, used if `mongodb.prometheus.tlsSecretKeyRef` is set |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml christianhuth/mongodb-community
```

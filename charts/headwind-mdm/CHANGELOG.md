# headwind-mdm

## 6.0.0

### Changed

- BREAKING: replaced the Bitnami PostgreSQL subchart with a PostgreSQL cluster managed by the CloudNativePG operator (upstream chart cnpg/cluster). See the upgrade notes in the README.
- BREAKING: renamed externalPostgresql to externalDatabase and flattened its auth.* keys

### Removed

- BREAKING: inline password for the bundled PostgreSQL. The operator generates the password or uses the Secret given in postgresql.cluster.initdb.secret.name

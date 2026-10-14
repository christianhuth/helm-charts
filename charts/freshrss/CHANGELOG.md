# freshrss

## 3.0.0

### Changed

- BREAKING: replaced the Bitnami PostgreSQL subchart with a PostgreSQL cluster managed by the CloudNativePG operator (upstream chart cnpg/cluster). See the upgrade notes in the README.
- BREAKING: renamed externalPostgresql to externalDatabase and flattened its auth.* keys

### Fixed

- the database password is no longer rendered in plain text into FRESHRSS_INSTALL but read from its Secret

### Removed

- BREAKING: inline password for the bundled PostgreSQL. The operator generates the password or uses the Secret given in postgresql.cluster.initdb.secret.name

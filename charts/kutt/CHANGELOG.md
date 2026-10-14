# kutt

## 10.0.0

### Changed

- BREAKING: replaced the Bitnami PostgreSQL subchart with a PostgreSQL cluster managed by the CloudNativePG operator (upstream chart cnpg/cluster). See the upgrade notes in the README.
- BREAKING: replaced the Bitnami Redis subchart with the official Valkey chart (valkey/valkey), the values moved from redis.* to valkey.*
- BREAKING: renamed externalPostgresql to externalDatabase and restructured externalRedis, both with a standardized structure

### Removed

- BREAKING: inline password for the bundled PostgreSQL. The operator generates the password or uses the Secret given in postgresql.cluster.initdb.secret.name

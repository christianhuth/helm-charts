# syncstorage-rs

## 7.0.0

### Changed

- BREAKING: replaced the Bitnami MariaDB subcharts with MariaDB instances managed by the mariadb-operator (upstream chart mariadb-cluster). See the upgrade notes in the README.
- BREAKING: moved syncstorage.syncserver-db and syncstorage.tokenserver-db to externalSyncserverDatabase and externalTokenserverDatabase with a standardized structure

### Removed

- BREAKING: inline passwords for the bundled MariaDB instances. The operator generates the passwords or uses the Secrets given in <db>.mariadb.passwordSecretKeyRef

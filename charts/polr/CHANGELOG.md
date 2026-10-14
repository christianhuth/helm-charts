# polr

## 5.0.0

### Changed

- BREAKING: replaced the Bitnami MySQL subchart with a MariaDB instance managed by the mariadb-operator (upstream chart mariadb-cluster). See the upgrade notes in the README.
- BREAKING: restructured externalDatabase (host renamed to hostname, existingSecretPasswordKey instead of the fixed key mysql-password)

### Fixed

- the bundled database is only deployed if mariadb.enabled is true, and the database password is always read from a Secret

### Removed

- BREAKING: inline password for the bundled database. The operator generates the password or uses the Secret given in mariadb.mariadb.passwordSecretKeyRef

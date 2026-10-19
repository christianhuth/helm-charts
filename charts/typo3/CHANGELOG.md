# typo3

## 8.0.0

### Added

- automatic setup of TYPO3 including the admin user (typo3.setup, typo3.admin), the database connection is updated from the values on every start (typo3.modifyConfiguration) and an optional scheduler sidecar (typo3.scheduler)
- configurable liveness, readiness and startup probes

### Changed

- BREAKING: switched the image from martinhelmich/typo3 to crinis/typo3 (legacy variant) and updated to TYPO3 13.4. TYPO3 is now set up and configured from the chart values. See the upgrade notes in the README.
- BREAKING: replaced the Bitnami MariaDB subchart with a MariaDB instance managed by the mariadb-operator (upstream chart mariadb-cluster)
- BREAKING: restructured externalDatabase (auth.* moved one level up, type removed)

### Removed

- BREAKING: the bundled MySQL and PostgreSQL databases. The image only supports MySQL and MariaDB, use the bundled MariaDB or an external MariaDB/MySQL database

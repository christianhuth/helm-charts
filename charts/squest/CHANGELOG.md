# squest

## 7.0.0

### Added

- RabbitMQ permits transient non-exclusive queues, which Celery uses for remote control and events and which RabbitMQ denies by default since 4.3

### Changed

- BREAKING: replaced the Bitnami MariaDB subchart with a MariaDB instance managed by the mariadb-operator (upstream chart mariadb-cluster). See the upgrade notes in the README.
- BREAKING: replaced the Bitnami RabbitMQ subchart with the CloudPirates RabbitMQ chart and the Bitnami Redis subchart with the official Valkey chart (valkey/valkey)
- BREAKING: moved squest.config.database, squest.config.rabbitmq and squest.config.redis to externalDatabase, externalRabbitmq and externalRedis with a standardized structure
- RabbitMQ settings are passed with RABBITMQ_* instead of CELERY_BROKER_URL, so the password is read from a Secret

### Fixed

- appVersion now reflects the Squest version instead of the nginx version

### Removed

- DB_ROOT_PASSWORD, which is not used by Squest

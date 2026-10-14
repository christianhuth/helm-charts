# shlink-backend

## 12.0.0

### Changed

- BREAKING: replaced the Bitnami PostgreSQL and MariaDB subcharts with databases managed by the CloudNativePG operator and the mariadb-operator. See the upgrade notes in the README.
- BREAKING: replaced the Bitnami RabbitMQ subchart with the CloudPirates RabbitMQ chart and the Bitnami Redis subchart with the official Valkey chart (valkey/valkey)
- BREAKING: moved config.database, config.rabbitmq and config.redis to externalDatabase, externalRabbitmq and externalRedis with a standardized structure

### Fixed

- enabling more than one bundled database fails with a clear error, the Secret for an external RabbitMQ is created when no existing Secret is given, and Redis passwords are passed with REDIS_SERVERS_PASSWORD

### Removed

- BREAKING: the bundled MySQL database. Use the bundled MariaDB or an external MySQL database

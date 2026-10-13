# kube-ops-view

## 9.0.0

### Added

- support for an external Redis/Valkey server (externalRedis.*) and for password authentication

### Changed

- BREAKING: replaced the Bitnami Redis subchart with the official Valkey chart (valkey/valkey). The values moved from redis.* to valkey.*, see the upgrade notes in the README.

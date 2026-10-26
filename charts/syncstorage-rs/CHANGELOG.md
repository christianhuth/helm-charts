# syncstorage-rs

## 8.0.0

### Added

- optional PostgreSQL database managed by the CloudNativePG operator (postgresql.enabled) and external PostgreSQL databases (external*Database.type)
- syncstorage.config.publicUrl registers the storage node in the Tokenserver database on startup (defaults to the host of the Ingress or HTTPRoute), plus syncstorage.config.nodeCapacity and syncstorage.config.allowNewUsers

### Changed

- BREAKING: switched the image from porelli/firefox-sync to the official images of Mozilla (ghcr.io/mozilla-services/syncstorage-rs/syncserver-mysql and syncserver-postgres) and updated syncstorage-rs from 0.18.2 to 0.24.0. The official images are only available for linux/amd64. See the upgrade notes in the README.
- BREAKING: a master key (syncstorage.masterKey.value or syncstorage.masterKey.existingSecret) is required, as syncstorage-rs otherwise signs its tokens with an empty secret
- the livenessProbe uses /__lbheartbeat__, so database outages no longer restart the pods

### Fixed

- the Tokenserver verifies the tokens of the production Mozilla accounts by default (syncstorage.config.fxa.*) instead of the stage environment, and SYNC_PORT is set from syncstorage.config.port

### Removed

- BREAKING: syncstorage.tokenserver-db-lock, as its init image only exists for porelli/firefox-sync. Limit the number of users with syncstorage.config.nodeCapacity or syncstorage.config.allowNewUsers instead

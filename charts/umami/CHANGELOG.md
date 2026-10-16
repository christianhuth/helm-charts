# umami

## 8.0.0

### Added

- settings introduced with Umami v3 (umami.twoFactor, umami.saltRotation, umami.useUuidV7, umami.mcpEnabled, umami.linksUrl, umami.pixelsUrl)

### Changed

- BREAKING: Umami v3 (v3.4.0), which only supports PostgreSQL. See the upgrade notes in the README.
- BREAKING: replaced the Bitnami PostgreSQL subchart with a PostgreSQL cluster managed by the CloudNativePG operator (upstream chart cnpg/cluster)
- BREAKING: restructured externalDatabase (auth.* moved one level up, password read from a Secret)

### Fixed

- umami.debug and umami.enableTestConsole are passed to Umami, and the generated APP_SECRET is kept across upgrades

### Removed

- BREAKING: MySQL support (mysql.* and externalDatabase.type), as Umami v3 only supports PostgreSQL
- BREAKING: the v1 to v2 migration job (umami.migration.v1v2) and umami.ignoreHostname, which Umami never read

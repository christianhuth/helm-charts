# countly

## 6.0.0

### Added

- init container wait-for-mongodb, which lets the api and frontend wait for the bundled replica set instead of restarting

### Changed

- BREAKING: replaced the Bitnami MongoDB subchart with a replica set managed by the MongoDB Controllers for Kubernetes (chart mongodb-community). The database now requires authentication. See the upgrade notes in the README.
- BREAKING: restructured externalMongodb (auth.database moved to database) and added authentication, replica set and driver options

### Fixed

- frontend.extraEnv is applied to the frontend instead of api.extraEnv

# mcp-for-argocd

## 2.0.0

### Added

- support for inbound authentication via a secret token

### Changed

- App Version to v0.9.0

### Fixed

- Run the http transport instead of stdio so the container listens on its port again, and bind it to 0.0.0.0 so probes and the Service can reach it (v0.9.0 defaults the listener to loopback only)

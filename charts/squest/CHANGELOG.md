# squest

## 7.1.0

### Added

- support for deployment strategy (squest.deploymentStrategy, celery.worker.deploymentStrategy and celery.beat.deploymentStrategy)

### Changed

- the Celery beat deployment uses the update strategy Recreate by default, so that two schedulers never run at the same time

### Deprecated

- squest.strategy, use squest.deploymentStrategy instead

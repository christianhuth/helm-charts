# kutt

## 5.0.0

### Added

- env variable DB_CLIENT (kutt.database.client)
- env variable DB_POOL_MAX  (kutt.database.pool.max)
- env variable and DB_POOL_MIN (kutt.database.pool.min)
- env variable MAIL_ENABLED (kutt.mail.enabled)
- env variable ENABLE_RATE_LIMIT (kutt.config.enableRateLimit)
- env variable LINK_CUSTOM_ALPHABET (kutt.config.linkCustomAlphabet)
- env variable REDIS_ENABLED (redis.enabled)

### Changed

- dependency to postgresql to 16.4.5
- dependency to redis to 20.6.3
- app version to 3.2.1

### Removed

- env variable DEFAULT_MAX_STATS_PER_LINK (kutt.config.defaultMaxStatsPerLink)
- env variable NON_USER_COOLDOWN (kutt.config.nonUserCooldown)
- env variable USER_LIMIT_PER_DAY (kutt.config.userLimitPerDay)
- env variable GOOGLE_*(kutt.google.*)

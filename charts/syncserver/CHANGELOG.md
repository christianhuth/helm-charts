# syncserver

## 1.4.2

### Fixed

- Pod crashed with the default values, as /data was not writable without persistence. An emptyDir is mounted to /data now if persistence is disabled

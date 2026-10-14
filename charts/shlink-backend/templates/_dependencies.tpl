{{/*
Interface to the services used by Shlink. Each one is either a bundled instance or an external service:
- database: PostgreSQL (see _postgresql.tpl), MariaDB (see _mariadb.tpl), externalDatabase.* or SQLite
- redis: Valkey (see _valkey.tpl) or externalRedis.*, optional
- rabbitmq: RabbitMQ (see _rabbitmq.tpl) or externalRabbitmq.*, optional
*/}}

{{/*
Database
*/}}
{{- define "shlink-backend.database.driver" -}}
  {{- if and .Values.postgresql.enabled .Values.mariadb.enabled -}}
    {{- fail "postgresql.enabled and mariadb.enabled are mutually exclusive, enable only one bundled database" -}}
  {{- else if .Values.postgresql.enabled -}}
    {{- "postgres" -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- "maria" -}}
  {{- else if .Values.externalDatabase.hostname -}}
    {{- required "externalDatabase.type (mysql, maria, postgres or mssql) is required if externalDatabase.hostname is set" .Values.externalDatabase.type -}}
  {{- else -}}
    {{- "sqlite" -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.database.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.hostname" .Subcharts.postgresql -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.hostname" .Subcharts.mariadb -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.hostname $ -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.database.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.port" .Subcharts.postgresql -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.port" .Subcharts.mariadb -}}
  {{- else if .Values.externalDatabase.port -}}
    {{- .Values.externalDatabase.port | toString -}}
  {{- else -}}
    {{- $driver := include "shlink-backend.database.driver" . -}}
    {{- if eq $driver "postgres" -}}
      {{- "5432" -}}
    {{- else if eq $driver "mssql" -}}
      {{- "1433" -}}
    {{- else -}}
      {{- "3306" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.database.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.database" .Subcharts.postgresql -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.database" .Subcharts.mariadb -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.database $ -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.database.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.username" .Subcharts.postgresql -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.username" .Subcharts.mariadb -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.username $ -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.database.secretName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.secretName" .Subcharts.postgresql -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.secretName" .Subcharts.mariadb -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- tpl .Values.externalDatabase.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-database" (include "shlink-backend.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.database.passwordKey" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.passwordKey" .Subcharts.postgresql -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.passwordKey" .Subcharts.mariadb -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- .Values.externalDatabase.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Redis
*/}}
{{- define "shlink-backend.redis.enabled" -}}
  {{- if or .Values.valkey.enabled .Values.externalRedis.hostname -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.redis.sentinelService" -}}
  {{- if not .Values.valkey.enabled -}}
    {{- .Values.externalRedis.sentinelService -}}
  {{- end -}}
{{- end -}}

{{/*
Return REDIS_SERVERS. Shlink only uses REDIS_SERVERS_USER and REDIS_SERVERS_PASSWORD for Sentinel, otherwise the
credentials have to be part of the server URL. The password is inserted from REDIS_SERVERS_PASSWORD with Kubernetes
variable expansion, so it must only contain URL-safe characters.
*/}}
{{- define "shlink-backend.redis.servers" -}}
  {{- $hostPort := "" -}}
  {{- if .Values.valkey.enabled -}}
    {{- $hostPort = printf "%s:%s" (include "christianhuth.valkey.hostname" .Subcharts.valkey) (include "christianhuth.valkey.port" .Subcharts.valkey) -}}
  {{- else -}}
    {{- $hostPort = printf "%s:%v" (tpl .Values.externalRedis.hostname $) (.Values.externalRedis.port | default 6379) -}}
  {{- end -}}
  {{- if and (include "shlink-backend.redis.authEnabled" .) (not (include "shlink-backend.redis.sentinelService" .)) -}}
    {{- printf "tcp://%s:$(REDIS_SERVERS_PASSWORD)@%s" (include "shlink-backend.redis.username" .) $hostPort -}}
  {{- else -}}
    {{- $hostPort -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.redis.authEnabled" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.authEnabled" .Subcharts.valkey -}}
  {{- else if or .Values.externalRedis.password .Values.externalRedis.existingSecret -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.redis.username" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.username" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else -}}
    {{- .Values.externalRedis.username -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.redis.secretName" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.secretName" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else if .Values.externalRedis.existingSecret -}}
    {{- tpl .Values.externalRedis.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-redis" (include "shlink-backend.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.redis.passwordKey" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.passwordKey" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else if .Values.externalRedis.existingSecret -}}
    {{- .Values.externalRedis.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
RabbitMQ
*/}}
{{- define "shlink-backend.rabbitmq.enabled" -}}
  {{- if or .Values.rabbitmq.enabled .Values.externalRabbitmq.hostname -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.rabbitmq.hostname" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.hostname" .Subcharts.rabbitmq -}}
  {{- else -}}
    {{- tpl .Values.externalRabbitmq.hostname $ -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.rabbitmq.port" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.port" .Subcharts.rabbitmq -}}
  {{- else -}}
    {{- .Values.externalRabbitmq.port | default 5672 | toString -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.rabbitmq.vhost" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.vhost" .Subcharts.rabbitmq -}}
  {{- else -}}
    {{- .Values.externalRabbitmq.vhost | default "/" -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.rabbitmq.useSsl" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- "false" -}}
  {{- else -}}
    {{- .Values.externalRabbitmq.useSsl | toString -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.rabbitmq.username" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.username" .Subcharts.rabbitmq -}}
  {{- else -}}
    {{- tpl .Values.externalRabbitmq.username $ -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.rabbitmq.secretName" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.secretName" .Subcharts.rabbitmq -}}
  {{- else if .Values.externalRabbitmq.existingSecret -}}
    {{- tpl .Values.externalRabbitmq.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-rabbitmq" (include "shlink-backend.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "shlink-backend.rabbitmq.passwordKey" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.passwordKey" .Subcharts.rabbitmq -}}
  {{- else if .Values.externalRabbitmq.existingSecret -}}
    {{- .Values.externalRabbitmq.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

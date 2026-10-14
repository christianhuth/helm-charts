{{/*
Interface to the services used by Squest. Each one is either the bundled instance or an external service:
- database: MariaDB (see _mariadb.tpl) or externalDatabase.*
- redis: Valkey (see _valkey.tpl) or externalRedis.*
- rabbitmq: RabbitMQ (see _rabbitmq.tpl) or externalRabbitmq.*
*/}}

{{/*
Database
*/}}
{{- define "squest.database.hostname" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.hostname" .Subcharts.mariadb -}}
  {{- else -}}
    {{- required "externalDatabase.hostname is required if mariadb.enabled is false" (tpl .Values.externalDatabase.hostname $) -}}
  {{- end -}}
{{- end -}}

{{- define "squest.database.port" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.port" .Subcharts.mariadb -}}
  {{- else -}}
    {{- .Values.externalDatabase.port | default 3306 | toString -}}
  {{- end -}}
{{- end -}}

{{- define "squest.database.database" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.database" .Subcharts.mariadb -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.database $ -}}
  {{- end -}}
{{- end -}}

{{- define "squest.database.username" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.username" .Subcharts.mariadb -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.username $ -}}
  {{- end -}}
{{- end -}}

{{- define "squest.database.secretName" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.secretName" .Subcharts.mariadb -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- tpl .Values.externalDatabase.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-database" (include "squest.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "squest.database.passwordKey" -}}
  {{- if .Values.mariadb.enabled -}}
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
{{- define "squest.redis.hostname" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.hostname" .Subcharts.valkey -}}
  {{- else -}}
    {{- required "externalRedis.hostname is required if valkey.enabled is false" (tpl .Values.externalRedis.hostname $) -}}
  {{- end -}}
{{- end -}}

{{- define "squest.redis.port" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.port" .Subcharts.valkey -}}
  {{- else -}}
    {{- .Values.externalRedis.port | default 6379 | toString -}}
  {{- end -}}
{{- end -}}

{{- define "squest.redis.authEnabled" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.authEnabled" .Subcharts.valkey -}}
  {{- else if or .Values.externalRedis.password .Values.externalRedis.existingSecret -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{- define "squest.redis.username" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.username" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else -}}
    {{- .Values.externalRedis.username | default "default" -}}
  {{- end -}}
{{- end -}}

{{- define "squest.redis.secretName" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.secretName" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else if .Values.externalRedis.existingSecret -}}
    {{- tpl .Values.externalRedis.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-redis" (include "squest.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "squest.redis.passwordKey" -}}
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
{{- define "squest.rabbitmq.hostname" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.hostname" .Subcharts.rabbitmq -}}
  {{- else -}}
    {{- required "externalRabbitmq.hostname is required if rabbitmq.enabled is false" (tpl .Values.externalRabbitmq.hostname $) -}}
  {{- end -}}
{{- end -}}

{{- define "squest.rabbitmq.port" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.port" .Subcharts.rabbitmq -}}
  {{- else -}}
    {{- .Values.externalRabbitmq.port | default 5672 | toString -}}
  {{- end -}}
{{- end -}}

{{- define "squest.rabbitmq.vhost" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.vhost" .Subcharts.rabbitmq -}}
  {{- else -}}
    {{- .Values.externalRabbitmq.vhost | default "/" -}}
  {{- end -}}
{{- end -}}

{{- define "squest.rabbitmq.username" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.username" .Subcharts.rabbitmq -}}
  {{- else -}}
    {{- tpl .Values.externalRabbitmq.username $ -}}
  {{- end -}}
{{- end -}}

{{- define "squest.rabbitmq.secretName" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.secretName" .Subcharts.rabbitmq -}}
  {{- else if .Values.externalRabbitmq.existingSecret -}}
    {{- tpl .Values.externalRabbitmq.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-rabbitmq" (include "squest.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "squest.rabbitmq.passwordKey" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- include "christianhuth.rabbitmq.passwordKey" .Subcharts.rabbitmq -}}
  {{- else if .Values.externalRabbitmq.existingSecret -}}
    {{- .Values.externalRabbitmq.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Environment variables of the Squest containers (see Squest/settings.py)
*/}}
{{- define "squest.database.env" -}}
- name: DB_DATABASE
  value: {{ include "squest.database.database" . | quote }}
- name: DB_HOST
  value: {{ include "squest.database.hostname" . | quote }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "squest.database.secretName" . | quote }}
      key: {{ include "squest.database.passwordKey" . | quote }}
- name: DB_PORT
  value: {{ include "squest.database.port" . | quote }}
- name: DB_USER
  value: {{ include "squest.database.username" . | quote }}
{{- end -}}

{{- define "squest.rabbitmq.env" -}}
- name: RABBITMQ_HOST
  value: {{ include "squest.rabbitmq.hostname" . | quote }}
- name: RABBITMQ_PORT
  value: {{ include "squest.rabbitmq.port" . | quote }}
- name: RABBITMQ_VHOST
  value: {{ include "squest.rabbitmq.vhost" . | quote }}
- name: RABBITMQ_USER
  value: {{ include "squest.rabbitmq.username" . | quote }}
- name: RABBITMQ_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "squest.rabbitmq.secretName" . | quote }}
      key: {{ include "squest.rabbitmq.passwordKey" . | quote }}
{{- end -}}

{{- define "squest.redis.env" -}}
- name: REDIS_CACHE_HOST
  value: {{ include "squest.redis.hostname" . | quote }}
- name: REDIS_CACHE_PORT
  value: {{ include "squest.redis.port" . | quote }}
- name: REDIS_CACHE_USER
  value: {{ include "squest.redis.username" . | quote }}
{{- if include "squest.redis.authEnabled" . }}
- name: REDIS_CACHE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "squest.redis.secretName" . | quote }}
      key: {{ include "squest.redis.passwordKey" . | quote }}
{{- end }}
{{- end -}}

{{/*
Return the services Squest waits for on startup (WAIT_HOSTS), as host:port list
*/}}
{{- define "squest.dependencies.waitHosts" -}}
  {{- printf "%s:%s,%s:%s,%s:%s"
      (include "squest.database.hostname" .) (include "squest.database.port" .)
      (include "squest.rabbitmq.hostname" .) (include "squest.rabbitmq.port" .)
      (include "squest.redis.hostname" .) (include "squest.redis.port" .) -}}
{{- end -}}

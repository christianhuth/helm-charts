{{/*
Interface to the services used by Kutt. Each one is either the bundled instance or an external service:
- database: PostgreSQL (see _postgresql.tpl) or externalDatabase.*
- redis: Valkey (see _valkey.tpl) or externalRedis.*
*/}}

{{/*
Database
*/}}
{{- define "kutt.database.client" -}}
  {{- tpl .Values.kutt.database.client $ -}}
{{- end -}}

{{- define "kutt.database.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.hostname" .Subcharts.postgresql -}}
  {{- else -}}
    {{- required "externalDatabase.hostname is required if postgresql.enabled is false" (tpl .Values.externalDatabase.hostname $) -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.database.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.port" .Subcharts.postgresql -}}
  {{- else -}}
    {{- .Values.externalDatabase.port | default 5432 | toString -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.database.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.database" .Subcharts.postgresql -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.database $ -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.database.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.username" .Subcharts.postgresql -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.username $ -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.database.secretName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.secretName" .Subcharts.postgresql -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- tpl .Values.externalDatabase.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-database" (include "kutt.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.database.passwordKey" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.passwordKey" .Subcharts.postgresql -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- .Values.externalDatabase.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Redis
*/}}
{{- define "kutt.redis.enabled" -}}
  {{- if or .Values.valkey.enabled .Values.externalRedis.hostname -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.redis.hostname" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.hostname" .Subcharts.valkey -}}
  {{- else -}}
    {{- tpl .Values.externalRedis.hostname $ -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.redis.port" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.port" .Subcharts.valkey -}}
  {{- else -}}
    {{- .Values.externalRedis.port | default 6379 | toString -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.redis.authEnabled" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.authEnabled" .Subcharts.valkey -}}
  {{- else if or .Values.externalRedis.password .Values.externalRedis.existingSecret -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.redis.secretName" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.secretName" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else if .Values.externalRedis.existingSecret -}}
    {{- tpl .Values.externalRedis.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-redis" (include "kutt.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "kutt.redis.passwordKey" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.passwordKey" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else if .Values.externalRedis.existingSecret -}}
    {{- .Values.externalRedis.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

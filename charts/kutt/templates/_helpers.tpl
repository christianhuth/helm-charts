{{/*
Expand the name of the chart.
*/}}
{{- define "kutt.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kutt.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kutt.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kutt.labels" -}}
helm.sh/chart: {{ include "kutt.chart" . }}
{{ include "kutt.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kutt.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kutt.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kutt.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kutt.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the client of the postgresql to use
*/}}
{{- define "kutt.postgresql.client" -}}
  {{- if .Values.kutt.database.client -}}
    {{- printf "%s" (tpl .Values.kutt.database.client $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the hostname of the postgresql to use
*/}}
{{- define "kutt.postgresql.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.primary.fullname" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return postgresql service port
*/}}
{{- define "kutt.postgresql.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.service.port" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl (toString .Values.externalPostgresql.port) $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the database to use
*/}}
{{- define "kutt.postgresql.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.database" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.database $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the user to use
*/}}
{{- define "kutt.postgresql.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.username" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.username $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the postgresql user password
*/}}
{{- define "kutt.postgresql.secretName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.secretName" .Subcharts.postgresql) -}}
  {{- else if .Values.externalPostgresql.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "kutt.fullname" .) -}}-postgresql
  {{- end -}}
{{- end -}}

{{/*
Get the user-password key for the postgresql user password
*/}}
{{- define "kutt.postgresql.userPasswordKey" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.userPasswordKey" .Subcharts.postgresql) -}}
  {{- else if .Values.externalPostgresql.auth.userPasswordKey -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.userPasswordKey $) -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}



{{/*
Return the hostname of the redis to use
*/}}
{{- define "kutt.redis.hostname" -}}
  {{- if .Values.redis.enabled -}}
    {{- printf "%s-master" (include "common.names.fullname" .Subcharts.redis) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalRedis.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return redis service port
*/}}
{{- define "kutt.redis.port" -}}
  {{- if .Values.redis.enabled -}}
    {{- printf "%s" (tpl (toString .Values.redis.master.service.ports.redis) $) -}}
  {{- else -}}
    {{- printf "%s" (tpl (toString .Values.externalRedis.port) $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the user-password key for the redis password
*/}}
{{- define "kutt.redis.auth.enabled" -}}
  {{- if or (and (.Values.redis.enabled) (.Values.redis.auth.enabled)) (and (not .Values.redis.enabled) (.Values.externalRedis.auth.enabled)) -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the redis password
*/}}
{{- define "kutt.redis.secretName" -}}
  {{- if .Values.redis.enabled -}}
    {{- printf "%s" (include "redis.secretName" .Subcharts.redis) -}}
  {{- else if .Values.externalRedis.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.externalRedis.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "kutt.fullname" .) -}}-redis
  {{- end -}}
{{- end -}}

{{/*
Get the user-password key for the redis password
*/}}
{{- define "kutt.redis.userPasswordKey" -}}
  {{- if .Values.redis.enabled -}}
    {{- printf "%s" (include "redis.secretPasswordKey" .Subcharts.redis) -}}
  {{- else if .Values.externalRedis.auth.userPasswordKey -}}
    {{- printf "%s" (tpl .Values.externalRedis.auth.userPasswordKey $) -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "baserow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "baserow.fullname" -}}
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
{{- define "baserow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define a for the backend components of the chart.
*/}}
{{- define "baserow.backend.name" -}}
{{- include "baserow.name" . | trunc 56 | trimSuffix "-" }}-backend
{{- end }}

{{/*
Create a fully qualified name for the backend components.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "baserow.backend.fullname" -}}
{{- include "baserow.fullname" . | trunc 56 | trimSuffix "-" }}-backend
{{- end }}

{{/*
Common labels for backend ingress resource
*/}}
{{- define "baserow.backend.labels" -}}
helm.sh/chart: {{ include "baserow.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Define a for the frontend components of the chart.
*/}}
{{- define "baserow.frontend.name" -}}
{{- include "baserow.name" . | trunc 54 | trimSuffix "-" }}-frontend
{{- end }}

{{/*
Create a fully qualified name for the frontend components.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "baserow.frontend.fullname" -}}
{{- include "baserow.fullname" . | trunc 54 | trimSuffix "-" }}-frontend
{{- end }}

{{/*
Selector labels for the frontend pods and deployment
*/}}
{{- define "baserow.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "baserow.frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- range $k, $v := .Values.frontend.selectorLabels }}
{{ $k}}: {{ $v }}
{{- end }}
{{- end }}

{{/*
Common labels for all frontend resources
*/}}
{{- define "baserow.frontend.labels" -}}
helm.sh/chart: {{ include "baserow.chart" . }}
{{ include "baserow.frontend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use for the frontend deployment
*/}}
{{- define "baserow.frontend.serviceAccountName" -}}
{{- if .Values.frontend.serviceAccount.create }}
{{- default (include "baserow.frontend.fullname" .) .Values.frontend.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.frontend.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the public name of the hostname for the baserow frontend
*/}}
{{- define "baserow.frontend.publicUrl" -}}
  {{ .Values.config.publicFrontendUrl }}
{{- end -}}

{{/*
Define a for the asgi backend components of the chart.
*/}}
{{- define "baserow.backend.asgi.name" -}}
{{- include "baserow.name" . | trunc 58 | trimSuffix "-" }}-asgi
{{- end }}

{{/*
Create a fully qualified name for the asgi backend components.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "baserow.backend.asgi.fullname" -}}
{{- include "baserow.fullname" . | trunc 58 | trimSuffix "-" }}-asgi
{{- end }}

{{/*
Selector labels for the asgi backend
*/}}
{{- define "baserow.backend.asgi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "baserow.backend.asgi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- range $k, $v := .Values.backend.asgi.selectorLabels }}
{{ $k}}: {{ $v }}
{{- end }}
{{- end }}

{{/*
Common labels for all asgi backend resources
*/}}
{{- define "baserow.backend.asgi.labels" -}}
helm.sh/chart: {{ include "baserow.chart" . }}
{{ include "baserow.backend.asgi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use for the asgi backend deployment
*/}}
{{- define "baserow.backend.asgi.serviceAccountName" -}}
{{- if .Values.backend.asgi.serviceAccount.create }}
{{- default (include "baserow.backend.asgi.fullname" .) .Values.backend.asgi.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.backend.asgi.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define a for the wsgi backend components of the chart.
*/}}
{{- define "baserow.backend.wsgi.name" -}}
{{- include "baserow.name" . | trunc 58 | trimSuffix "-" }}-wsgi
{{- end }}

{{/*
Create a fully qualified name for the wsgi backend components.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "baserow.backend.wsgi.fullname" -}}
{{- include "baserow.fullname" . | trunc 58 | trimSuffix "-" }}-wsgi
{{- end }}

{{/*
Selector labels for the wsgi backend
*/}}
{{- define "baserow.backend.wsgi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "baserow.backend.wsgi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- range $k, $v := .Values.backend.wsgi.selectorLabels }}
{{ $k}}: {{ $v }}
{{- end }}
{{- end }}

{{/*
Common labels for all wsgi backend resources
*/}}
{{- define "baserow.backend.wsgi.labels" -}}
helm.sh/chart: {{ include "baserow.chart" . }}
{{ include "baserow.backend.wsgi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use for the wsgi backend deployment
*/}}
{{- define "baserow.backend.wsgi.serviceAccountName" -}}
{{- if .Values.backend.wsgi.serviceAccount.create }}
{{- default (include "baserow.backend.wsgi.fullname" .) .Values.backend.wsgi.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.backend.wsgi.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the secret containing the secrets for authentication against AWS
*/}}
{{- define "baserow.backend.aws.secretName" -}}
  {{- if .Values.backend.config.aws.existingSecret -}}
    {{- printf "%s" (tpl .Values.backend.config.aws.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "baserow.backend.fullname" .) -}}-aws
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the secrets for authentication against AWS
*/}}
{{- define "baserow.backend.email.secretName" -}}
  {{- if .Values.backend.config.email.existingSecret -}}
    {{- printf "%s" (tpl .Values.backend.config.email.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "baserow.backend.fullname" .) -}}-email
  {{- end -}}
{{- end -}}

{{/*
Get the name of the persistent volume claim for the baserow backend
*/}}
{{- define "baserow.backend.pvcName" -}}
  {{- if .Values.backend.persistence.existingClaim -}}
    {{- printf "%s" (tpl .Values.backend.persistence.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s" (include "baserow.backend.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the private name for the baserow backend
*/}}
{{- define "baserow.backend.privateUrl" -}}
  http://{{ include "baserow.backend.wsgi.fullname" . }}:{{ .Values.backend.wsgi.service.port }}
{{- end -}}

{{/*
Get the public name of the hostname for the baserow backend
*/}}
{{- define "baserow.backend.publicUrl" -}}
  {{ .Values.config.publicBackendUrl }}
{{- end -}}

{{/*
Get the name of the secret containing the secrets for the baserow backend
*/}}
{{- define "baserow.backend.secretName" -}}
  {{- if .Values.backend.config.existingSecret -}}
    {{- printf "%s" (tpl .Values.backend.config.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "baserow.backend.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Define a for the celery worker components of the chart.
*/}}
{{- define "baserow.backend.celery.name" -}}
{{- include "baserow.name" . | trunc 56 | trimSuffix "-" }}-celery
{{- end }}

{{/*
Create a fully qualified name for the celery worker components.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "baserow.backend.celery.fullname" -}}
{{- include "baserow.fullname" . | trunc 56 | trimSuffix "-" }}-celery
{{- end }}

{{/*
Selector labels for the celery workers
*/}}
{{- define "baserow.backend.celery.selectorLabels" -}}
app.kubernetes.io/name: {{ include "baserow.backend.celery.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- range $k, $v := .Values.backend.celery.selectorLabels }}
{{ $k}}: {{ $v }}
{{- end }}
{{- end }}

{{/*
Common labels for all celery worker resources
*/}}
{{- define "baserow.backend.celery.labels" -}}
helm.sh/chart: {{ include "baserow.chart" . }}
{{ include "baserow.backend.celery.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use for the celery worker deployment
*/}}
{{- define "baserow.backend.celery.serviceAccountName" -}}
{{- if .Values.backend.celery.serviceAccount.create }}
{{- default (include "baserow.backend.celery.fullname" .) .Values.backend.celery.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.backend.celery.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the hostname of the postgresql to use
*/}}
{{- define "baserow.postgresql.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.primary.fullname" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return postgresql service port
*/}}
{{- define "baserow.postgresql.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.service.port" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl (toString .Values.externalPostgresql.port) $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the database to use
*/}}
{{- define "baserow.postgresql.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.database" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.database $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the user to use
*/}}
{{- define "baserow.postgresql.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.username" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.username $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the postgresql user password
*/}}
{{- define "baserow.postgresql.secretName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.secretName" .Subcharts.postgresql) -}}
  {{- else if .Values.externalPostgresql.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "baserow.fullname" .) -}}-postgresql
  {{- end -}}
{{- end -}}

{{/*
Get the user-password key for the postgresql user password
*/}}
{{- define "baserow.postgresql.userPasswordKey" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.userPasswordKey" .Subcharts.postgresql) -}}
  {{- else if .Values.externalPostgresql.auth.userPasswordKey -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.userPasswordKey $) -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Get the user-username key for the postgresql username
*/}}
{{- define "baserow.postgresql.userUsernameKey" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.username" .Subcharts.postgresql) -}}
  {{- else if .Values.externalPostgresql.auth.userUsernameKey -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.userUsernameKey $) -}}
  {{- else -}}
    {{- "username" -}}
  {{- end -}}
{{- end -}}

{{/*
Return the hostname of the redis to use
*/}}
{{- define "baserow.redis.hostname" -}}
  {{- if .Values.redis.enabled -}}
    {{- printf "%s-master" (include "common.names.fullname" .Subcharts.redis) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalRedis.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return redis service port
*/}}
{{- define "baserow.redis.port" -}}
  {{- if .Values.redis.enabled -}}
    {{- printf "%s" (tpl (toString .Values.redis.master.service.ports.redis) $) -}}
  {{- else -}}
    {{- printf "%s" (tpl (toString .Values.externalRedis.port) $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the user-password key for the redis password
*/}}
{{- define "baserow.redis.auth.enabled" -}}
  {{- if or (and (.Values.redis.enabled) (.Values.redis.auth.enabled)) (and (not .Values.redis.enabled) (.Values.externalRedis.auth.enabled)) -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the redis password
*/}}
{{- define "baserow.redis.secretName" -}}
  {{- if .Values.redis.enabled -}}
    {{- printf "%s" (include "redis.secretName" .Subcharts.redis) -}}
  {{- else if .Values.externalRedis.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.externalRedis.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "baserow.fullname" .) -}}-redis
  {{- end -}}
{{- end -}}

{{/*
Get the user-password key for the redis password
*/}}
{{- define "baserow.redis.userPasswordKey" -}}
  {{- if .Values.redis.enabled -}}
    {{- printf "%s" (include "redis.secretPasswordKey" .Subcharts.redis) -}}
  {{- else if .Values.externalRedis.auth.userPasswordKey -}}
    {{- printf "%s" (tpl .Values.externalRedis.auth.userPasswordKey $) -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

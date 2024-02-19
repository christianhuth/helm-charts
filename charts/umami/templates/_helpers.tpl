{{/*
Expand the name of the chart.
*/}}
{{- define "umami.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "umami.fullname" -}}
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
{{- define "umami.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "umami.labels" -}}
helm.sh/chart: {{ include "umami.chart" . }}
{{ include "umami.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "umami.selectorLabels" -}}
app.kubernetes.io/name: {{ include "umami.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "umami.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "umami.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the hostname of the database to use
*/}}
{{- define "umami.database.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.primary.fullname" .Subcharts.postgresql) -}}
  {{- else if .Values.mysql.enabled -}}
    {{- printf "%s" (include "mysql.primary.fullname" .Subcharts.mysql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalDatabase.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return database service port
*/}}
{{- define "umami.database.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.service.port" .Subcharts.postgresql) -}}
  {{- else if .Values.mysql.enabled -}}
    {{- printf "%s" (tpl (toString .Values.mysql.primary.service.ports.mysql) $) -}}
  {{- else -}}
    {{- printf "%s" (tpl (toString .Values.externalDatabase.port) $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the database to use
*/}}
{{- define "umami.database.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.database" .Subcharts.postgresql) -}}
  {{- else if .Values.mysql.enabled -}}
    {{- printf "%s" (tpl .Values.mysql.auth.database $) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.database $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the user to use
*/}}
{{- define "umami.database.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.username" .Subcharts.postgresql) -}}
  {{- else if .Values.mysql.enabled -}}
    {{- printf "%s" (tpl .Values.mysql.auth.username $) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.username $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the password for the database
*/}}
{{- define "umami.database.password" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (tpl .Values.postgresql.auth.password $) -}}
  {{- else if .Values.mysql.enabled -}}
    {{- printf "%s" (tpl .Values.mysql.auth.password $) -}}
  {{- else if .Values.externalDatabase.auth.password -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.password $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the type of the external database
*/}}
{{- define "umami.database.type" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- "postgresql" -}}
  {{- else if .Values.mysql.enabled -}}
    {{- "mysql" -}}
  {{- else if .Values.externalDatabase.type -}}
    {{- printf "%s" (tpl .Values.externalDatabase.type $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the url for the database
*/}}
{{- define "umami.database.url" -}}
  {{ include "umami.database.type" . }}://{{ include "umami.database.username" . }}:{{ include "umami.database.password" . }}@{{ include "umami.database.hostname" . }}:{{ include "umami.database.port" . }}/{{ include "umami.database.database" . }}
{{- end -}}


{{/*
Get the name of the secret containing the database url
*/}}
{{- define "umami.database.secretName" -}}
  {{- if .Values.database.existingSecret -}}
    {{- printf "%s" (tpl .Values.database.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "umami.fullname" .) -}}-db
  {{- end -}}
{{- end -}}

{{/*
Get the key for the database url
*/}}
{{- define "umami.database.databaseUrlKey" -}}
  {{- if .Values.database.databaseUrlKey -}}
    {{- printf "%s" (tpl .Values.database.databaseUrlKey $) -}}
  {{- else -}}
    {{- "database-url" -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the app secret
*/}}
{{- define "umami.appSecret.secretName" -}}
  {{- if .Values.umami.appSecret.existingSecret -}}
    {{- printf "%s" (tpl .Values.umami.appSecret.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "umami.fullname" .) -}}-app-secret
  {{- end -}}
{{- end -}}

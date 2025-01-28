{{/*
Expand the name of the chart.
*/}}
{{- define "typo3.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "typo3.fullname" -}}
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
{{- define "typo3.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "typo3.labels" -}}
helm.sh/chart: {{ include "typo3.chart" . }}
{{ include "typo3.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "typo3.selectorLabels" -}}
app.kubernetes.io/name: {{ include "typo3.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "typo3.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "typo3.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the hostname of the database to use
*/}}
{{- define "typo3.database.hostname" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "%s" (include "mysql.primary.fullname" .Subcharts.mysql) -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- printf "%s" (include "mariadb.primary.fullname" .Subcharts.mariadb) -}}
  {{- else if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.primary.fullname" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalDatabase.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return database service port
*/}}
{{- define "typo3.database.port" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "%s" (tpl (toString .Values.mysql.primary.service.ports.mysql) $) -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- printf "%s" (tpl (toString .Values.mariadb.primary.service.ports.mysql) $) -}}
  {{- else if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.service.port" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl (toString .Values.externalDatabase.port) $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the database to use
*/}}
{{- define "typo3.database.database" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "%s" (tpl .Values.mysql.auth.database $) -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- printf "%s" (tpl .Values.mariadb.auth.database $) -}}
  {{- else if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.database" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.database $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the user to use
*/}}
{{- define "typo3.database.username" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "%s" (tpl .Values.mysql.auth.username $) -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- printf "%s" (tpl .Values.mariadb.auth.username $) -}}
  {{- else if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.username" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.username $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the database user password
*/}}
{{- define "typo3.database.secretName" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "%s" (include "mysql.secretName" .Subcharts.mysql) -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- printf "%s" (include "mariadb.secretName" .Subcharts.mariadb) -}}
  {{- else if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.secretName" .Subcharts.postgresql) -}}
  {{- else if .Values.externalDatabase.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "typo3.fullname" .) -}}-database
  {{- end -}}
{{- end -}}

{{/*
Get the user-password key for the database password
*/}}
{{- define "typo3.database.userPasswordKey" -}}
  {{- if .Values.mysql.enabled -}}
    {{- "mysql-password" -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- "mariadb-password" -}}
  {{- else if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.userPasswordKey" .Subcharts.postgresql) -}}
  {{- else if .Values.externalDatabase.auth.userPasswordKey -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.userPasswordKey $) -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Get the type of the external database
*/}}
{{- define "typo3.database.type" -}}
  {{- if .Values.mysql.enabled -}}
    {{- "mysql" -}}
  {{- else if .Values.mariadb.enabled -}}
    {{- "mariadb" -}}
  {{- else if .Values.postgresql.enabled -}}
    {{- "postgresql" -}}
  {{- else if .Values.externalDatabase.type -}}
    {{- printf "%s" (tpl .Values.externalDatabase.type $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the persistent volume claim for the fileadmin folder
*/}}
{{- define "typo3.pvcName.fileadmin" -}}
  {{- if .Values.persistence.fileadmin.existingClaim -}}
    {{- printf "%s" (tpl .Values.persistence.fileadmin.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s" (include "typo3.fullname" .) -}}-fileadmin
  {{- end -}}
{{- end -}}

{{/*
Get the name of the persistent volume claim for the typo3conf folder
*/}}
{{- define "typo3.pvcName.typo3conf" -}}
  {{- if .Values.persistence.typo3conf.existingClaim -}}
    {{- printf "%s" (tpl .Values.persistence.typo3conf.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s" (include "typo3.fullname" .) -}}-typo3conf
  {{- end -}}
{{- end -}}

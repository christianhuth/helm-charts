{{/*
Expand the name of the chart.
*/}}
{{- define "headwind-mdm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "headwind-mdm.fullname" -}}
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
{{- define "headwind-mdm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "headwind-mdm.labels" -}}
helm.sh/chart: {{ include "headwind-mdm.chart" . }}
{{ include "headwind-mdm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "headwind-mdm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "headwind-mdm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "headwind-mdm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "headwind-mdm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the hostname of the postgresql to use
*/}}
{{- define "headwind-mdm.postgresql.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.primary.fullname" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return postgresql service port
*/}}
{{- define "headwind-mdm.postgresql.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.service.port" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl (toString .Values.externalPostgresql.port) $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the database to use
*/}}
{{- define "headwind-mdm.postgresql.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.database" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.database $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the user to use
*/}}
{{- define "headwind-mdm.postgresql.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.username" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.username $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the postgresql user password
*/}}
{{- define "headwind-mdm.postgresql.secretName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.secretName" .Subcharts.postgresql) -}}
  {{- else if .Values.externalPostgresql.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "headwind-mdm.fullname" .) -}}-postgresql
  {{- end -}}
{{- end -}}

{{/*
Get the user-password key for the postgresql user password
*/}}
{{- define "headwind-mdm.postgresql.userPasswordKey" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.userPasswordKey" .Subcharts.postgresql) -}}
  {{- else if .Values.externalPostgresql.auth.userPasswordKey -}}
    {{- printf "%s" (tpl .Values.externalPostgresql.auth.userPasswordKey $) -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Create the name of the pvc to use
*/}}
{{- define "headwind-mdm.pvcName" -}}
{{- if .Values.persistence.existingClaim }}
  {{- printf "%s" (tpl (toString .Values.persistence.existingClaim) $) -}}
{{- else }}
  {{- printf "%s" (include "headwind-mdm.fullname" .) -}}
{{- end }}
{{- end }}

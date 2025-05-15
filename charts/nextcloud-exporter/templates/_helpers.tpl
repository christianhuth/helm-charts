{{/*
Expand the name of the chart.
*/}}
{{- define "nextcloud-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nextcloud-exporter.fullname" -}}
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
{{- define "nextcloud-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nextcloud-exporter.labels" -}}
helm.sh/chart: {{ include "nextcloud-exporter.chart" . }}
{{ include "nextcloud-exporter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nextcloud-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nextcloud-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nextcloud-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nextcloud-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define the port for the exporter to listen on
*/}}
{{- define "nextcloud-exporter.exporter.listen" -}}
  {{- if .Values.config.exporter.port }}
    {{- printf ":%s" (.Values.config.exporter.port | toString) }}
  {{- end }}
{{- end -}}

{{/*
Get the name of the secret containing the token for authentication against the Nextcloud server
*/}}
{{- define "nextcloud-exporter.nextcloud.auth.secretName" -}}
  {{- if .Values.config.nextcloud.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.config.nextcloud.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "nextcloud-exporter.fullname" .) -}}
  {{- end -}}
{{- end -}}

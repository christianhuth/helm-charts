{{/*
Expand the name of the chart.
*/}}
{{- define "promlens.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "promlens.fullname" -}}
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
{{- define "promlens.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "promlens.labels" -}}
helm.sh/chart: {{ include "promlens.chart" . }}
{{ include "promlens.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "promlens.selectorLabels" -}}
app.kubernetes.io/name: {{ include "promlens.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "promlens.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "promlens.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the secret containing the api token for grafana
*/}}
{{- define "promlens.grafana.secretName" -}}
  {{- if .Values.config.grafana.existingSecret -}}
    {{- printf "%s" (tpl .Values.config.grafana.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "promlens.fullname" .) -}}-grafana
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the credentials for link sharing using google cloud storage
*/}}
{{- define "promlens.gcs.secretName" -}}
  {{- if .Values.config.sharedLinks.gcs.existingSecret -}}
    {{- printf "%s" (tpl .Values.config.sharedLinks.gcs.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "promlens.fullname" .) -}}-gcs
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the dsn for link sharing using SQL
*/}}
{{- define "promlens.sql.secretName" -}}
  {{- if .Values.config.sharedLinks.sql.existingSecret -}}
    {{- printf "%s" (tpl .Values.config.sharedLinks.sql.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "promlens.fullname" .) -}}-sql
  {{- end -}}
{{- end -}}

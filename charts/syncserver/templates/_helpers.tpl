{{/*
Expand the name of the chart.
*/}}
{{- define "syncserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "syncserver.fullname" -}}
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
{{- define "syncserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "syncserver.labels" -}}
helm.sh/chart: {{ include "syncserver.chart" . }}
{{ include "syncserver.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "syncserver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "syncserver.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "syncserver.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "syncserver.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the secret containing the secret to secure the syncserver
*/}}
{{- define "syncserver.secretName" -}}
  {{- if .Values.syncserver.config.existingSecret -}}
    {{- printf "%s" (tpl .Values.syncserver.config.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "syncserver.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the persistent volume claim
*/}}
{{- define "syncserver.pvcName" -}}
  {{- if .Values.syncserver.persistence.existingClaim -}}
    {{- printf "%s" (tpl .Values.syncserver.persistence.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s" (include "syncserver.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "squest.squest.fullname" -}}
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
Common labels
*/}}
{{- define "squest.squest.labels" -}}
{{ include "squest.common.labels" . }}
helm.sh/chart: {{ include "squest.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "squest.squest.selectorLabels" -}}
app.kubernetes.io/name: {{ include "squest.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "squest.squest.serviceAccountName" -}}
{{- if .Values.squest.serviceAccount.create }}
{{- default (include "squest.squest.fullname" .) .Values.squest.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.squest.serviceAccount.name }}
{{- end }}
{{- end }}

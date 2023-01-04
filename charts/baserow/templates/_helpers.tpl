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
Common labels
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
Selector labels for the frontend
*/}}
{{- define "baserow.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "baserow.frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
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

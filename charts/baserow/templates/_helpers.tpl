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
Define a for the celery worker components of the chart.
*/}}
{{- define "baserow.celery.name" -}}
{{- include "baserow.name" . | trunc 56 | trimSuffix "-" }}-celery
{{- end }}

{{/*
Create a fully qualified name for the celery worker  components.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "baserow.celery.fullname" -}}
{{- include "baserow.fullname" . | trunc 56 | trimSuffix "-" }}-celery
{{- end }}

{{/*
Selector labels for the celery workers
*/}}
{{- define "baserow.celery.selectorLabels" -}}
app.kubernetes.io/name: {{ include "baserow.celery.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels for all celery worker resources
*/}}
{{- define "baserow.celery.labels" -}}
helm.sh/chart: {{ include "baserow.chart" . }}
{{ include "baserow.celery.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use for the celery worker deployment
*/}}
{{- define "baserow.celery.serviceAccountName" -}}
{{- if .Values.celery.serviceAccount.create }}
{{- default (include "baserow.celery.fullname" .) .Values.celery.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.celery.serviceAccount.name }}
{{- end }}
{{- end }}

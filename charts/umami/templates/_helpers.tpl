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
Get the name of the secret containing the app secret
*/}}
{{- define "umami.appSecret.secretName" -}}
  {{- if .Values.umami.appSecret.existingSecret -}}
    {{- printf "%s" (tpl .Values.umami.appSecret.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "umami.fullname" .) -}}-app-secret
  {{- end -}}
{{- end -}}

{{/*
Get the name of the Secret containing the two-factor encryption key
*/}}
{{- define "umami.twoFactor.secretName" -}}
  {{- if .Values.umami.twoFactor.existingSecret -}}
    {{- tpl .Values.umami.twoFactor.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-two-factor" (include "umami.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the key of the two-factor encryption key inside its Secret
*/}}
{{- define "umami.twoFactor.secretKey" -}}
  {{- if .Values.umami.twoFactor.existingSecret -}}
    {{- .Values.umami.twoFactor.existingSecretKey | default "two-factor-encryption-key" -}}
  {{- else -}}
    {{- "two-factor-encryption-key" -}}
  {{- end -}}
{{- end -}}

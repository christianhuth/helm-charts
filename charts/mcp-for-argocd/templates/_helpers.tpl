{{/*
Expand the name of the chart.
*/}}
{{- define "mcp-for-argocd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mcp-for-argocd.fullname" -}}
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
{{- define "mcp-for-argocd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mcp-for-argocd.labels" -}}
helm.sh/chart: {{ include "mcp-for-argocd.chart" . }}
{{ include "mcp-for-argocd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mcp-for-argocd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mcp-for-argocd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mcp-for-argocd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mcp-for-argocd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the secret containing the api token for authentication against argocd
*/}}
{{- define "mcp-for-argocd.auth.secretName" -}}
  {{- if .Values.argocd.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.argocd.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "mcp-for-argocd.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the api token for authentication against argocd
*/}}
{{- define "mcp-for-argocd.auth.apiToken.secretKey" -}}
  {{- if .Values.argocd.auth.existingSecretKey -}}
    {{- printf "%s" (tpl .Values.argocd.auth.existingSecretKey $) -}}
  {{- else -}}
    {{- printf "%s" "argocd-api-token" -}}
  {{- end -}}
{{- end -}}

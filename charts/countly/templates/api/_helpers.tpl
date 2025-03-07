{{/*
Define a for the api components of the chart.
*/}}
{{- define "countly.api.name" -}}
{{- include "countly.name" . | trunc 54 | trimSuffix "-" }}-api
{{- end }}

{{/*
Create a fully qualified name for the api components.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "countly.api.fullname" -}}
{{- include "countly.fullname" . | trunc 54 | trimSuffix "-" }}-api
{{- end }}

{{/*
Selector labels for the api pods and deployment
*/}}
{{- define "countly.api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "countly.api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- range $k, $v := .Values.api.selectorLabels }}
{{ $k}}: {{ $v }}
{{- end }}
{{- end }}

{{/*
Common labels for all api resources
*/}}
{{- define "countly.api.labels" -}}
helm.sh/chart: {{ include "countly.chart" . }}
{{ include "countly.api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use for the api deployment
*/}}
{{- define "countly.api.serviceAccountName" -}}
{{- if .Values.api.serviceAccount.create }}
{{- default (include "countly.api.fullname" .) .Values.api.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.api.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the secret containing the secrets for the countly api mail password
*/}}
{{- define "countly.api.mail.secretName" -}}
  {{- if .Values.config.api.mail.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.config.api.mail.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "countly.api.fullname" .) -}}
  {{- end -}}
{{- end -}}

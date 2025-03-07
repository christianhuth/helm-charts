{{/*
Define a for the frontend components of the chart.
*/}}
{{- define "countly.frontend.name" -}}
{{- include "countly.name" . | trunc 54 | trimSuffix "-" }}-frontend
{{- end }}

{{/*
Create a fully qualified name for the frontend components.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "countly.frontend.fullname" -}}
{{- include "countly.fullname" . | trunc 54 | trimSuffix "-" }}-frontend
{{- end }}

{{/*
Selector labels for the frontend pods and deployment
*/}}
{{- define "countly.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "countly.frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- range $k, $v := .Values.frontend.selectorLabels }}
{{ $k}}: {{ $v }}
{{- end }}
{{- end }}

{{/*
Common labels for all frontend resources
*/}}
{{- define "countly.frontend.labels" -}}
helm.sh/chart: {{ include "countly.chart" . }}
{{ include "countly.frontend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use for the frontend deployment
*/}}
{{- define "countly.frontend.serviceAccountName" -}}
{{- if .Values.frontend.serviceAccount.create }}
{{- default (include "countly.frontend.fullname" .) .Values.frontend.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.frontend.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "taiga.frontend.fullname" -}}
    {{- $fullname := (include "taiga.fullname" .) -}}
    {{- printf "%s-%s" $fullname "frontend" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "taiga.frontend.labels" -}}
{{ include "taiga.labels" . }}
{{ include "taiga.frontend.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "taiga.frontend.selectorLabels" -}}
{{ include "taiga.selectorLabels" . }}
app.kubernetes.io/component: "taiga-frontend"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "taiga.frontend.serviceAccountName" -}}
{{- if .Values.taiga.frontend.serviceAccount.create }}
{{- default (include "taiga.frontend.fullname" .) .Values.taiga.frontend.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.taiga.frontend.serviceAccount.name }}
{{- end }}
{{- end }}

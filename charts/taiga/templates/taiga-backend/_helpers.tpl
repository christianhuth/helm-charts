{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "taiga.backend.fullname" -}}
    {{- $fullname := (include "taiga.fullname" .) -}}
    {{- printf "%s-%s" $fullname "backend" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "taiga.backend.labels" -}}
{{ include "taiga.labels" . }}
{{ include "taiga.backend.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "taiga.backend.selectorLabels" -}}
{{ include "taiga.selectorLabels" . }}
app.kubernetes.io/component: "taiga-backend"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "taiga.backend.serviceAccountName" -}}
{{- if .Values.taiga.backend.serviceAccount.create }}
{{- default (include "taiga.backend.fullname" .) .Values.taiga.backend.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.taiga.backend.serviceAccount.name }}
{{- end }}
{{- end }}

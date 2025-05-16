{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "taiga.events.fullname" -}}
    {{- $fullname := (include "taiga.fullname" .) -}}
    {{- printf "%s-%s" $fullname "events" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "taiga.events.labels" -}}
{{ include "taiga.labels" . }}
{{ include "taiga.events.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "taiga.events.selectorLabels" -}}
{{ include "taiga.selectorLabels" . }}
app.kubernetes.io/component: "taiga-events"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "taiga.events.serviceAccountName" -}}
{{- if .Values.taiga.events.serviceAccount.create }}
{{- default (include "taiga.events.fullname" .) .Values.taiga.events.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.taiga.events.serviceAccount.name }}
{{- end }}
{{- end }}

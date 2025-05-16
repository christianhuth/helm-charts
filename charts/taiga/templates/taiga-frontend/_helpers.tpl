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

{{/*
Define the scheme to access the taiga frontend
*/}}
{{- define "taiga.frontend.scheme" -}}
    {{- if (and .Values.taiga.frontend.ingress.enabled .Values.taiga.frontend.ingress.tls) }}
        {{- printf "https" }}
    {{- else }}
        {{- printf "http" }}
    {{- end }}
{{- end }}

{{/*
Define the host to access the taiga frontend
*/}}
{{- define "taiga.frontend.host" -}}
    {{- $host := "localhost" }}
    {{- if (and .Values.taiga.frontend.ingress.enabled .Values.taiga.frontend.ingress.hosts) }}
        {{- $host = (first .Values.taiga.frontend.ingress.hosts).host }}
    {{- end }}
    {{- $host }}
{{- end }}

{{/*
Define the path to access the taiga frontend
*/}}
{{- define "taiga.frontend.path" -}}
    {{- $path := "/" }}
    {{- if (and .Values.taiga.frontend.ingress.enabled .Values.taiga.frontend.ingress.hosts) }}
        {{- $path = (first (first .Values.taiga.frontend.ingress.hosts).paths).path }}
    {{- end }}
    {{- $path }}
{{- end }}

{{/*
Create the url to access the taiga frontend
*/}}
{{- define "taiga.frontend.url" -}}
    {{- $scheme := (include "taiga.frontend.scheme" .) }}
    {{- $host := (include "taiga.frontend.host" .) }}
    {{- if not .Values.taiga.frontend.ingress.enabled }}
        {{- $host := (printf "%s:%s" $host (.Values.taiga.frontend.service.port | toString)) }}
    {{- end }}
    {{- $url := (printf "%s://%s" $scheme $host ) }}
    {{- $url }}
{{- end }}

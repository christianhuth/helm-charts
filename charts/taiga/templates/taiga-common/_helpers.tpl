{{/*
Define the scheme to access the taiga application
*/}}
{{- define "taiga.common.access.scheme" -}}
    {{- if (and .Values.taiga.common.ingress.enabled .Values.taiga.common.ingress.tls) }}
        {{- printf "https" }}
    {{- else }}
        {{- printf "http" }}
    {{- end }}
{{- end }}

{{/*
Define the host to access the taiga applications
*/}}
{{- define "taiga.common.access.host" -}}
    {{- $host := "localhost" }}
    {{- if (and .Values.taiga.common.ingress.enabled .Values.taiga.common.ingress.hostname) }}
        {{- $host = .Values.taiga.common.ingress.hostname }}
    {{- end }}
    {{- $host }}
{{- end }}

{{/*
Define the path to access the taiga application
*/}}
{{- define "taiga.common.access.path" -}}
    {{- $path := "/" }}
    {{- $path }}
{{- end }}

{{/*
Create the url to access the taiga application
*/}}
{{- define "taiga.common.access.url" -}}
    {{- $scheme := (include "taiga.common.access.scheme" .) }}
    {{- $host := (include "taiga.common.access.host" .) }}
    {{- if not .Values.taiga.common.ingress.enabled }}
        {{- $host := (printf "%s:%s" $host (.Values.taiga.frontend.service.port | toString)) }}
    {{- end }}
    {{- $url := (printf "%s://%s" $scheme $host ) }}
    {{- $url }}
{{- end }}

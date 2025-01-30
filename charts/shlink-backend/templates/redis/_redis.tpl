{{/*
Define if the Redis integration is enabled
*/}}
{{- define "shlink-backend.redis.enabled" -}}
{{- $enabled := "" -}}
{{- if or (.Values.redis.enabled) (.Values.config.redis.servers) -}}
    {{- $enabled = "true" -}}
{{- end }}
{{- $enabled -}}
{{- end }}

{{/*
Define the redis servers
*/}}
{{- define "shlink-backend.redis.servers" -}}
{{- $servers := "" -}}
{{- if .Values.redis.enabled -}}
    {{- $host := (include "common.names.fullname" .Subcharts.redis) -}}
    {{- $port := (.Values.redis.master.service.ports.redis | toString) -}}
    {{- $servers = (printf "%s-master:%s" $host $port) -}}
{{- else -}}
    {{- $servers = .Values.config.redis.servers -}}
{{- end -}}
{{- if not $servers -}}
    {{- fail "Unable to determine the list of redis server. Use config.redis.servers or activate one of the integrated Redis subchart." -}}
{{- end -}}
{{- $servers -}}
{{- end }}

{{/*
Define if the Redis integration is enabled
*/}}
{{- define "shlink-backend.redis.enabled" -}}
{{- $enabled := "" -}}
{{- if or (.Values.redis.enabled) (.Values.config.redis.enabled) -}}
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
    {{- if (include "shlink-backend.redis.sentinal.enabled" .) -}}
        {{- $servers = (printf "%s:%s" $host $port) -}}
    {{- else -}}
        {{- $servers = (printf "%s-master:%s" $host $port) -}}
    {{- end -}}
{{- else -}}
    {{- $servers = .Values.config.redis.servers -}}
{{- end -}}
{{- if not $servers -}}
    {{- fail "Unable to determine the list of redis server. Use config.redis.servers or activate the integrated Redis subchart." -}}
{{- end -}}
{{- $servers -}}
{{- end }}

{{/*
Define the redis sentinal service is enabled
*/}}
{{- define "shlink-backend.redis.sentinal.enabled" -}}
{{- $enabled := "" -}}
{{- if or (.Values.redis.sentinel.enabled) (.Values.config.redis.sentinal.enabled) -}}
    {{- $enabled = "true" -}}
{{- end }}
{{- $enabled -}}
{{- end }}

{{/*
Define the redis sentinal service
*/}}
{{- define "shlink-backend.redis.sentinal.service" -}}
{{- $sentinalService := "" -}}
{{- if .Values.redis.enabled -}}
    {{- $host := (include "common.names.fullname" .Subcharts.redis) -}}
    {{- $port := (.Values.redis.sentinel.containerPorts.sentinel | toString) -}}
    {{- $sentinalService = (printf "%s:%s" $host $port) -}}
{{- else -}}
    {{- $sentinalService = .Values.config.redis.sentinalService -}}
{{- end -}}
{{- if not $sentinalService -}}
    {{- fail "Unable to determine the name of the redis sentinal service. Use config.redis.sentinal.service or activate the integrated Redis subchart." -}}
{{- end -}}
{{- $sentinalService -}}
{{- end }}

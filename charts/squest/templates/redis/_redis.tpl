{{/*
Define the Redis host
*/}}
{{- define "squest.redis.host" -}}
{{- $host := "" -}}
{{- if .Values.redis.enabled -}}
    {{- $host = (printf "%s-master" (include "common.names.fullname" .Subcharts.redis)) -}}
{{- else -}}
    {{- $host = .Values.squest.config.redis.host -}}
{{- end -}}
{{- if not $host -}}
    {{- fail "Unable to determine the redis host. Use squest.config.redis.host or activate the integrated Redis subchart." -}}
{{- end -}}
{{- $host -}}
{{- end }}

{{/*
Get the name of the secret containing the Redis password
*/}}
{{- define "squest.redis.auth.secretName" -}}
{{- $secretName := "" -}}
{{- if .Values.redis.enabled -}}
    {{- $secretName = (include "common.names.fullname" .Subcharts.redis) -}}
{{- else if .Values.squest.config.redis.auth.existingSecret -}}
    {{- $secretName = .Values.squest.config.redis.auth.existingSecret -}}
{{- else -}}
    {{- $secretName = printf "%s-redis" (include "squest.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end }}

{{/*
Define the Redis port
*/}}
{{- define "squest.redis.port" -}}
{{- $port := "" -}}
{{- if .Values.redis.enabled -}}
    {{- $port = (.Values.redis.master.service.ports.redis | toString) -}}
{{- else -}}
    {{- $port = .Values.squest.config.redis.port -}}
{{- end -}}
{{- if not $port -}}
    {{- fail "Unable to determine the Redis port. Use squest.config.redis.port or activate the integrated Redis subchart." -}}
{{- end -}}
{{- $port -}}
{{- end }}

{{/*
Define the Redis username
*/}}
{{- define "squest.redis.auth.username" -}}
{{- $username := "" -}}
{{- if .Values.redis.enabled -}}
    {{- $username = "default" -}}
{{- else -}}
    {{- $username = .Values.squest.config.redis.auth.username -}}
{{- end -}}
{{- if not $username -}}
    {{- fail "Unable to determine the Redis username. Use squest.config.redis.auth.username or activate the integrated Redis subchart." -}}
{{- end -}}
{{- $username -}}
{{- end }}

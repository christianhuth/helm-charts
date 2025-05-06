{{/*
Define if the RabbitMQ integration is enabled
*/}}
{{- define "shlink-backend.rabbitmq.enabled" -}}
{{- $enabled := "" -}}
{{- if or (.Values.rabbitmq.enabled) (.Values.config.rabbitmq.enabled) -}}
    {{- $enabled = "true" -}}
{{- end }}
{{- $enabled -}}
{{- end }}

{{/*
Get the name of the secret containing the RabbitMQ password
*/}}
{{- define "shlink-backend.rabbitmq.auth.secretName" -}}
{{- $secretName := "" -}}
{{- if .Values.rabbitmq.enabled -}}
    {{- $secretName = (include "rabbitmq.secretPasswordName" .Subcharts.rabbitmq) -}}
{{- else if .Values.config.rabbitmq.auth.existingSecret -}}
    {{- $secretName = .Values.config.rabbitmq.auth.existingSecret -}}
{{- else -}}
    {{- $secretName = printf "%s-rabbitmq" (include "shlink-backend.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

{{/*
Define the RabbitMQ username
*/}}
{{- define "shlink-backend.rabbitmq.auth.username" -}}
{{- $username := "" -}}
{{- if .Values.rabbitmq.enabled -}}
    {{- $username = .Values.rabbitmq.auth.username -}}
{{- else -}}
    {{- $username = .Values.config.rabbitmq.auth.username -}}
{{- end -}}
{{- if not $username -}}
    {{- fail "Unable to determine the RabbitMQ username. Use config.rabbitmq.auth.username or activate the integrated RabbitMQ subchart." -}}
{{- end -}}
{{- $username -}}
{{- end }}

{{/*
Define the RabbitMQ host
*/}}
{{- define "shlink-backend.rabbitmq.host" -}}
{{- $host := "" -}}
{{- if .Values.rabbitmq.enabled -}}
    {{- $host = (include "common.names.fullname" .Subcharts.rabbitmq) -}}
{{- else -}}
    {{- $host = .Values.config.rabbitmq.host -}}
{{- end -}}
{{- if not $host -}}
    {{- fail "Unable to determine the RabbitMQ host. Use config.rabbitmq.host or activate the integrated RabbitMQ subchart." -}}
{{- end -}}
{{- $host -}}
{{- end }}

{{/*
Define the RabbitMQ port
*/}}
{{- define "shlink-backend.rabbitmq.port" -}}
{{- $port := "" -}}
{{- if .Values.rabbitmq.enabled -}}
    {{- if or (.Values.rabbitmq.service.portEnabled) (not .Values.rabbitmq.auth.tls.enabled) }}
        {{ $port = .Values.rabbitmq.service.ports.amqp }}
    {{- else if .Values.rabbitmq.auth.tls.enabled }}
        {{ $port = .Values.rabbitmq.service.ports.amqpTls }}
    {{- end }}
{{- else -}}
    {{- $port = .Values.config.rabbitmq.port -}}
{{- end -}}
{{- if not $port -}}
    {{- fail "Unable to determine the RabbitMQ port. Use config.rabbitmq.port or activate the integrated RabbitMQ subchart." -}}
{{- end -}}
{{- $port -}}
{{- end }}

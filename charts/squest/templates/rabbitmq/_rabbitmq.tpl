{{/*
Get the name of the secret containing the RabbitMQ password
*/}}
{{- define "squest.rabbitmq.auth.secretName" -}}
  {{- $secretName := "" -}}
  {{- if .Values.rabbitmq.enabled -}}
      {{- $secretName = (include "rabbitmq.secretPasswordName" .Subcharts.rabbitmq) -}}
  {{- else if .Values.squest.config.rabbitmq.auth.existingSecret -}}
      {{- $secretName = .Values.squest.config.rabbitmq.auth.existingSecret -}}
  {{- else -}}
      {{- $secretName = printf "%s-rabbitmq" (include "squest.fullname" .) -}}
  {{- end -}}
  {{- $secretName -}}
{{- end -}}

{{/*
Define the RabbitMQ password
*/}}
{{- define "squest.rabbitmq.auth.password" -}}
  {{- $password := "" -}}
  {{- if .Values.rabbitmq.enabled -}}
      {{- $password = .Values.rabbitmq.auth.password -}}
  {{- else -}}
      {{- $password = .Values.squest.config.rabbitmq.auth.password -}}
  {{- end -}}
  {{- if not $password -}}
      {{- fail "Unable to determine the RabbitMQ password. Use squest.config.rabbitmq.auth.password or activate the integrated RabbitMQ subchart." -}}
  {{- end -}}
  {{- $password -}}
{{- end }}

{{/*
Define the RabbitMQ username
*/}}
{{- define "squest.rabbitmq.auth.username" -}}
  {{- $username := "" -}}
  {{- if .Values.rabbitmq.enabled -}}
      {{- $username = .Values.rabbitmq.auth.username -}}
  {{- else -}}
      {{- $username = .Values.squest.config.rabbitmq.auth.username -}}
  {{- end -}}
  {{- if not $username -}}
      {{- fail "Unable to determine the RabbitMQ username. Use squest.config.rabbitmq.auth.username or activate the integrated RabbitMQ subchart." -}}
  {{- end -}}
  {{- $username -}}
{{- end }}

{{/*
Define the RabbitMQ host
*/}}
{{- define "squest.rabbitmq.host" -}}
  {{- $host := "" -}}
  {{- if .Values.rabbitmq.enabled -}}
      {{- $host = (include "common.names.fullname" .Subcharts.rabbitmq) -}}
  {{- else -}}
      {{- $host = .Values.squest.config.rabbitmq.host -}}
  {{- end -}}
  {{- if not $host -}}
      {{- fail "Unable to determine the RabbitMQ host. Use squest.config.rabbitmq.host or activate the integrated RabbitMQ subchart." -}}
  {{- end -}}
  {{- $host -}}
{{- end }}

{{/*
Define the RabbitMQ port
*/}}
{{- define "squest.rabbitmq.port" -}}
  {{- $port := "" -}}
  {{- if .Values.rabbitmq.enabled -}}
      {{- if or (.Values.rabbitmq.service.portEnabled) (not .Values.rabbitmq.auth.tls.enabled) }}
          {{- $port = .Values.rabbitmq.service.ports.amqp -}}
      {{- else if .Values.rabbitmq.auth.tls.enabled }}
          {{- $port = .Values.rabbitmq.service.ports.amqpTls -}}
      {{- end }}
  {{- else -}}
      {{- $port = .Values.squest.config.rabbitmq.port -}}
  {{- end -}}
  {{- if not $port -}}
      {{- fail "Unable to determine the RabbitMQ port. Use squest.config.rabbitmq.port or activate the integrated RabbitMQ subchart." -}}
  {{- end -}}
  {{- $port -}}
{{- end }}

{{/*
Define the RabbitMQ URL
*/}}
{{- define "squest.rabbitmq.url" -}}
  {{- $url := "" -}}
  {{- $username := (include "squest.rabbitmq.auth.username" .) -}}
  {{- $password := (include "squest.rabbitmq.auth.password" .) -}}
  {{- $host := (include "squest.rabbitmq.host" .) -}}
  {{- $port := (include "squest.rabbitmq.port" .) -}}
  {{- $url = (printf "amqp://%s:%s@%s:%s/" $username $password $host $port) -}}
  {{- if not $url -}}
      {{- fail "Unable to determine the RabbitMQ URL." -}}
  {{- end -}}
  {{- $url -}}
{{- end }}

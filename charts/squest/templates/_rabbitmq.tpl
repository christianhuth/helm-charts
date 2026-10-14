{{/*
DO NOT EDIT: this file is synced from .github/templates/_rabbitmq.tpl via .github/scripts/sync-shared-templates.sh

Named templates for a RabbitMQ instance bundled through the upstream chart
https://github.com/CloudPirates-io/helm-charts/tree/main/charts/rabbitmq as a dependency.
All templates expect the context of that subchart, e.g.:

  {{ include "christianhuth.rabbitmq.hostname" .Subcharts.rabbitmq }}
*/}}

{{/*
Return the hostname of the RabbitMQ Service
*/}}
{{- define "christianhuth.rabbitmq.hostname" -}}
  {{- include "rabbitmq.fullname" . -}}
{{- end -}}

{{/*
Return the AMQP port of the RabbitMQ Service
*/}}
{{- define "christianhuth.rabbitmq.port" -}}
  {{- .Values.service.amqpPort | default 5672 | toString -}}
{{- end -}}

{{/*
Return the virtual host to use (the default virtual host of RabbitMQ)
*/}}
{{- define "christianhuth.rabbitmq.vhost" -}}
  {{- "/" -}}
{{- end -}}

{{/*
Return the name of the default user
*/}}
{{- define "christianhuth.rabbitmq.username" -}}
  {{- required "auth.username is required" .Values.auth.username -}}
{{- end -}}

{{/*
Return the name of the Secret containing the password of the default user: the Secret given in
auth.existingSecret or the Secret <fullname> created by the chart (with a generated password if auth.password is empty)
*/}}
{{- define "christianhuth.rabbitmq.secretName" -}}
  {{- include "rabbitmq.secretName" . -}}
{{- end -}}

{{/*
Return the key of the password inside its Secret
*/}}
{{- define "christianhuth.rabbitmq.passwordKey" -}}
  {{- if .Values.auth.existingSecret -}}
    {{- include "rabbitmq.secretPasswordKey" . -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

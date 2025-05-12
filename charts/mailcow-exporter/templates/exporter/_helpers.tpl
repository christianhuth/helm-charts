{{/*
Define if authentication for exporter should be enabled or not
*/}}
{{- define "mailcow-exporter.exporter.auth.enabled" -}}
  {{- if .Values.config.exporter.auth.enabled -}}
    {{ "0" }}
  {{- else -}}
    {{ "1" }}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the token for authentication against the Mailcow Exporter
*/}}
{{- define "mailcow-exporter.exporter.auth.secretName" -}}
  {{- if .Values.config.exporter.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.config.exporter.auth.existingSecret $) -}}
  {{- else if or (and (.Values.config.mailcow.auth.apiKey) (not .Values.config.mailcow.auth.existingSecret)) (.Values.config.exporter.auth.securityToken) -}}
      {{- printf "%s" (include "mailcow-exporter.fullname" .) -}}-exporter-auth
  {{- else -}}
    {{- printf "%s" (include "mailcow-exporter.mailcow.auth.secretName" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the key in the secret containing the token for authentication against the Mailcow Exporter
*/}}
{{- define "mailcow-exporter.exporter.auth.key" -}}
  {{- if (or .Values.config.exporter.auth.existingSecret .Values.config.exporter.auth.securityToken) -}}
    {{- printf "mailcow-security-token" -}}
  {{- else if .Values.config.mailcow.auth.existingSecret -}}
    {{- printf "mailcow-api-key" -}}
  {{- else -}}
    {{- printf "mailcow-security-token" -}}
  {{- end -}}
{{- end -}}

{{/*
Define the port for the exporter to listen on
*/}}
{{- define "mailcow-exporter.exporter.listen" -}}
  {{- printf ":%s" (.Values.config.exporter.port | toString) }}
{{- end -}}

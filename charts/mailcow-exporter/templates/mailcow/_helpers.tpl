{{/*
Get the name of the secret containing the token for authentication against the Mailcow instance
*/}}
{{- define "mailcow-exporter.mailcow.auth.secretName" -}}
  {{- if .Values.config.mailcow.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.config.mailcow.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "mailcow-exporter.fullname" .) -}}-mailcow-auth
  {{- end -}}
{{- end -}}

{{/*
Define the scheme to use when accessing the Mailcow instance
*/}}
{{- define "mailcow-exporter.mailcow.scheme" -}}
  {{- $scheme := "" }}
  {{- if .Values.config.mailcow.scheme -}}
    {{- $scheme = .Values.config.mailcow.scheme -}}
  {{- end -}}
  {{- if not $scheme }}
    {{- fail "No scheme provided. Please use config.mailcow.scheme." }}
  {{- else if not (or (eq $scheme "http") (eq $scheme "https")) }}
    {{- fail "Unsupported value for scheme defined. Valid values are http or https." }}
  {{- end }}
  {{- $scheme }}
{{- end -}}

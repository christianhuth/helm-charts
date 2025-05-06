{{/*
Define if the Mercure integration is enabled
*/}}
{{- define "shlink-backend.mercure.enabled" -}}
{{- $enabled := "" -}}
{{- if .Values.config.mercure.enabled -}}
    {{- $enabled = "true" -}}
{{- end }}
{{- $enabled -}}
{{- end }}

{{/*
Get the name of the secret containing the API token
*/}}
{{- define "shlink-backend.mercure.auth.secretName" -}}
{{- $secretName := "" -}}
{{- if .Values.config.mercure.auth.existingSecret -}}
    {{- $secretName = .Values.config.mercure.auth.existingSecret -}}
{{- else -}}
    {{- $secretName = printf "%s-mercure" (include "shlink-backend.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

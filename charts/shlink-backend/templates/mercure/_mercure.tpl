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

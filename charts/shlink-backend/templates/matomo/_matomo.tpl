{{/*
Get the name of the secret containing the API token
*/}}
{{- define "shlink-backend.matomo.auth.secretName" -}}
{{- $secretName := "" -}}
{{- if .Values.config.matomo.auth.existingSecret -}}
    {{- $secretName = .Values.config.matomo.auth.existingSecret -}}
{{- else -}}
    {{- $secretName = printf "%s-matomo" (include "shlink-backend.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

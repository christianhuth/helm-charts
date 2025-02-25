{{/*
Get the name of the secret containing the sync master key
*/}}
{{- define "syncstorage-rs.masterKey.secretName" -}}
{{- $secretName := "" -}}
{{- if .Values.syncstorage.masterKey.existingSecret -}}
    {{- $secretName = .Values.syncstorage.masterKey.existingSecret -}}
{{- else -}}
    {{- $secretName = printf "%s" (include "syncstorage-rs.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

{{/*
Get the key of the secret containing the sync master key
*/}}
{{- define "syncstorage-rs.masterKey.secretKey" -}}
{{- $secretKey := "master-key" -}}
{{- $secretKey -}}
{{- end -}}

{{/*
Get the name of the persistent volume claim for the config directory
*/}}
{{- define "audiobookshelf.config.pvcName" -}}
  {{- if .Values.audiobookshelf.config.persistence.existingClaim -}}
    {{- printf "%s" (tpl .Values.audiobookshelf.config.persistence.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s-%s" (include "audiobookshelf.fullname" .) "config" -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the persistent volume claim for the metadata directory
*/}}
{{- define "audiobookshelf.metadata.pvcName" -}}
  {{- if .Values.audiobookshelf.metadata.persistence.existingClaim -}}
    {{- printf "%s" (tpl .Values.audiobookshelf.metadata.persistence.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s-%s" (include "audiobookshelf.fullname" .) "metadata" -}}
  {{- end -}}
{{- end -}}

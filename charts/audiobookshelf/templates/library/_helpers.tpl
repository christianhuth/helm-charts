{{/*
Get the name of the persistent volume claim for the library directory
*/}}
{{- define "audiobookshelf.library.pvcName" -}}
  {{- if .Values.audiobookshelf.library.persistence.existingClaim -}}
    {{- printf "%s" (tpl .Values.audiobookshelf.library.persistence.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s-%s" (include "audiobookshelf.fullname" .) "library" -}}
  {{- end -}}
{{- end -}}

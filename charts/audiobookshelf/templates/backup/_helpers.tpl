{{/*
Get the name of the persistent volume claim for the backup directory
*/}}
{{- define "audiobookshelf.backup.pvcName" -}}
  {{- if .Values.audiobookshelf.backup.persistence.existingClaim -}}
    {{- printf "%s" (tpl .Values.audiobookshelf.backup.persistence.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s-%s" (include "audiobookshelf.fullname" .) "backup" -}}
  {{- end -}}
{{- end -}}

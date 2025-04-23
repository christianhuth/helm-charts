{{/*
Create the name of the pvc for the data folder
*/}}
{{- define "freshrss.persistence.data.pvcName" -}}
{{- if .Values.freshrss.persistence.data.existingClaim }}
  {{- printf "%s" (tpl (toString .Values.freshrss.persistence.data.existingClaim) $) -}}
{{- else }}
  {{- printf "%s-%s" (include "freshrss.fullname" .) "data" -}}
{{- end }}
{{- end }}

{{/*
Create the name of the pvc for the extensions folder
*/}}
{{- define "freshrss.persistence.extensions.pvcName" -}}
{{- if .Values.freshrss.persistence.extensions.existingClaim }}
  {{- printf "%s" (tpl (toString .Values.freshrss.persistence.extensions.existingClaim) $) -}}
{{- else }}
  {{- printf "%s-%s" (include "freshrss.fullname" .) "extensions" -}}
{{- end }}
{{- end }}

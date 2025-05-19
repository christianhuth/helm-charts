{{/*
Return the host of the database to use
*/}}
{{- define "taiga.database.host" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.primary.fullname" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalDatabase.host $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return database service port
*/}}
{{- define "taiga.database.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.service.port" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl (toString .Values.externalDatabase.port) $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the database to use
*/}}
{{- define "taiga.database.auth.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.database" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.database $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the user to use
*/}}
{{- define "taiga.database.auth.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (include "postgresql.v1.username" .Subcharts.postgresql) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.username $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the password for the database
*/}}
{{- define "taiga.database.password" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (tpl .Values.postgresql.auth.password $) -}}
  {{- else if .Values.externalDatabase.auth.password -}}
    {{- printf "%s" (tpl .Values.externalDatabase.auth.password $) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the database password
*/}}
{{- define "taiga.database.auth.secretName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
      {{- printf "%s" (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- else -}}
      {{- printf "%s" (include "postgresql.v1.chart.fullname" .Subcharts.postgresql) -}}
    {{- end -}}
  {{- else -}}
      {{- printf "%s" (include "taiga.fullname" .) -}}-postgresql
  {{- end -}}
{{- end -}}

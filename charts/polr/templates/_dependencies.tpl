{{/*
Interface to the database used by Polr: either the bundled MariaDB instance (see _mariadb.tpl)
or the external MariaDB/MySQL database configured with externalDatabase.*
*/}}

{{- define "polr.database.hostname" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.hostname" .Subcharts.mariadb -}}
  {{- else -}}
    {{- required "externalDatabase.hostname is required if mariadb.enabled is false" (tpl .Values.externalDatabase.hostname $) -}}
  {{- end -}}
{{- end -}}

{{- define "polr.database.port" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.port" .Subcharts.mariadb -}}
  {{- else -}}
    {{- .Values.externalDatabase.port | default 3306 | toString -}}
  {{- end -}}
{{- end -}}

{{- define "polr.database.database" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.database" .Subcharts.mariadb -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.database $ -}}
  {{- end -}}
{{- end -}}

{{- define "polr.database.username" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.username" .Subcharts.mariadb -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.username $ -}}
  {{- end -}}
{{- end -}}

{{- define "polr.database.secretName" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.secretName" .Subcharts.mariadb -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- tpl .Values.externalDatabase.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-database" (include "polr.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "polr.database.passwordKey" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.passwordKey" .Subcharts.mariadb -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- .Values.externalDatabase.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Interface to the database used by TYPO3: either the bundled MariaDB instance (see _mariadb.tpl)
or the external MariaDB/MySQL database configured with externalDatabase.*
*/}}

{{- define "typo3.database.hostname" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.hostname" .Subcharts.mariadb -}}
  {{- else -}}
    {{- required "externalDatabase.hostname is required if mariadb.enabled is false" (tpl .Values.externalDatabase.hostname $) -}}
  {{- end -}}
{{- end -}}

{{- define "typo3.database.port" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.port" .Subcharts.mariadb -}}
  {{- else -}}
    {{- .Values.externalDatabase.port | default 3306 | toString -}}
  {{- end -}}
{{- end -}}

{{- define "typo3.database.database" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.database" .Subcharts.mariadb -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.database $ -}}
  {{- end -}}
{{- end -}}

{{- define "typo3.database.username" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.username" .Subcharts.mariadb -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.username $ -}}
  {{- end -}}
{{- end -}}

{{- define "typo3.database.secretName" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.secretName" .Subcharts.mariadb -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- tpl .Values.externalDatabase.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-database" (include "typo3.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "typo3.database.passwordKey" -}}
  {{- if .Values.mariadb.enabled -}}
    {{- include "christianhuth.mariadb.passwordKey" .Subcharts.mariadb -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- .Values.externalDatabase.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

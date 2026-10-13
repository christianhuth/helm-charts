{{/*
Interface to the database used by Headwind MDM: either the bundled PostgreSQL cluster (see _postgresql.tpl)
or the external database configured with externalDatabase.*
*/}}

{{/*
Return the hostname of the database
*/}}
{{- define "headwind-mdm.database.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.hostname" .Subcharts.postgresql -}}
  {{- else -}}
    {{- required "externalDatabase.hostname is required if postgresql.enabled is false" (tpl .Values.externalDatabase.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the port of the database
*/}}
{{- define "headwind-mdm.database.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.port" .Subcharts.postgresql -}}
  {{- else -}}
    {{- .Values.externalDatabase.port | default 5432 | toString -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the database
*/}}
{{- define "headwind-mdm.database.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.database" .Subcharts.postgresql -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.database $ -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the database user
*/}}
{{- define "headwind-mdm.database.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.username" .Subcharts.postgresql -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.username $ -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the Secret containing the password of the database user
*/}}
{{- define "headwind-mdm.database.secretName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.secretName" .Subcharts.postgresql -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- tpl .Values.externalDatabase.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-database" (include "headwind-mdm.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the key of the password inside the Secret of the database user
*/}}
{{- define "headwind-mdm.database.passwordKey" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.passwordKey" .Subcharts.postgresql -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- .Values.externalDatabase.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

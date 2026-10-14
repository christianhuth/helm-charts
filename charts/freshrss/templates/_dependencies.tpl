{{/*
Interface to the PostgreSQL database used by FreshRSS (freshrss.database.type: postgresql):
either the bundled PostgreSQL cluster (see _postgresql.tpl) or the external database configured with externalDatabase.*
*/}}

{{/*
Return "true" if FreshRSS uses PostgreSQL instead of SQLite
*/}}
{{- define "freshrss.database.enabled" -}}
  {{- if eq .Values.freshrss.database.type "postgresql" -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{/*
Return the hostname of the database
*/}}
{{- define "freshrss.database.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.hostname" .Subcharts.postgresql -}}
  {{- else -}}
    {{- required "externalDatabase.hostname is required if freshrss.database.type is postgresql and postgresql.enabled is false" (tpl .Values.externalDatabase.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the port of the database
*/}}
{{- define "freshrss.database.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.port" .Subcharts.postgresql -}}
  {{- else -}}
    {{- .Values.externalDatabase.port | default 5432 | toString -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the database
*/}}
{{- define "freshrss.database.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.database" .Subcharts.postgresql -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.database $ -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the database user
*/}}
{{- define "freshrss.database.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.username" .Subcharts.postgresql -}}
  {{- else -}}
    {{- tpl .Values.externalDatabase.username $ -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the Secret containing the password of the database user
*/}}
{{- define "freshrss.database.secretName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.secretName" .Subcharts.postgresql -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- tpl .Values.externalDatabase.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-database" (include "freshrss.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the key of the password inside the Secret of the database user
*/}}
{{- define "freshrss.database.passwordKey" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "christianhuth.postgresql.passwordKey" .Subcharts.postgresql -}}
  {{- else if .Values.externalDatabase.existingSecret -}}
    {{- .Values.externalDatabase.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Return the database parameters for the FreshRSS auto-install (FRESHRSS_INSTALL). The password is inserted
from the variable FRESHRSS_DB_PASSWORD with Kubernetes variable expansion, so it is never rendered into the manifest.
*/}}
{{- define "freshrss.database.installParameters" -}}
  {{- $host := include "freshrss.database.hostname" . -}}
  {{- $port := include "freshrss.database.port" . -}}
  {{- if ne $port "5432" -}}
    {{- $host = printf "%s:%s" $host $port -}}
  {{- end -}}
  {{- printf "--db-type pgsql --db-host %s --db-base %s --db-user %s --db-password $(FRESHRSS_DB_PASSWORD)" $host (include "freshrss.database.database" .) (include "freshrss.database.username" .) -}}
{{- end -}}

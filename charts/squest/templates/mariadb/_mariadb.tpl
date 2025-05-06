{{/*
Define the database host
*/}}
{{- define "squest.mariadb.host" -}}
{{- $host := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $host = (include "mariadb.primary.fullname" .Subcharts.mariadb) -}}
{{- else -}}
    {{- $host = .Values.squest.config.database.host -}}
{{- end -}}
{{- if not $host -}}
    {{- fail "Unable to determine the database host. Use config.database.host or activate the integrated database with mariadb.enabled." -}}
{{- end -}}
{{- $host -}}
{{- end }}

{{/*
Define the database port
*/}}
{{- define "squest.mariadb.port" -}}
{{- $port := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $port = .Values.mariadb.primary.service.ports.mysql -}}
{{- else -}}
    {{- $port = .Values.squest.config.database.port -}}
{{- end -}}
{{- if not $port -}}
    {{- fail "Unable to determine the database port. Use config.database.port or activate the integrated database with mariadb.enabled." -}}
{{- end -}}
{{- $port -}}
{{- end }}

{{/*
Define the database username
*/}}
{{- define "squest.mariadb.auth.username" -}}
{{- $username := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $username = .Values.mariadb.auth.username -}}
{{- else -}}
    {{- $username = .Values.squest.config.database.auth.username -}}
{{- end -}}
{{- if not $username -}}
    {{- fail "Unable to determine the database username. Use config.database.auth.username or activate the integrated database with mariadb.enabled." -}}
{{- end -}}
{{- $username -}}
{{- end }}

{{/*
Define the name of the database
*/}}
{{- define "squest.mariadb.auth.database" -}}
{{- $database := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $database = .Values.mariadb.auth.database -}}
{{- else -}}
    {{- $database = .Values.squest.config.database.auth.database -}}
{{- end -}}
{{- if not $database -}}
    {{- fail "Unable to determine the database name. Use config.database.auth.database or activate the integrated database with mariadb.enabled." -}}
{{- end -}}
{{- $database -}}
{{- end }}

{{/*
Get the name of the secret containing the database password
*/}}
{{- define "squest.mariadb.auth.secretName" -}}
{{- $secretName := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $secretName = (include "mariadb.secretName" .Subcharts.mariadb) -}}
{{- else if .Values.squest.config.database.auth.existingSecret -}}
    {{- $secretName = .Values.squest.config.database.auth.existingSecret -}}
{{- else -}}
    {{- $secretName = printf "%s-database" (include "squest.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

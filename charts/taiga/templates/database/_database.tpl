{{/*
Define the database host
*/}}
{{- define "taiga.database.host" -}}
{{- $host := "" -}}
{{- if .Values.postgresql.enabled -}}
    {{- $host = (include "postgresql.v1.primary.fullname" .Subcharts.postgresql) -}}
{{- else -}}
    {{- $host = .Values.externalDatabase.hostname -}}
{{- end -}}
{{- if not $host -}}
    {{- fail "Unable to determine the database host. Use externalDatabase.hostname or activate the integrated PostgreSQL database." -}}
{{- end -}}
{{- $host -}}
{{- end }}

{{/*
Define the database port
*/}}
{{- define "taiga.database.port" -}}
{{- $port := "" -}}
{{- if .Values.postgresql.enabled -}}
    {{- $port = (include "postgresql.v1.service.port" .Subcharts.postgresql) -}}
{{- else -}}
    {{- $port = .Values.externalDatabase.port -}}
{{- end -}}
{{- if not $port -}}
    {{- fail "Unable to determine the database port. Use externalDatabase.port or activate the integrated PostgreSQL database." -}}
{{- end -}}
{{- $port -}}
{{- end }}

{{/*
Define the database username
*/}}
{{- define "taiga.database.auth.username" -}}
{{- $username := "" -}}
{{- if .Values.postgresql.enabled -}}
    {{- $username = (include "postgresql.v1.username" .Subcharts.postgresql) -}}
{{- else -}}
    {{- $username = .Values.externalDatabase.auth.username -}}
{{- end -}}
{{- if not $username -}}
    {{- fail "Unable to determine the database username. Use externalDatabase.auth.username or activate the integrated PostgreSQL database." -}}
{{- end -}}
{{- $username -}}
{{- end }}

{{/*
Define the name of the database
*/}}
{{- define "taiga.database.auth.database" -}}
{{- $database := "" -}}
{{- if .Values.postgresql.enabled -}}
    {{- $database = (include "postgresql.v1.database" .Subcharts.postgresql) -}}
{{- else -}}
    {{- $database = .Values.externalDatabase.auth.database -}}
{{- end -}}
{{- if not $database -}}
    {{- fail "Unable to determine the database name. Use externalDatabase.auth.database or activate the integrated PostgreSQL database." -}}
{{- end -}}
{{- $database -}}
{{- end }}

{{/*
Get the name of the secret containing the database password
*/}}
{{- define "taiga.database.auth.secretName" -}}
{{- $secretName := "" -}}
{{- if .Values.postgresql.enabled -}}
    {{- $secretName = (include "postgresql.v1.secretName" .Subcharts.postgresql) -}}
{{- else if .Values.externalDatabase.auth.existingSecret -}}
    {{- $secretName = .Values.externalDatabase.auth.existingSecret -}}
{{- else -}}
    {{- $secretName = printf "%s-database" (include "taiga.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

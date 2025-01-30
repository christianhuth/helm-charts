{{/*
Define the database driver
*/}}
{{- define "shlink-backend.database.driver" -}}
{{- $driver := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $driver = "maria" -}}
{{- else if .Values.mysql.enabled -}}
    {{- $driver = "mysql" -}}
{{- else if .Values.postgresql.enabled -}}
    {{- $driver = "postgres" -}}
{{- else -}}
    {{- $driver = .Values.config.database.driver -}}
{{- end -}}
{{- if not $driver -}}
    {{- fail "Unable to determine the database driver. Use config.database.driver or activate one of the integrated databases" -}}
{{- end -}}
{{- $driver -}}
{{- end }}

{{/*
Define the database host
*/}}
{{- define "shlink-backend.database.host" -}}
{{- $host := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $host = (include "mariadb.primary.fullname" .Subcharts.mariadb) -}}
{{- else if .Values.mysql.enabled -}}
    {{- $host = (include "mysql.primary.fullname" .Subcharts.mysql) -}}
{{- else if .Values.postgresql.enabled -}}
    {{- $host = (include "postgresql.v1.primary.fullname" .Subcharts.postgresql) -}}
{{- else -}}
    {{- $host = .Values.config.database.host -}}
{{- end -}}
{{- if and (not $host) (not (eq (include "shlink-backend.database.driver" .) "sqlite")) -}}
    {{- fail "Unable to determine the database host. Use config.database.host or activate one of the integrated databases" -}}
{{- end -}}
{{- $host -}}
{{- end }}

{{/*
Define the database port
*/}}
{{- define "shlink-backend.database.port" -}}
{{- $port := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $port = .Values.mariadb.primary.service.ports.mysql -}}
{{- else if .Values.mysql.enabled -}}
    {{- $port = .Values.mysql.primary.service.ports.mysql -}}
{{- else if .Values.postgresql.enabled -}}
    {{- $port = (include "postgresql.v1.service.port" .Subcharts.postgresql) -}}
{{- else -}}
    {{- $port = .Values.config.database.port -}}
{{- end -}}
{{- if not $port -}}
    {{- $driver := (include "shlink-backend.database.driver" .) -}}
    {{- if (eq $driver "maria") -}}
        {{- $port = 3306 -}}
    {{- else if (eq $driver "mysql") -}}
        {{- $port = 3306 -}}
    {{- else if (eq $driver "postgres") -}}
        {{- $port = 5432 -}}
    {{- else if (eq $driver "sqlite") -}}
        {{- $port = 0 -}}
    {{- end -}}
{{- end -}}
{{- $port -}}
{{- end }}

{{/*
Define the database username
*/}}
{{- define "shlink-backend.database.auth.username" -}}
{{- $username := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $username = .Values.mariadb.auth.username -}}
{{- else if .Values.mysql.enabled -}}
    {{- $username = .Values.mysql.auth.username -}}
{{- else if .Values.postgresql.enabled -}}
    {{- $username = (include "postgresql.v1.username" .Subcharts.postgresql) -}}
{{- else -}}
    {{- $username = .Values.config.database.auth.username -}}
{{- end -}}
{{- if not $username -}}
    {{- fail "Unable to determine the database username. Use config.database.auth.username or activate one of the integrated databases" -}}
{{- end -}}
{{- $username -}}
{{- end }}

{{/*
Define the name of the database
*/}}
{{- define "shlink-backend.database.auth.database" -}}
{{- $database := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $database = .Values.mariadb.auth.database -}}
{{- else if .Values.mysql.enabled -}}
    {{- $database = .Values.mysql.auth.database -}}
{{- else if .Values.postgresql.enabled -}}
    {{- $database = (include "postgresql.v1.database" .Subcharts.postgresql) -}}
{{- else -}}
    {{- $database = .Values.config.database.auth.database -}}
{{- end -}}
{{- if not $database -}}
    {{- fail "Unable to determine the database name. Use config.database.auth.database or activate one of the integrated databases" -}}
{{- end -}}
{{- $database -}}
{{- end }}

{{/*
Get the name of the secret containing the database password
*/}}
{{- define "shlink-backend.database.auth.secretName" -}}
{{- $secretName := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $secretName = (include "mariadb.secretName" .Subcharts.mariadb) -}}
{{- else if .Values.mysql.enabled -}}
    {{- $secretName = (include "mysql.secretName" .Subcharts.mysql) -}}
{{- else if .Values.postgresql.enabled -}}
    {{- $secretName = (include "postgresql.v1.secretName" .Subcharts.postgresql) -}}
{{- else if .Values.config.database.auth.existingSecret -}}
    {{- $secretName = .Values.config.database.auth.existingSecret -}}
{{- else -}}
    {{- $secretName = printf "%s-database" (include "shlink-backend.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

{{/*
Get the key of the secret containing the database password
*/}}
{{- define "shlink-backend.database.auth.secretKey" -}}
{{- $secretKey := "" -}}
{{- if .Values.mariadb.enabled -}}
    {{- $secretKey = "mariadb-password" -}}
{{- else if .Values.mysql.enabled -}}
    {{- $secretKey = "mysql-password" -}}
{{- else if .Values.postgresql.enabled -}}
    {{- $secretKey = (include "postgresql.v1.userPasswordKey" .Subcharts.postgresql) -}}
{{- else -}}
    {{- $secretKey = "database-password" -}}
{{- end -}}
{{- $secretKey -}}
{{- end -}}

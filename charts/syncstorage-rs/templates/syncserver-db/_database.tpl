{{/*
Define the name of the database
*/}}
{{- define "syncstorage-rs.syncserver-db.auth.database" -}}
{{- $database := "" -}}
{{- if (index .Values "syncserver-db" "enabled") -}}
    {{- $database = (index .Values "syncserver-db" "auth" "database") -}}
{{- else -}}
    {{- $database = (index .Values "syncstorage" "syncserver-db" "auth" "database") -}}
{{- end -}}
{{- if not $database -}}
    {{- fail "Unable to determine the database name. Use config.syncserver-db.auth.database or activate the integrated MariaDB database using the syncserver-db.enabled attribute." -}}
{{- end -}}
{{- $database -}}
{{- end }}

{{/*
Define the database password
*/}}
{{- define "syncstorage-rs.syncserver-db.auth.password" -}}
{{- $password := "" -}}
{{- if (index .Values "syncserver-db" "enabled") -}}
    {{- $password = (index .Values "syncserver-db" "auth" "password") -}}
{{- else -}}
    {{- $password = (index .Values "syncstorage" "syncserver-db" "auth" "password") -}}
{{- end -}}
{{- if not $password -}}
    {{- fail "Unable to determine the database password. Use config.syncserver-db.auth.password or activate the integrated MariaDB database using the syncserver-db.enabled attribute." -}}
{{- end -}}
{{- $password -}}
{{- end }}

{{/*
Get the name of the secret containing the database password
*/}}
{{- define "syncstorage-rs.syncserver-db.auth.secretName" -}}
{{- $secretName := "" -}}
{{- if (index .Values "syncstorage" "syncserver-db" "auth" "existingSecret") -}}
    {{- $secretName = (index .Values "syncstorage" "syncserver-db" "auth" "existingSecret") -}}
{{- else -}}
    {{- $secretName = printf "%s-syncserver-db-url" (include "syncstorage-rs.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

{{/*
Define the database username
*/}}
{{- define "syncstorage-rs.syncserver-db.auth.username" -}}
{{- $username := "" -}}
{{- if (index .Values "syncserver-db" "enabled") -}}
    {{- $username = (index .Values "syncserver-db" "auth" "username") -}}
{{- else -}}
    {{- $username = (index .Values "syncstorage" "syncserver-db" "auth" "username") -}}
{{- end -}}
{{- if not $username -}}
    {{- fail "Unable to determine the database username. Use config.syncserver-db.auth.username or activate the integrated MariaDB database using the syncserver-db.enabled attribute." -}}
{{- end -}}
{{- $username -}}
{{- end }}

{{/*
Define the database host
*/}}
{{- define "syncstorage-rs.syncserver-db.host" -}}
{{- $host := "" -}}
{{- if (index .Values "syncserver-db" "enabled") -}}
    {{- $host = (include "mariadb.primary.fullname" (index .Subcharts "syncserver-db")) -}}
{{- else -}}
    {{- $host = (index .Values "syncstorage" "syncserver-db" "host") -}}
{{- end -}}
{{- if not $host -}}
    {{- fail "Unable to determine the database host. Use config.syncserver-db.host or activate the integrated MariaDB database using the syncserver-db.enabled attribute." -}}
{{- end -}}
{{- $host -}}
{{- end }}

{{/*
Define the database port
*/}}
{{- define "syncstorage-rs.syncserver-db.port" -}}
{{- $port := "" -}}
{{- if (index .Values "syncserver-db" "enabled") -}}
    {{- $port = (index .Values "syncserver-db" "primary" "service" "ports" "mysql") -}}
{{- else -}}
    {{- $port = (index .Values "syncstorage" "syncserver-db" "port") -}}
{{- end -}}
{{- if not $port -}}
    {{- fail "Unable to determine the database port. Use config.syncserver-db.port or activate the integrated MariaDB database using the syncserver-db.enabled attribute." -}}
{{- end -}}
{{- $port -}}
{{- end }}

{{/*
Get the key of the secret containing the database password
*/}}
{{- define "syncstorage-rs.syncserver-db.url" -}}
{{- $url := "" -}}
{{- $database := (include "syncstorage-rs.syncserver-db.auth.database" .) -}}
{{- $host := (include "syncstorage-rs.syncserver-db.host" .) -}}
{{- $password := (include "syncstorage-rs.syncserver-db.auth.password" .) -}}
{{- $port := (include "syncstorage-rs.syncserver-db.port" .) -}}
{{- $username := (include "syncstorage-rs.syncserver-db.auth.username" .) -}}
{{- $url = printf "mysql://%s:%s@%s:%s/%s" $username $password $host $port $database -}}
{{- $url -}}
{{- end -}}

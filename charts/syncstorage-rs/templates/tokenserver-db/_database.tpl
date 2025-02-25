{{/*
Define the name of the database
*/}}
{{- define "syncstorage-rs.tokenserver-db.auth.database" -}}
{{- $database := "" -}}
{{- if (index .Values "tokenserver-db" "enabled") -}}
    {{- $database = (index .Values "tokenserver-db" "auth" "database") -}}
{{- else -}}
    {{- $database = (index .Values "syncstorage" "tokenserver-db" "auth" "database") -}}
{{- end -}}
{{- if not $database -}}
    {{- fail "Unable to determine the database name. Use config.tokenserver-db.auth.database or activate the integrated MariaDB database using the tokenserver-db.enabled attribute." -}}
{{- end -}}
{{- $database -}}
{{- end }}

{{/*
Define the database password
*/}}
{{- define "syncstorage-rs.tokenserver-db.auth.password" -}}
{{- $password := "" -}}
{{- if (index .Values "tokenserver-db" "enabled") -}}
    {{- $password = (index .Values "tokenserver-db" "auth" "password") -}}
{{- else -}}
    {{- $password = (index .Values "syncstorage" "tokenserver-db" "auth" "password") -}}
{{- end -}}
{{- if not $password -}}
    {{- fail "Unable to determine the database password. Use config.tokenserver-db.auth.password or activate the integrated MariaDB database using the tokenserver-db.enabled attribute." -}}
{{- end -}}
{{- $password -}}
{{- end }}

{{/*
Get the name of the secret containing the database password
*/}}
{{- define "syncstorage-rs.tokenserver-db.auth.secretName" -}}
{{- $secretName := "" -}}
{{- if (index .Values "syncstorage" "tokenserver-db" "auth" "existingSecret") -}}
    {{- $secretName = (index .Values "syncstorage" "tokenserver-db" "auth" "existingSecret") -}}
{{- else -}}
    {{- $secretName = printf "%s-tokenserver-db-url" (include "syncstorage-rs.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

{{/*
Define the database username
*/}}
{{- define "syncstorage-rs.tokenserver-db.auth.username" -}}
{{- $username := "" -}}
{{- if (index .Values "tokenserver-db" "enabled") -}}
    {{- $username = (index .Values "tokenserver-db" "auth" "username") -}}
{{- else -}}
    {{- $username = (index .Values "syncstorage" "tokenserver-db" "auth" "username") -}}
{{- end -}}
{{- if not $username -}}
    {{- fail "Unable to determine the database username. Use config.tokenserver-db.auth.username or activate the integrated MariaDB database using the tokenserver-db.enabled attribute." -}}
{{- end -}}
{{- $username -}}
{{- end }}

{{/*
Define the database host
*/}}
{{- define "syncstorage-rs.tokenserver-db.host" -}}
{{- $host := "" -}}
{{- if (index .Values "tokenserver-db" "enabled") -}}
    {{- $host = (include "mariadb.primary.fullname" (index .Subcharts "tokenserver-db")) -}}
{{- else -}}
    {{- $host = (index .Values "syncstorage" "tokenserver-db" "host") -}}
{{- end -}}
{{- if not $host -}}
    {{- fail "Unable to determine the database host. Use config.tokenserver-db.host or activate the integrated MariaDB database using the tokenserver-db.enabled attribute." -}}
{{- end -}}
{{- $host -}}
{{- end }}

{{/*
Define the database port
*/}}
{{- define "syncstorage-rs.tokenserver-db.port" -}}
{{- $port := "" -}}
{{- if (index .Values "tokenserver-db" "enabled") -}}
    {{- $port = (index .Values "tokenserver-db" "primary" "service" "ports" "mysql") -}}
{{- else -}}
    {{- $port = (index .Values "syncstorage" "tokenserver-db" "port") -}}
{{- end -}}
{{- if not $port -}}
    {{- fail "Unable to determine the database port. Use config.tokenserver-db.port or activate the integrated MariaDB database using the tokenserver-db.enabled attribute." -}}
{{- end -}}
{{- $port -}}
{{- end }}

{{/*
Get the key of the secret containing the database password
*/}}
{{- define "syncstorage-rs.tokenserver-db.url" -}}
{{- $url := "" -}}
{{- $database := (include "syncstorage-rs.tokenserver-db.auth.database" .) -}}
{{- $host := (include "syncstorage-rs.tokenserver-db.host" .) -}}
{{- $password := (include "syncstorage-rs.tokenserver-db.auth.password" .) -}}
{{- $port := (include "syncstorage-rs.tokenserver-db.port" .) -}}
{{- $username := (include "syncstorage-rs.tokenserver-db.auth.username" .) -}}
{{- $url = printf "mysql://%s:%s@%s:%s/%s" $username $password $host $port $database -}}
{{- $url -}}
{{- end -}}

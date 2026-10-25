{{/*
Interface to the two databases used by syncstorage-rs: syncserver and tokenserver.
Each one is either
- the bundled MariaDB instance (subchart <name>-db, see _mariadb.tpl),
- the bundled PostgreSQL cluster shared by both databases (subchart postgresql, see _postgresql.tpl) or
- the external database configured with external<Name>Database.*

All templates expect a dict with the root context and the name of the database, e.g.:

  {{ include "syncstorage-rs.database.hostname" (dict "root" . "name" "syncserver") }}
*/}}

{{/*
Return true if the bundled MariaDB instance is enabled
*/}}
{{- define "syncstorage-rs.database.bundled" -}}
  {{- if (index .root.Values (printf "%s-db" .name)).enabled -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{/*
Return true if the bundled PostgreSQL cluster is enabled
*/}}
{{- define "syncstorage-rs.database.postgresql" -}}
  {{- if .root.Values.postgresql.enabled -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{/*
Return the values of the external database
*/}}
{{- define "syncstorage-rs.database.external" -}}
  {{- index .root.Values (printf "external%sDatabase" (title .name)) | toYaml -}}
{{- end -}}

{{/*
Return the type of the database: mysql or postgres. It is also the scheme of the database URL and the node type of the Tokenserver.
*/}}
{{- define "syncstorage-rs.database.type" -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- "mysql" -}}
  {{- else if include "syncstorage-rs.database.postgresql" . -}}
    {{- "postgres" -}}
  {{- else -}}
    {{- $type := (include "syncstorage-rs.database.external" . | fromYaml).type | default "mysql" -}}
    {{- if not (has $type (list "mysql" "postgres")) -}}
      {{- fail (printf "external%sDatabase.type must be mysql or postgres, not %s" (title .name) $type) -}}
    {{- end -}}
    {{- $type -}}
  {{- end -}}
{{- end -}}

{{/*
Validate the combination of the databases and the image, as each image only supports one database type.
Expects the root context.
*/}}
{{- define "syncstorage-rs.database.validate" -}}
  {{- $syncserver := dict "root" . "name" "syncserver" -}}
  {{- $tokenserver := dict "root" . "name" "tokenserver" -}}
  {{- if and .Values.postgresql.enabled (or (index .Values "syncserver-db").enabled (index .Values "tokenserver-db").enabled) -}}
    {{- fail "postgresql.enabled is mutually exclusive with syncserver-db.enabled and tokenserver-db.enabled, disable the bundled MariaDB instances to use PostgreSQL" -}}
  {{- end -}}
  {{- $type := include "syncstorage-rs.database.type" $syncserver -}}
  {{- if ne $type (include "syncstorage-rs.database.type" $tokenserver) -}}
    {{- fail "The Syncserver and the Tokenserver database must have the same type (mysql or postgres), as each image only supports one of them" -}}
  {{- end -}}
  {{- $repository := .Values.image.repository -}}
  {{- range $official := list "syncserver-mysql" "syncserver-postgres" -}}
    {{- if and (hasSuffix (printf "/%s" $official) $repository) (ne $official (printf "syncserver-%s" $type)) -}}
      {{- fail (printf "The databases are of type %s, but the image %s only supports %s. Set image.repository to %s" $type $repository (trimPrefix "syncserver-" $official) (printf "%s/syncserver-%s" (dir $repository) $type)) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Return the hostname of the database
*/}}
{{- define "syncstorage-rs.database.hostname" -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- include "christianhuth.mariadb.hostname" (index .root.Subcharts (printf "%s-db" .name)) -}}
  {{- else if include "syncstorage-rs.database.postgresql" . -}}
    {{- include "christianhuth.postgresql.hostname" .root.Subcharts.postgresql -}}
  {{- else -}}
    {{- $external := include "syncstorage-rs.database.external" . | fromYaml -}}
    {{- required (printf "external%sDatabase.hostname is required if neither %s-db.enabled nor postgresql.enabled is true" (title .name) .name) $external.hostname -}}
  {{- end -}}
{{- end -}}

{{/*
Return the port of the database
*/}}
{{- define "syncstorage-rs.database.port" -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- include "christianhuth.mariadb.port" (index .root.Subcharts (printf "%s-db" .name)) -}}
  {{- else if include "syncstorage-rs.database.postgresql" . -}}
    {{- include "christianhuth.postgresql.port" .root.Subcharts.postgresql -}}
  {{- else -}}
    {{- $default := ternary "5432" "3306" (eq (include "syncstorage-rs.database.type" .) "postgres") -}}
    {{- (include "syncstorage-rs.database.external" . | fromYaml).port | default $default | toString -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the database
*/}}
{{- define "syncstorage-rs.database.database" -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- include "christianhuth.mariadb.database" (index .root.Subcharts (printf "%s-db" .name)) -}}
  {{- else if include "syncstorage-rs.database.postgresql" . -}}
    {{- include "christianhuth.postgresql.database" .root.Subcharts.postgresql -}}
  {{- else -}}
    {{- (include "syncstorage-rs.database.external" . | fromYaml).database -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the database user
*/}}
{{- define "syncstorage-rs.database.username" -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- include "christianhuth.mariadb.username" (index .root.Subcharts (printf "%s-db" .name)) -}}
  {{- else if include "syncstorage-rs.database.postgresql" . -}}
    {{- include "christianhuth.postgresql.username" .root.Subcharts.postgresql -}}
  {{- else -}}
    {{- (include "syncstorage-rs.database.external" . | fromYaml).username -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the Secret containing the password of the database user
*/}}
{{- define "syncstorage-rs.database.secretName" -}}
  {{- $external := include "syncstorage-rs.database.external" . | fromYaml -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- include "christianhuth.mariadb.secretName" (index .root.Subcharts (printf "%s-db" .name)) -}}
  {{- else if include "syncstorage-rs.database.postgresql" . -}}
    {{- include "christianhuth.postgresql.secretName" .root.Subcharts.postgresql -}}
  {{- else if $external.existingSecret -}}
    {{- $external.existingSecret -}}
  {{- else -}}
    {{- printf "%s-%s-db" (include "syncstorage-rs.fullname" .root) .name -}}
  {{- end -}}
{{- end -}}

{{/*
Return the key of the password inside the Secret of the database user
*/}}
{{- define "syncstorage-rs.database.passwordKey" -}}
  {{- $external := include "syncstorage-rs.database.external" . | fromYaml -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- include "christianhuth.mariadb.passwordKey" (index .root.Subcharts (printf "%s-db" .name)) -}}
  {{- else if include "syncstorage-rs.database.postgresql" . -}}
    {{- include "christianhuth.postgresql.passwordKey" .root.Subcharts.postgresql -}}
  {{- else if $external.existingSecret -}}
    {{- $external.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Render the environment variables providing the connection URL of the database in the variable given as "env".
The bundled MariaDB instance provides a ready-to-use URL with an URL-encoded password in its Connection Secret.
For PostgreSQL and external databases the URL is assembled from the password Secret using Kubernetes variable
expansion. The URL of the operator's Secret can't be used for PostgreSQL, as it uses the scheme postgresql://,
but the Tokenserver only accepts postgres://.
*/}}
{{- define "syncstorage-rs.database.urlEnv" -}}
{{- if include "syncstorage-rs.database.bundled" . }}
{{- $subchart := index .root.Subcharts (printf "%s-db" .name) }}
- name: {{ .env }}
  valueFrom:
    secretKeyRef:
      name: {{ include "christianhuth.mariadb.connectionSecretName" $subchart | quote }}
      key: {{ include "christianhuth.mariadb.connectionSecretKey" $subchart | quote }}
{{- else }}
{{- $passwordEnv := printf "%s_DB_PASSWORD" (upper .name) }}
- name: {{ $passwordEnv }}
  valueFrom:
    secretKeyRef:
      name: {{ include "syncstorage-rs.database.secretName" . | quote }}
      key: {{ include "syncstorage-rs.database.passwordKey" . | quote }}
- name: {{ .env }}
  value: {{ printf "%s://%s:$(%s)@%s:%s/%s" (include "syncstorage-rs.database.type" .) (include "syncstorage-rs.database.username" .) $passwordEnv (include "syncstorage-rs.database.hostname" .) (include "syncstorage-rs.database.port" .) (include "syncstorage-rs.database.database" .) | quote }}
{{- end }}
{{- end -}}

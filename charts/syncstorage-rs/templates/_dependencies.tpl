{{/*
Interface to the two databases used by syncstorage-rs: syncserver and tokenserver.
Each one is either the bundled MariaDB instance (subchart <name>-db, see _mariadb.tpl)
or the external database configured with external<Name>Database.*

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
Return the values of the external database
*/}}
{{- define "syncstorage-rs.database.external" -}}
  {{- index .root.Values (printf "external%sDatabase" (title .name)) | toYaml -}}
{{- end -}}

{{/*
Return the hostname of the database
*/}}
{{- define "syncstorage-rs.database.hostname" -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- include "christianhuth.mariadb.hostname" (index .root.Subcharts (printf "%s-db" .name)) -}}
  {{- else -}}
    {{- $external := include "syncstorage-rs.database.external" . | fromYaml -}}
    {{- required (printf "external%sDatabase.hostname is required if %s-db.enabled is false" (title .name) .name) $external.hostname -}}
  {{- end -}}
{{- end -}}

{{/*
Return the port of the database
*/}}
{{- define "syncstorage-rs.database.port" -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- include "christianhuth.mariadb.port" (index .root.Subcharts (printf "%s-db" .name)) -}}
  {{- else -}}
    {{- (include "syncstorage-rs.database.external" . | fromYaml).port | default 3306 | toString -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the database
*/}}
{{- define "syncstorage-rs.database.database" -}}
  {{- if include "syncstorage-rs.database.bundled" . -}}
    {{- include "christianhuth.mariadb.database" (index .root.Subcharts (printf "%s-db" .name)) -}}
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
  {{- else if $external.existingSecret -}}
    {{- $external.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Render the environment variables providing the connection URL of the database in the variable given as "env".
The bundled MariaDB instance provides a ready-to-use URL with an URL-encoded password in its Connection Secret.
For external databases the URL is assembled from the password Secret using Kubernetes variable expansion.
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
  value: {{ printf "mysql://%s:$(%s)@%s:%s/%s" (include "syncstorage-rs.database.username" .) $passwordEnv (include "syncstorage-rs.database.hostname" .) (include "syncstorage-rs.database.port" .) (include "syncstorage-rs.database.database" .) | quote }}
{{- end }}
{{- end -}}

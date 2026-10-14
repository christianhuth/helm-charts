{{/*
DO NOT EDIT: this file is synced from .github/templates/_mariadb.tpl via .github/scripts/sync-shared-templates.sh

Named templates for a MariaDB instance managed by the mariadb-operator.
It is bundled through the upstream chart https://github.com/mariadb-operator/mariadb-operator/tree/main/deploy/charts/mariadb-cluster
as a dependency. All templates expect the context of that subchart, e.g.:

  {{ include "christianhuth.mariadb.hostname" .Subcharts.mariadb }}
  {{ include "christianhuth.mariadb.hostname" (index .Subcharts "my-alias") }}
*/}}

{{/*
Return the hostname of the Service pointing to the primary instance
*/}}
{{- define "christianhuth.mariadb.hostname" -}}
  {{- $fullname := include "mariadb-cluster.fullname" . -}}
  {{- if or (.Values.mariadb.galera | default dict).enabled (.Values.mariadb.replication | default dict).enabled -}}
    {{- printf "%s-primary" $fullname -}}
  {{- else -}}
    {{- $fullname -}}
  {{- end -}}
{{- end -}}

{{/*
Return the port of the MariaDB Services
*/}}
{{- define "christianhuth.mariadb.port" -}}
  {{- .Values.mariadb.port | default 3306 | toString -}}
{{- end -}}

{{/*
Return the name of the initial database
*/}}
{{- define "christianhuth.mariadb.database" -}}
  {{- required "mariadb.database is required" .Values.mariadb.database -}}
{{- end -}}

{{/*
Return the name of the initial user
*/}}
{{- define "christianhuth.mariadb.username" -}}
  {{- required "mariadb.username is required" .Values.mariadb.username -}}
{{- end -}}

{{/*
Return the name of the Secret containing the password of the initial user.
Mirrors the naming of the upstream chart: <fullname>-<key> if no name is given.
*/}}
{{- define "christianhuth.mariadb.secretName" -}}
  {{- $ref := required "mariadb.passwordSecretKeyRef is required" .Values.mariadb.passwordSecretKeyRef -}}
  {{- $ref.name | default (printf "%s-%s" (include "mariadb-cluster.fullname" .) $ref.key) -}}
{{- end -}}

{{/*
Return the key of the password inside the Secret of the initial user
*/}}
{{- define "christianhuth.mariadb.passwordKey" -}}
  {{- .Values.mariadb.passwordSecretKeyRef.key -}}
{{- end -}}

{{/*
Return the name of the Secret containing the root password
*/}}
{{- define "christianhuth.mariadb.rootSecretName" -}}
  {{- $ref := .Values.mariadb.rootPasswordSecretKeyRef -}}
  {{- $ref.name | default (printf "%s-%s" (include "mariadb-cluster.fullname" .) $ref.key) -}}
{{- end -}}

{{/*
Return the key of the root password inside its Secret
*/}}
{{- define "christianhuth.mariadb.rootPasswordKey" -}}
  {{- .Values.mariadb.rootPasswordSecretKeyRef.key -}}
{{- end -}}

{{/*
Return the name of the Secret created by the operator for mariadb.connection
*/}}
{{- define "christianhuth.mariadb.connectionSecretName" -}}
  {{- (.Values.mariadb.connection | default dict).secretName | default (include "mariadb-cluster.fullname" .) -}}
{{- end -}}

{{/*
Return the key of the connection string inside the Secret created for mariadb.connection
*/}}
{{- define "christianhuth.mariadb.connectionSecretKey" -}}
  {{- ((.Values.mariadb.connection | default dict).secretTemplate | default dict).key | default "dsn" -}}
{{- end -}}

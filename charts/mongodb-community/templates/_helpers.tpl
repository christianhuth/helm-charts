{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb-community.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Name of the MongoDBCommunity resource and its replica set. Truncated to 48 characters, as the operator
derives the names of further resources (e.g. the StatefulSet `<name>-arb`) from it.
*/}}
{{- define "mongodb-community.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 48 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 48 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 48 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mongodb-community.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mongodb-community.labels" -}}
helm.sh/chart: {{ include "mongodb-community.chart" . }}
app.kubernetes.io/name: {{ include "mongodb-community.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Name of the ServiceAccount of the database pods. Empty if the operator's default is used.
*/}}
{{- define "mongodb-community.serviceAccountName" -}}
{{- if .Values.serviceAccount.name }}
{{- .Values.serviceAccount.name }}
{{- else if .Values.serviceAccount.create }}
{{- printf "%s-database" (include "mongodb-community.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Users of the replica set: the configured users plus the user of MongoDB Search
*/}}
{{- define "mongodb-community.users" -}}
{{- $users := deepCopy (.Values.mongodb.users | default list) }}
{{- if and .Values.search.enabled (not (include "mongodb-community.findUser" (dict "users" $users "user" "search-sync-source"))) }}
{{- $users = append $users (dict "name" "search-sync-source" "db" "admin" "roles" (list (dict "name" "searchCoordinator" "db" "admin"))) }}
{{- end }}
{{- toYaml $users }}
{{- end }}

{{/*
Returns the user with the given name as YAML, or nothing if it does not exist.
Usage: include "mongodb-community.findUser" (dict "users" <list> "user" "<name>")
*/}}
{{- define "mongodb-community.findUser" -}}
{{- range .users }}
{{- if eq .name $.user }}
{{- toYaml . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Name of the Secret the chart generates for a user without passwordSecretRef. MongoDB Search expects the
password of its user in `<fullname>-search-sync-source-password`.
Usage: include "mongodb-community.generatedPasswordSecretName" (dict "context" $ "user" "<name>")
*/}}
{{- define "mongodb-community.generatedPasswordSecretName" -}}
{{- printf "%s-%s-password" (include "mongodb-community.fullname" .context) (.user | lower | replace "_" "-") | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
=====================================================================================================
Named templates for charts using this chart as a dependency. Call them with the context of this chart,
e.g. `include "mongodb-community.hostname" .Subcharts.mongodb`. Their names and output are stable within
a major version of the chart.
=====================================================================================================
*/}}

{{/*
Hostname of the replica set: the headless Service created by the operator
*/}}
{{- define "mongodb-community.hostname" -}}
{{- printf "%s-svc" (include "mongodb-community.fullname" .) }}
{{- end }}

{{/*
Port of the replica set members
*/}}
{{- define "mongodb-community.port" -}}
{{- $config := .Values.mongodb.additionalMongodConfig | default dict }}
{{- index $config "net.port" | default (dig "net" "port" 27017 $config) | toString }}
{{- end }}

{{/*
Name of the replica set
*/}}
{{- define "mongodb-community.replicaSetName" -}}
{{- include "mongodb-community.fullname" . }}
{{- end }}

{{/*
Name of the Secret containing the password of a user
Usage: include "mongodb-community.userPasswordSecretName" (dict "context" .Subcharts.mongodb "user" "<name>")
*/}}
{{- define "mongodb-community.userPasswordSecretName" -}}
{{- $user := include "mongodb-community.findUser" (dict "users" (include "mongodb-community.users" .context | fromYamlArray) "user" .user) | fromYaml }}
{{- if not $user }}
{{- fail (printf "user %s is not defined in mongodb.users" .user) }}
{{- end }}
{{- if $user.passwordSecretRef }}
{{- $user.passwordSecretRef.name }}
{{- else }}
{{- include "mongodb-community.generatedPasswordSecretName" . }}
{{- end }}
{{- end }}

{{/*
Key of the password in the Secret of a user
Usage: include "mongodb-community.userPasswordSecretKey" (dict "context" .Subcharts.mongodb "user" "<name>")
*/}}
{{- define "mongodb-community.userPasswordSecretKey" -}}
{{- $user := include "mongodb-community.findUser" (dict "users" (include "mongodb-community.users" .context | fromYamlArray) "user" .user) | fromYaml }}
{{- if not $user }}
{{- fail (printf "user %s is not defined in mongodb.users" .user) }}
{{- end }}
{{- dig "passwordSecretRef" "key" "password" $user }}
{{- end }}

{{/*
Name of the Secret the operator creates with the connection strings of a user (keys `connectionString.standard`,
`connectionString.standardSrv`, `username` and `password`)
Usage: include "mongodb-community.userConnectionStringSecretName" (dict "context" .Subcharts.mongodb "user" "<name>")
*/}}
{{- define "mongodb-community.userConnectionStringSecretName" -}}
{{- $user := include "mongodb-community.findUser" (dict "users" (include "mongodb-community.users" .context | fromYamlArray) "user" .user) | fromYaml }}
{{- if not $user }}
{{- fail (printf "user %s is not defined in mongodb.users" .user) }}
{{- end }}
{{- $user.connectionStringSecretName | default (printf "%s-%s-%s" (include "mongodb-community.fullname" .context) ($user.db | default "admin") $user.name) }}
{{- end }}

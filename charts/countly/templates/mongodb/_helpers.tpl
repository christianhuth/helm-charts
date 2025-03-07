{{/*
Return the hostname of the mongodb to use
*/}}
{{- define "countly.mongodb.hostname" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- printf "%s" (include "mongodb.service.nameOverride" .Subcharts.mongodb) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalMongodb.hostname $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return mongodb service port
*/}}
{{- define "countly.mongodb.port" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- printf "%s" (tpl (toString .Values.mongodb.service.ports.mongodb) $) -}}
  {{- else -}}
    {{- printf "%s" (tpl (toString .Values.externalMongodb.port) $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name for the database to use
*/}}
{{- define "countly.mongodb.auth.database" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- printf "%s" (tpl .Values.mongodb.auth.database $) -}}
  {{- else -}}
    {{- printf "%s" (tpl .Values.externalMongodb.auth.database $) -}}
  {{- end -}}
{{- end -}}

{{/*
Return mongodb url
*/}}
{{- define "countly.mongodb.url" -}}
  {{- $hostname := (include "countly.mongodb.hostname" .) }}
  {{- $port := (include "countly.mongodb.port" .) }}
  {{- $database := (include "countly.mongodb.auth.database" .) }}
  {{- printf "mongodb://%s:%s/%s" $hostname $port $database -}}
{{- end -}}

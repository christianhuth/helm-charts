{{/*
Interface to the Redis-compatible server used by kube-ops-view for pub/sub and job locking:
either the bundled Valkey instance (see _valkey.tpl) or the external server configured with externalRedis.*
*/}}

{{/*
Return "true" if a Redis-compatible server is configured
*/}}
{{- define "kube-ops-view.redis.enabled" -}}
  {{- if or .Values.valkey.enabled .Values.externalRedis.hostname -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{/*
Return the hostname of the server
*/}}
{{- define "kube-ops-view.redis.hostname" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.hostname" .Subcharts.valkey -}}
  {{- else -}}
    {{- tpl .Values.externalRedis.hostname $ -}}
  {{- end -}}
{{- end -}}

{{/*
Return the port of the server
*/}}
{{- define "kube-ops-view.redis.port" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.port" .Subcharts.valkey -}}
  {{- else -}}
    {{- .Values.externalRedis.port | default 6379 | toString -}}
  {{- end -}}
{{- end -}}

{{/*
Return "true" if kube-ops-view has to authenticate
*/}}
{{- define "kube-ops-view.redis.authEnabled" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.authEnabled" .Subcharts.valkey -}}
  {{- else if or .Values.externalRedis.password .Values.externalRedis.existingSecret -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{/*
Return the user kube-ops-view authenticates as (empty to authenticate with a password only)
*/}}
{{- define "kube-ops-view.redis.username" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.username" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else -}}
    {{- .Values.externalRedis.username -}}
  {{- end -}}
{{- end -}}

{{/*
Return the name of the Secret containing the password
*/}}
{{- define "kube-ops-view.redis.secretName" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.secretName" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else if .Values.externalRedis.existingSecret -}}
    {{- tpl .Values.externalRedis.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-redis" (include "kube-ops-view.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the key of the password inside its Secret
*/}}
{{- define "kube-ops-view.redis.passwordKey" -}}
  {{- if .Values.valkey.enabled -}}
    {{- include "christianhuth.valkey.passwordKey" (dict "subchart" .Subcharts.valkey "user" "default") -}}
  {{- else if .Values.externalRedis.existingSecret -}}
    {{- .Values.externalRedis.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Render the environment variables providing the Redis URL (REDIS_URL) to kube-ops-view.
The password is inserted with Kubernetes variable expansion, so it must only contain URL-safe characters.
*/}}
{{- define "kube-ops-view.redis.env" -}}
{{- $userinfo := "" }}
{{- if include "kube-ops-view.redis.authEnabled" . }}
{{- $userinfo = printf "%s:$(REDIS_PASSWORD)@" (include "kube-ops-view.redis.username" .) }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "kube-ops-view.redis.secretName" . | quote }}
      key: {{ include "kube-ops-view.redis.passwordKey" . | quote }}
{{- end }}
- name: REDIS_URL
  value: {{ printf "redis://%s%s:%s" $userinfo (include "kube-ops-view.redis.hostname" .) (include "kube-ops-view.redis.port" .) | quote }}
{{- end -}}

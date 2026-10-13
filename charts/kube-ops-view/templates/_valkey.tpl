{{/*
DO NOT EDIT: this file is synced from .github/templates/_valkey.tpl via .github/scripts/sync-shared-templates.sh

Named templates for a Valkey instance bundled through the official upstream chart
https://github.com/valkey-io/valkey-helm/tree/main/valkey as a dependency (standalone or primary with replicas).
Templates about the connection expect the context of that subchart, e.g.:

  {{ include "christianhuth.valkey.hostname" .Subcharts.valkey }}

Templates about credentials expect a dict with the subchart context and the ACL user the application
authenticates as (defaults to "default", the user used by clients only sending a password), e.g.:

  {{ include "christianhuth.valkey.secretName" (dict "subchart" .Subcharts.valkey "user" "default") }}
*/}}

{{/*
Return the hostname of the Service pointing to the primary instance
*/}}
{{- define "christianhuth.valkey.hostname" -}}
  {{- include "valkey.fullname" . -}}
{{- end -}}

{{/*
Return the hostname of the Service balancing read-only traffic across all instances.
Falls back to the primary if no replicas or no read Service are enabled.
*/}}
{{- define "christianhuth.valkey.readHostname" -}}
  {{- if and .Values.replica.enabled .Values.replica.service.enabled -}}
    {{- printf "%s-read" (include "valkey.fullname" .) -}}
  {{- else -}}
    {{- include "valkey.fullname" . -}}
  {{- end -}}
{{- end -}}

{{/*
Return the port of the Valkey Services
*/}}
{{- define "christianhuth.valkey.port" -}}
  {{- .Values.service.port | default 6379 | toString -}}
{{- end -}}

{{/*
Return "true" if authentication is enabled
*/}}
{{- define "christianhuth.valkey.authEnabled" -}}
  {{- if .Values.auth.enabled -}}
    {{- "true" -}}
  {{- end -}}
{{- end -}}

{{/*
Return the ACL user the application authenticates as. Fails if authentication is enabled
and the user is not defined in auth.aclUsers.
*/}}
{{- define "christianhuth.valkey.username" -}}
  {{- $user := .user | default "default" -}}
  {{- if and .subchart.Values.auth.enabled (not (hasKey (.subchart.Values.auth.aclUsers | default dict) $user)) -}}
    {{- fail (printf "The Valkey user %q has to be defined in auth.aclUsers if auth.enabled is true" $user) -}}
  {{- end -}}
  {{- $user -}}
{{- end -}}

{{/*
Return the name of the Secret containing the password of the user: the Secret given in
auth.usersExistingSecret or the Secret <fullname>-auth created for inline passwords.
*/}}
{{- define "christianhuth.valkey.secretName" -}}
  {{- $_ := include "christianhuth.valkey.username" . -}}
  {{- with .subchart.Values.auth.usersExistingSecret -}}
    {{- tpl . $.subchart -}}
  {{- else -}}
    {{- printf "%s-auth" (include "valkey.fullname" .subchart) -}}
  {{- end -}}
{{- end -}}

{{/*
Return the key of the password of the user inside its Secret: auth.aclUsers.<user>.passwordKey
(defaulting to the username) in an existing Secret, or <user>-password for inline passwords.
*/}}
{{- define "christianhuth.valkey.passwordKey" -}}
  {{- $user := include "christianhuth.valkey.username" . -}}
  {{- if .subchart.Values.auth.usersExistingSecret -}}
    {{- (index .subchart.Values.auth.aclUsers $user).passwordKey | default $user -}}
  {{- else -}}
    {{- printf "%s-password" $user -}}
  {{- end -}}
{{- end -}}

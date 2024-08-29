{{/*
Expand the name of the chart.
*/}}
{{- define "maildev.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "maildev.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "maildev.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "maildev.labels" -}}
helm.sh/chart: {{ include "maildev.chart" . }}
{{ include "maildev.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "maildev.selectorLabels" -}}
app.kubernetes.io/name: {{ include "maildev.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "maildev.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "maildev.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the persistent volume claim
*/}}
{{- define "maildev.pvcName" -}}
  {{- if .Values.maildev.persistence.existingClaim -}}
    {{- printf "%s" (tpl .Values.maildev.persistence.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s" (include "maildev.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the web user password
*/}}
{{- define "maildev.web.secretName" -}}
  {{- if .Values.maildev.config.web.existingSecret -}}
    {{- printf "%s" .Values.maildev.config.web.existingSecret -}}
  {{- else -}}
      {{- printf "%s" (include "maildev.fullname" .) -}}-web
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the password for the incoming SMTP traffic
*/}}
{{- define "maildev.smtp.incoming.secretName" -}}
  {{- if .Values.maildev.config.smtp.incoming.existingSecret -}}
    {{- printf "%s" .Values.maildev.config.smtp.incoming.existingSecret -}}
  {{- else -}}
      {{- printf "%s" (include "maildev.fullname" .) -}}-smtp-incoming
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the cert and key for the incoming SMTP SSL traffic
*/}}
{{- define "maildev.smtp.incoming.tls.secretName" -}}
  {{- if .Values.maildev.config.smtp.incoming.tls.existingSecret -}}
    {{- printf "%s" .Values.maildev.config.smtp.incoming.tls.existingSecret -}}
  {{- else -}}
      {{- printf "%s" (include "maildev.fullname" .) -}}-smtp-incoming-tls
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the password for the outgoing SMTP traffic
*/}}
{{- define "maildev.smtp.outgoing.secretName" -}}
  {{- if .Values.maildev.config.smtp.outgoing.existingSecret -}}
    {{- printf "%s" .Values.maildev.config.smtp.outgoing.existingSecret -}}
  {{- else -}}
      {{- printf "%s" (include "maildev.fullname" .) -}}-smtp-outgoing
  {{- end -}}
{{- end -}}

{{/*
Get the name of the configmap containing the relay rules for the SMTP traffic
*/}}
{{- define "maildev.smtp.outgoing.autoRelay.configMapName" -}}
  {{- printf "%s" (include "maildev.fullname" .) -}}-smtp-relay-rules
{{- end -}}

{{/*
Get the name of the service for the SMTP traffic
*/}}
{{- define "maildev.smtp.serviceName" -}}
  {{- printf "%s" (include "maildev.fullname" .) -}}-smtp
{{- end -}}

{{/*
Get the name of the service for the Web GUI
*/}}
{{- define "maildev.web.serviceName" -}}
  {{- printf "%s" (include "maildev.fullname" .) -}}-web
{{- end -}}

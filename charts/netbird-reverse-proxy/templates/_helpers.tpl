{{/*
Expand the name of the chart.
*/}}
{{- define "netbird-reverse-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "netbird-reverse-proxy.fullname" -}}
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
{{- define "netbird-reverse-proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "netbird-reverse-proxy.labels" -}}
helm.sh/chart: {{ include "netbird-reverse-proxy.chart" . }}
{{ include "netbird-reverse-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "netbird-reverse-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird-reverse-proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "netbird-reverse-proxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "netbird-reverse-proxy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the secret containing the proxy token
*/}}
{{- define "netbird-reverse-proxy.proxy.secretName" -}}
  {{- if .Values.proxy.managementServer.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.proxy.managementServer.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "netbird-reverse-proxy.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the Secret containing the TLS certificate served to clients.
Resolves to the user-provided secret (source=secret) or the chart-managed
self-signed secret (source=selfSigned). Not used for source=acme.
*/}}
{{- define "netbird-reverse-proxy.proxy.tls.secretName" -}}
  {{- if eq .Values.proxy.tls.source "secret" -}}
    {{- printf "%s" (tpl .Values.proxy.tls.existingSecret $) -}}
  {{- else -}}
    {{- printf "%s-tls" (include "netbird-reverse-proxy.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Whether the proxy needs its HTTP (port 80) listener: either proxy.private's per-account
:80/:443 listeners, or ACME http-01 challenges. Outside these cases nothing binds port 80.
Returns a non-empty string (truthy) or empty string (falsy).
*/}}
{{- define "netbird-reverse-proxy.needsHttpPort" -}}
{{- if or .Values.proxy.private (and (eq .Values.proxy.tls.source "acme") (eq .Values.proxy.tls.acme.challengeType "http-01")) -}}
true
{{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the ACME EAB HMAC key
*/}}
{{- define "netbird-reverse-proxy.proxy.tls.acme.eabSecretName" -}}
  {{- printf "%s" (tpl .Values.proxy.tls.acme.eab.existingSecret $) -}}
{{- end -}}

{{/*
Get the name of the secret containing the CrowdSec bouncer API key
*/}}
{{- define "netbird-reverse-proxy.proxy.crowdsec.secretName" -}}
  {{- if .Values.proxy.crowdsec.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.proxy.crowdsec.auth.existingSecret $) -}}
  {{- else -}}
    {{- printf "%s-crowdsec" (include "netbird-reverse-proxy.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the PersistentVolumeClaim for certificate storage
*/}}
{{- define "netbird-reverse-proxy.pvcName" -}}
  {{- if .Values.persistence.existingClaim -}}
    {{- printf "%s" (tpl .Values.persistence.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s" (include "netbird-reverse-proxy.fullname" .) -}}
  {{- end -}}
{{- end -}}

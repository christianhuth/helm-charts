{{/*
Expand the name of the chart.
*/}}
{{- define "etcd-defrag.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "etcd-defrag.fullname" -}}
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
{{- define "etcd-defrag.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "etcd-defrag.labels" -}}
helm.sh/chart: {{ include "etcd-defrag.chart" . }}
{{ include "etcd-defrag.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "etcd-defrag.selectorLabels" -}}
app.kubernetes.io/name: {{ include "etcd-defrag.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "etcd-defrag.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "etcd-defrag.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the secret containing the authentication password
*/}}
{{- define "etcd-defrag.auth.secretName" -}}
  {{- if .Values.defrag.config.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.defrag.config.auth.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "etcd-defrag.fullname" .) -}}-auth
  {{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the keys and certificates
*/}}
{{- define "etcd-defrag.pki.secretName" -}}
  {{- if .Values.defrag.config.pki.existingSecret -}}
    {{- printf "%s" (tpl .Values.defrag.config.pki.existingSecret $) -}}
  {{- else -}}
      {{- printf "%s" (include "etcd-defrag.fullname" .) -}}-pki
  {{- end -}}
{{- end -}}

{{/*
Create the etcdctl args used to defrag etcd.
The etcd image is distroless (no shell), so every flag must be its own list item without
shell quoting, and env vars must use the Kubernetes $(VAR) syntax instead of $VAR.
*/}}
{{- define "etcd-defrag.defrag.args" -}}
{{- $config := .Values.defrag.config -}}
{{- $args := list -}}
{{- if $config.endpoints -}}
  {{- $args = append $args (printf "--endpoints=%s" (join "," $config.endpoints)) -}}
{{- else -}}
  {{- $args = append $args "--endpoints=localhost:2379" -}}
{{- end -}}
{{- $args = append $args "--cacert=/tmp/kubernetes/pki/etcd/ca.crt" -}}
{{- $args = append $args "--cert=/tmp/kubernetes/pki/etcd/server.crt" -}}
{{- $args = append $args "--key=/tmp/kubernetes/pki/etcd/server.key" -}}
{{- if $config.commandTimeout -}}
  {{- $args = append $args (printf "--command-timeout=%s" $config.commandTimeout) -}}
{{- end -}}
{{- if $config.debug -}}
  {{- $args = append $args "--debug=true" -}}
{{- end -}}
{{- if $config.dialTimeout -}}
  {{- $args = append $args (printf "--dial-timeout=%s" $config.dialTimeout) -}}
{{- end -}}
{{- if $config.insecureSkipTlsVerify -}}
  {{- $args = append $args (printf "--insecure-skip-tls-verify=%v" $config.insecureSkipTlsVerify) -}}
{{- end -}}
{{- if $config.insecureTransport -}}
  {{- $args = append $args (printf "--insecure-transport=%v" $config.insecureTransport) -}}
{{- end -}}
{{- if $config.auth.enabled -}}
  {{- $args = append $args (printf "--user=%s:$(ETCD_PASSWORD)" $config.auth.user) -}}
{{- end -}}
{{- if $config.writeOut -}}
  {{- $args = append $args (printf "--write-out=%s" $config.writeOut) -}}
{{- end -}}
{{- $args = append $args "defrag" -}}
{{- if $config.clusterWide -}}
  {{- $args = append $args "--cluster" -}}
{{- end -}}
{{- toYaml $args -}}
{{- end -}}

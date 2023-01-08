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
Determine the etcd flag --endpoints
*/}}
{{- define "etcd-defrag.defrag.endpoints" -}}
{{- if .Values.defrag.config.endpoints -}}
  --endpoints={{ join "," .Values.defrag.config.endpoints | quote }}
{{- else -}}
  --endpoints="localhost:2379"
{{- end -}}
{{- end -}}

{{/*
Define the etcd flags --cacert, --cert and --key
*/}}
{{- define "etcd-defrag.defrag.certificates" -}}
  --cacert="/tmp/kubernetes/pki/etcd/ca.crt" --cert="/tmp/kubernetes/pki/etcd/server.crt" --key="/tmp/kubernetes/pki/etcd/server.key"
{{- end -}}

{{/*
Determine the etcd flag cluster
*/}}
{{- define "etcd-defrag.defrag.flag.clusterWide" -}}
  {{- if .Values.defrag.config.clusterWide -}}
    --cluster
  {{- end -}}
{{- end -}}

{{/*
Determine the etcd flag command-timeout
*/}}
{{- define "etcd-defrag.defrag.flag.commandTimeout" -}}
  {{- if .Values.defrag.config.commandTimeout -}}
    --command-timeout={{ .Values.defrag.config.commandTimeout | quote }}
  {{- end -}}
{{- end -}}

{{/*
Determine the etcd flag debug
*/}}
{{- define "etcd-defrag.defrag.flag.debug" -}}
  {{- if .Values.defrag.config.debug -}}
    --debug=true
  {{- end -}}
{{- end -}}

{{/*
Determine the etcd flag dial-timeout
*/}}
{{- define "etcd-defrag.defrag.flag.dialTimeout" -}}
  {{- if .Values.defrag.config.dialTimeout -}}
    --dial-timeout={{ .Values.defrag.config.dialTimeout | quote }}
  {{- end -}}
{{- end -}}

{{/*
Determine the etcd flag insecure-skip-tls-verify
*/}}
{{- define "etcd-defrag.defrag.flag.insecureSkipTlsVerify" -}}
  {{- if .Values.defrag.config.insecureSkipTlsVerify -}}
    --insecure-skip-tls-verify={{ .Values.defrag.config.insecureSkipTlsVerify | quote }}
  {{- end -}}
{{- end -}}

{{/*
Determine the etcd flag insecure-transport
*/}}
{{- define "etcd-defrag.defrag.flag.insecureTransport" -}}
  {{- if .Values.defrag.config.insecureTransport -}}
    --insecure-transport={{ .Values.defrag.config.insecureTransport | quote }}
  {{- end -}}
{{- end -}}

{{/*
Determine the etcd flag user
*/}}
{{- define "etcd-defrag.defrag.flag.user" -}}
  {{- if .Values.defrag.config.auth.enabled -}}
    --user="{{ .Values.defrag.config.auth.user }}:$ETCD_PASSWORD"
  {{- end -}}
{{- end -}}

{{/*
Determine the etcd flag write-out
*/}}
{{- define "etcd-defrag.defrag.flag.writeOut" -}}
  {{- if .Values.defrag.config.writeOut -}}
    --write-out={{ .Values.defrag.config.writeOut | quote }}
  {{- end -}}
{{- end -}}

{{/*
Determine the etcd flags
*/}}
{{- define "etcd-defrag.defrag.flags" -}}
  {{ include "etcd-defrag.defrag.endpoints" . }} {{ include "etcd-defrag.defrag.certificates" . }} {{ include "etcd-defrag.defrag.flag.commandTimeout" . }} {{ include "etcd-defrag.defrag.flag.debug" . }} {{ include "etcd-defrag.defrag.flag.dialTimeout" . }} {{ include "etcd-defrag.defrag.flag.insecureSkipTlsVerify" . }} {{ include "etcd-defrag.defrag.flag.insecureTransport" . }} {{ include "etcd-defrag.defrag.flag.user" . }} {{ include "etcd-defrag.defrag.flag.writeOut" . }}
{{- end -}}

{{/*
Create the command used to defrag etcd
*/}}
{{- define "etcd-defrag.defrag.command" -}}
ETCDCTL_API=3 etcdctl {{ include "etcd-defrag.defrag.flags" . }} defrag {{ include "etcd-defrag.defrag.flag.clusterWide" . }}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "typo3.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "typo3.fullname" -}}
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
{{- define "typo3.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "typo3.labels" -}}
helm.sh/chart: {{ include "typo3.chart" . }}
{{ include "typo3.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "typo3.selectorLabels" -}}
app.kubernetes.io/name: {{ include "typo3.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "typo3.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "typo3.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the Secret containing the password of the admin user
*/}}
{{- define "typo3.admin.secretName" -}}
  {{- if .Values.typo3.admin.existingSecret -}}
    {{- tpl .Values.typo3.admin.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-admin" (include "typo3.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Get the key of the password of the admin user inside its Secret
*/}}
{{- define "typo3.admin.passwordKey" -}}
  {{- if .Values.typo3.admin.existingSecret -}}
    {{- .Values.typo3.admin.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Get the name of the persistent volume claim for the fileadmin folder
*/}}
{{- define "typo3.pvcName.fileadmin" -}}
  {{- if .Values.persistence.fileadmin.existingClaim -}}
    {{- printf "%s" (tpl .Values.persistence.fileadmin.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s" (include "typo3.fullname" .) -}}-fileadmin
  {{- end -}}
{{- end -}}

{{/*
Get the name of the persistent volume claim for the typo3conf folder
*/}}
{{- define "typo3.pvcName.typo3conf" -}}
  {{- if .Values.persistence.typo3conf.existingClaim -}}
    {{- printf "%s" (tpl .Values.persistence.typo3conf.existingClaim $) -}}
  {{- else -}}
      {{- printf "%s" (include "typo3.fullname" .) -}}-typo3conf
  {{- end -}}
{{- end -}}

{{/*
Volume mounts of the TYPO3 containers. The legacy image serves TYPO3 from /var/www/html/public.
*/}}
{{- define "typo3.volumeMounts" -}}
- name: public
  mountPath: /var/www/html/public
{{- if .Values.persistence.fileadmin.enabled }}
- name: fileadmin
  mountPath: /var/www/html/public/fileadmin
{{- end }}
{{- if .Values.persistence.typo3conf.enabled }}
- name: typo3conf
  mountPath: /var/www/html/public/typo3conf
{{- end }}
{{- end -}}

{{/*
Environment variables with the database connection of the TYPO3 containers
*/}}
{{- define "typo3.databaseEnv" -}}
- name: TYPO3_DB_DRIVER
  value: pdoMysql
- name: TYPO3_DB_HOST
  value: {{ include "typo3.database.hostname" . | quote }}
- name: TYPO3_DB_PORT
  value: {{ include "typo3.database.port" . | quote }}
- name: TYPO3_DBNAME
  value: {{ include "typo3.database.database" . | quote }}
- name: TYPO3_DB_USERNAME
  value: {{ include "typo3.database.username" . | quote }}
- name: TYPO3_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "typo3.database.secretName" . | quote }}
      key: {{ include "typo3.database.passwordKey" . | quote }}
{{- end -}}

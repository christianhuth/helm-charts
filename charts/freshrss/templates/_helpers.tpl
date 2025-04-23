{{/*
Expand the name of the chart.
*/}}
{{- define "freshrss.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "freshrss.fullname" -}}
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
{{- define "freshrss.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "freshrss.labels" -}}
helm.sh/chart: {{ include "freshrss.chart" . }}
{{ include "freshrss.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "freshrss.selectorLabels" -}}
app.kubernetes.io/name: {{ include "freshrss.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "freshrss.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create }}
    {{- default (include "freshrss.fullname" .) .Values.serviceAccount.name }}
  {{- else }}
    {{- default "default" .Values.serviceAccount.name }}
  {{- end }}
{{- end }}

{{/*
Define the type of image to use
*/}}
{{- define "freshrss.imageType" -}}
  {{- $imageType := "alpine" -}}
  {{- if and (.Values.image.type) (eq .Values.image.type "debian") }}
    {{- $imageType = .Values.image.type }}
  {{- end }}
  {{- $imageType -}}
{{- end }}

{{/*
Define the image to use
*/}}
{{- define "freshrss.image" -}}
  {{- $imageType := (include "freshrss.imageType" .) -}}
  {{- $imageRegistry := .Values.image.registry -}}
  {{- $imageRepository := .Values.image.repository -}}
  {{- $imageTag := (.Values.image.tag | default .Chart.AppVersion ) -}}
  {{- if (eq $imageType "alpine") }}
    {{- $imageTag = (printf "%s-%s" $imageTag "alpine") }}
  {{- end }}
  {{- $image := (printf "%s/%s:%s" $imageRegistry $imageRepository $imageTag) -}}
  {{- $image }}
{{- end }}

{{/*
Define the base url
*/}}
{{- define "freshrss.baseUrl" -}}
  {{- $baseUrl := .Values.freshrss.baseUrl -}}
  {{- if and .Values.ingress.enabled .Values.ingress.hosts -}}
    {{- with index .Values.ingress.hosts 0 -}}
      {{- $host := .host }}
      {{- $scheme := "http" }}
      {{- if $.Values.ingress.tls }}
        {{- range $tls := $.Values.ingress.tls -}}
          {{- if $tls.hosts }}
            {{- if has $host $tls.hosts }}
              {{- $scheme = "https" }}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- $baseUrl = (printf "%s://%s" $scheme .host) }}
    {{- end -}}
  {{- end -}}
  {{- $baseUrl -}}
{{- end }}

{{/*
Define the parameters used to create the admin user on initialization
*/}}
{{- define "freshrss.initialization.adminParameters" -}}
  {{- $adminParameters := "" -}}
  {{- if .Values.freshrss.initialization.admin.apiPassword }}
    {{- $adminApiPassword := .Values.freshrss.initialization.admin.apiPassword -}}
    {{- $adminParameters = (printf "%s --api-password %s" $adminParameters $adminApiPassword) -}}
  {{- end }}
  {{- if .Values.freshrss.initialization.admin.email }}
    {{- $adminEmail := .Values.freshrss.initialization.admin.email -}}
    {{- $adminParameters = (printf "%s --email %s" $adminParameters $adminEmail) -}}
  {{- end }}
  {{- if .Values.freshrss.initialization.language }}
    {{- $language := .Values.freshrss.initialization.language -}}
    {{- $adminParameters = (printf "%s --language %s" $adminParameters $language) -}}
  {{- end }}
  {{- if .Values.freshrss.initialization.admin.password }}
    {{- $adminPassword := .Values.freshrss.initialization.admin.password -}}
    {{- $adminParameters = (printf "%s --password %s" $adminParameters $adminPassword) -}}
  {{- end }}
  {{- if .Values.freshrss.initialization.admin.username }}
    {{- $adminUsername := .Values.freshrss.initialization.admin.username -}}
    {{- $adminParameters = (printf "%s --user %s" $adminParameters $adminUsername) -}}
  {{- end }}
  {{- $adminParameters = trim $adminParameters -}}
  {{- $adminParameters -}}
{{- end }}

{{/*
Define the parameters used to install FreshRSS on initialization
*/}}
{{- define "freshrss.initialization.installParameters" -}}
  {{- $installParameters := "" -}}
  {{- if .Values.freshrss.initialization.apiEnabled }}
    {{- $installParameters = (printf "%s --api-enabled" $installParameters) -}}
  {{- end }}
  {{- if .Values.freshrss.initialization.baseUrl }}
    {{- $baseUrl := .Values.freshrss.initialization.baseUrl -}}
    {{- $installParameters = (printf "%s --base-url %s" $installParameters $baseUrl) -}}
  {{- end }}
  {{- if (eq .Values.freshrss.database.type "postgresql") -}}
    {{- $dbBase := (include "freshrss.postgresql.database" .) -}}
    {{- if $dbBase }}
      {{- $installParameters = (printf "%s --db-base %s" $installParameters $dbBase) -}}
    {{- end }}
    {{- $dbHost := (include "freshrss.postgresql.hostname" .) -}}
    {{- if $dbHost }}
      {{- $installParameters = (printf "%s --db-host %s" $installParameters $dbHost) -}}
    {{- end }}
    {{- $dbPassword := "" }}
    {{- if and .Values.postgresql.enabled .Values.postgresql.auth.password }}
      {{- $dbPassword = .Values.postgresql.auth.password }}
    {{- else if .Values.externalPostgresql.auth.password -}}
      {{- $dbPassword = .Values.externalPostgresql.auth.password }}
    {{- end -}}
    {{- if $dbPassword }}
      {{- $installParameters = (printf "%s --db-password %s" $installParameters $dbPassword) -}}
    {{- end }}
    {{- $installParameters = (printf "%s --db-type %s" $installParameters "pgsql") -}}
    {{- $dbUser := (include "freshrss.postgresql.username" .) -}}
    {{- if $dbUser }}
      {{- $installParameters = (printf "%s --db-user %s" $installParameters $dbUser) -}}
    {{- end }}
  {{- end }}
  {{- if .Values.freshrss.initialization.admin.username }}
    {{- $adminUsername := .Values.freshrss.initialization.admin.username -}}
    {{- $installParameters = (printf "%s --default-user %s" $installParameters $adminUsername) -}}
  {{- end }}
  {{- if .Values.freshrss.initialization.language }}
    {{- $language := .Values.freshrss.initialization.language -}}
    {{- $installParameters = (printf "%s --language %s" $installParameters $language) -}}
  {{- end }}
  {{- $installParameters = trim $installParameters -}}
  {{- $installParameters -}}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "node-access.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "node-access.fullname" -}}
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
{{- define "node-access.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "node-access.labels" -}}
helm.sh/chart: {{ include "node-access.chart" . }}
{{ include "node-access.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "node-access.selectorLabels" -}}
app.kubernetes.io/name: {{ include "node-access.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "node-access.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "node-access.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the pod specification
*/}}
{{- define "node-access.podSpec" -}}
hostNetwork: true
hostPID: true
hostIPC: true
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 4 }}
{{- end }}
serviceAccountName: {{ include "node-access.serviceAccountName" . }}
{{- with .Values.podSecurityContext }}
securityContext:
  {{- toYaml . | nindent 4 }}
{{- end }}
containers:
  - name: {{ .Chart.Name }}
    image: "{{ .Values.image.registry }}/{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    command:
      - tail
      - "-f"
      - /dev/null
    {{- with .Values.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    volumeMounts:
      - name: rootfs
        mountPath: "/host"
      {{- range .Values.nodeAccess.hostPaths }}
      {{- if and (.name) (.host) (.container) }}
      - name: {{ .name | quote }}
        mountPath: {{ .container | quote }}
      {{- end }}
      {{- end }}
{{- with .Values.nodeAccess.nodePlacement.nodeName }}
nodeName: {{ . | quote }}
{{- end }}
{{- with .Values.nodeAccess.nodePlacement.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- with .Values.nodeAccess.nodePlacement.affinity }}
affinity:
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- with .Values.nodeAccess.nodePlacement.tolerations }}
tolerations:
  {{- toYaml . | nindent 4 }}
{{- end }}
volumes:
  - name: rootfs
    hostPath:
      path: "/"
  {{- range .Values.nodeAccess.hostPaths }}
  {{- if and (.name) (.host) (.container) }}
  - name: {{ .name | quote }}
    hostPath:
      path: {{ .host | quote }}
  {{- end }}
  {{- end }}
{{- end }}

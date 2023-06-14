{{/*
Expand the name of the chart.
*/}}
{{- define "tenant-namespace.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tenant-namespace.fullname" -}}
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
{{- define "tenant-namespace.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common Helm and Kubernetes labels
*/}}
{{- define "tenant-namespace.labels" -}}
helm.sh/chart: {{ include "tenant-namespace.chart" . }}
app.kubernetes.io/name: {{ include "tenant-namespace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the Namespace to create and use
*/}}
{{- define "tenant-namespace.namespace.name" -}}
{{- if .Values.namespace.name }}
{{- .Values.namespace.name }}
{{- else }}
{{- include "tenant-namespace.fullname" . }}
{{- end }}
{{- end }}

{{/*
Additional annotations for the Namespace
*/}}
{{- define "tenant-namespace.namespace.annotations" -}}
{{- if .Values.namespace.annotations.additionalAnnotations }}
{{- toYaml .Values.namespace.annotations.additionalAnnotations }}
{{- end }}
{{- if .Values.namespace.annotations.openShift.description }}
openshift.io/description: {{ .Values.namespace.annotations.openShift.description | quote }}
{{- end }}
{{- if .Values.namespace.annotations.openShift.displayName }}
openshift.io/display-name: {{ .Values.namespace.annotations.openShift.displayName | quote }}
{{- end }}
{{- if .Values.namespace.annotations.openShift.requester }}
openshift.io/requester: {{ .Values.namespace.annotations.openShift.requester | quote }}
{{- end }}
{{- if .Values.namespace.annotations.scheduler.defaultTolerations }}
scheduler.alpha.kubernetes.io/defaultTolerations: {{ toJson  .Values.namespace.annotations.scheduler.defaultTolerations | quote }}
{{- end }}
{{- if .Values.namespace.annotations.scheduler.nodeScheduler }}
scheduler.alpha.kubernetes.io/node-selector: {{ .Values.namespace.annotations.scheduler.nodeScheduler | quote }}
{{- end }}
{{- if .Values.namespace.annotations.scheduler.tolerationsWhitelist }}
scheduler.alpha.kubernetes.io/tolerationsWhitelist: {{ toJson  .Values.namespace.annotations.scheduler.tolerationsWhitelist | quote }}
{{- end }}
{{- end }}

{{/*
Additional labels for the Namespace
*/}}
{{- define "tenant-namespace.namespace.labels" -}}
{{ include "tenant-namespace.labels" . }}
{{- if .Values.namespace.labels.additionalLabels }}
{{ toYaml .Values.namespace.labels.additionalLabels }}
{{- end }}
{{- if .Values.namespace.labels.podSecurityAdmission.audit.standard }}
pod-security.kubernetes.io/audit: {{ .Values.namespace.labels.podSecurityAdmission.audit.standard | quote }}
{{- if .Values.namespace.labels.podSecurityAdmission.audit.version }}
pod-security.kubernetes.io/audit-version: {{ .Values.namespace.labels.podSecurityAdmission.audit.version | quote }}
{{- end }}
{{- end }}
{{- if .Values.namespace.labels.podSecurityAdmission.enforce.standard }}
pod-security.kubernetes.io/enforce: {{ .Values.namespace.labels.podSecurityAdmission.enforce.standard | quote }}
{{- if .Values.namespace.labels.podSecurityAdmission.enforce.version }}
pod-security.kubernetes.io/enforce-version: {{ .Values.namespace.labels.podSecurityAdmission.enforce.version | quote }}
{{- end }}
{{- end }}
{{- if .Values.namespace.labels.podSecurityAdmission.warning.standard }}
pod-security.kubernetes.io/warn: {{ .Values.namespace.labels.podSecurityAdmission.warning.standard | quote }}
{{- if .Values.namespace.labels.podSecurityAdmission.warning.version }}
pod-security.kubernetes.io/warn-version: {{ .Values.namespace.labels.podSecurityAdmission.warning.version | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create the name of the LimitRange to create and use
*/}}
{{- define "tenant-namespace.limitRange.name" -}}
{{- if .Values.limitRange.name }}
{{- .Values.limitRange.name }}
{{- else }}
{{- include "tenant-namespace.fullname" . }}
{{- end }}
{{- end }}

{{/*
Additional annotations for the LimitRange
*/}}
{{- define "tenant-namespace.limitRange.annotations" -}}
{{- if .Values.limitRange.additionalAnnotations }}
{{- toYaml .Values.limitRange.additionalAnnotations }}
{{- end }}
{{- end }}

{{/*
Additional labels for the LimitRange
*/}}
{{- define "tenant-namespace.limitRange.labels" -}}
{{ include "tenant-namespace.labels" . }}
{{- if .Values.limitRange.additionalLabels }}
{{ toYaml .Values.limitRange.additionalLabels }}
{{- end }}
{{- end }}

{{/*
Additional annotations for the ResourceQuotas
*/}}
{{- define "tenant-namespace.resourceQuotas.annotations" -}}
{{- if .Values.resourceQuotas.additionalAnnotations }}
{{- toYaml .Values.resourceQuotas.additionalAnnotations }}
{{- end }}
{{- end }}

{{/*
Additional labels for the ResourceQuotas
*/}}
{{- define "tenant-namespace.resourceQuotas.labels" -}}
{{ include "tenant-namespace.labels" . }}
{{- if .Values.resourceQuotas.additionalLabels }}
{{ toYaml .Values.resourceQuotas.additionalLabels }}
{{- end }}
{{- end }}

{{/*
Additional annotations for the NetworkPolicies
*/}}
{{- define "tenant-namespace.networkPolicy.annotations" -}}
{{- if .Values.networkPolicies.additionalAnnotations }}
{{- toYaml .Values.networkPolicies.additionalAnnotations }}
{{- end }}
{{- end }}

{{/*
Additional labels for the NetworkPolicies
*/}}
{{- define "tenant-namespace.networkPolicy.labels" -}}
{{ include "tenant-namespace.labels" . }}
{{- if .Values.networkPolicies.additionalLabels }}
{{ toYaml .Values.networkPolicies.additionalLabels }}
{{- end }}
{{- end }}

{{/*
Create the name of the NetworkPolicy to deny all outgoing traffic
*/}}
{{- define "tenant-namespace.networkPolicy.egress.deny.all.name" }}
{{- printf "%s-%s" ((include "tenant-namespace.fullname" .) | trunc 47 | trimSuffix "-") "egress-deny-all" }}
{{- end }}

{{/*
Create the name of the NetworkPolicy to allow outgoing traffic to the Kubernetes DNS
*/}}
{{- define "tenant-namespace.networkPolicy.egress.allow.dns.name" }}
{{- printf "%s-%s" ((include "tenant-namespace.fullname" .) | trunc 47 | trimSuffix "-") "egress-allow-dns" }}
{{- end }}

{{/*
Create the name of the NetworkPolicy to deny all incoming traffic
*/}}
{{- define "tenant-namespace.networkPolicy.ingress.deny.all.name" }}
{{- printf "%s-%s" ((include "tenant-namespace.fullname" .) | trunc 46 | trimSuffix "-") "ingress-deny-all" }}
{{- end }}

{{/*
Create the name of the NetworkPolicy to allow incoming traffic from the OpenShift Monitoring
*/}}
{{- define "tenant-namespace.networkPolicy.ingress.allow.openshift.monitoring.name" }}
{{- printf "%s-%s" ((include "tenant-namespace.fullname" .) | trunc 28 | trimSuffix "-") "ingress-allow-openshift-monitoring" }}
{{- end }}

{{/*
Create the name of the NetworkPolicy to allow incoming traffic from the OpenShift Ingress Controller
*/}}
{{- define "tenant-namespace.networkPolicy.ingress.allow.openshift.ingressController.name" }}
{{- printf "%s-%s" ((include "tenant-namespace.fullname" .) | trunc 31 | trimSuffix "-") "ingress-allow-openshift-ingress" }}
{{- end }}

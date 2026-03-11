{{/*
Expand the name of the chart.
*/}}
{{- define "kubevirt-cloud-controller-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubevirt-cloud-controller-manager.fullname" -}}
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
{{- define "kubevirt-cloud-controller-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kubevirt-cloud-controller-manager.labels" -}}
helm.sh/chart: {{ include "kubevirt-cloud-controller-manager.chart" . }}
{{ include "kubevirt-cloud-controller-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.kccm.additionalLabels.enabled }}
capk.cluster.x-k8s.io/template-kind: extra-resource
cluster.x-k8s.io/cluster-name: {{ include "kubevirt-cloud-controller-manager.capi.cluster.name" . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kubevirt-cloud-controller-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubevirt-cloud-controller-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kubevirt-cloud-controller-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kubevirt-cloud-controller-manager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the capi cluster
*/}}
{{- define "kubevirt-cloud-controller-manager.capi.cluster.name" -}}
  {{- .Values.kccm.cluster.name | default (include "kubevirt-cloud-controller-manager.fullname" .) }}
{{- end }}

{{/*
Create the name of the capi cluster
*/}}
{{- define "kubevirt-cloud-controller-manager.capi.cluster.namespace" -}}
  {{- .Values.kccm.cluster.namespace | default .Release.Namespace }}
{{- end }}

{{/*
Create the name of the secret containing the kubeconfig
*/}}
{{- define "kubevirt-cloud-controller-manager.capi.cluster.kubeconfig.secretName" -}}
  {{- $clusterName := (include "kubevirt-cloud-controller-manager.capi.cluster.name" .) }}
  {{- printf "%s-%s" $clusterName "kubeconfig " -}}
{{- end }}

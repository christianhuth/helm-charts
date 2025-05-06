{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "squest.celery.worker.fullname" -}}
{{- $baseFullname := (include "squest.fullname" .) -}}
{{- printf "%s-%s" $baseFullname "celery-worker" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for celery-worker
*/}}
{{- define "squest.celery.worker.labels" -}}
{{ include "squest.common.labels" . }}
{{ include "squest.celery.worker.selectorLabels" . }}
{{- end }}

{{/*
Selector labels for celery-worker
*/}}
{{- define "squest.celery.worker.selectorLabels" -}}
app.kubernetes.io/component: celery-worker
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "squest.celery.worker.serviceAccountName" -}}
{{- if .Values.celery.worker.serviceAccount.create }}
{{- default (include "squest.celery.worker.fullname" .) .Values.celery.worker.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.celery.worker.serviceAccount.name }}
{{- end }}
{{- end }}

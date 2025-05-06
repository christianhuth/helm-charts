{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "squest.celery.beat.fullname" -}}
{{- $baseFullname := (include "squest.fullname" .) -}}
{{- printf "%s-%s" $baseFullname "celery-beat" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for celery-beat
*/}}
{{- define "squest.celery.beat.labels" -}}
{{ include "squest.common.labels" . }}
{{ include "squest.celery.beat.selectorLabels" . }}
{{- end }}

{{/*
Selector labels for celery-beat
*/}}
{{- define "squest.celery.beat.selectorLabels" -}}
app.kubernetes.io/component: celery-beat
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "squest.celery.beat.serviceAccountName" -}}
{{- if .Values.celery.beat.serviceAccount.create }}
{{- default (include "squest.celery.beat.fullname" .) .Values.celery.beat.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.celery.beat.serviceAccount.name }}
{{- end }}
{{- end }}

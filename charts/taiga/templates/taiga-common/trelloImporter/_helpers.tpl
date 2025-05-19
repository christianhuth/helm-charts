{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "taiga.common.trelloImporter.secretName" -}}
    {{- $fullname := (include "taiga.fullname" .) -}}
    {{- printf "%s-%s" $fullname "trello-importer" | trunc 63 | trimSuffix "-" }}
{{- end }}

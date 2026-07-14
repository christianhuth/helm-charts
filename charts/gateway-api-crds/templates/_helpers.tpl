{{/*
Renders the helm.sh/resource-policy annotation line when resourcePolicy.keep is enabled.
Included right after "annotations:" in every CRD template.
*/}}
{{- define "gateway-api-crds.resourcePolicyAnnotation" -}}
{{- if .Values.resourcePolicy.keep }}
    helm.sh/resource-policy: keep
{{- end }}
{{- end -}}

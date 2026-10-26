{{/*
Get the name of the secret containing the sync master key
*/}}
{{- define "syncstorage-rs.masterKey.secretName" -}}
{{- $secretName := "" -}}
{{- if .Values.syncstorage.masterKey.existingSecret -}}
    {{- $secretName = .Values.syncstorage.masterKey.existingSecret -}}
{{- else -}}
    {{- $secretName = printf "%s" (include "syncstorage-rs.fullname" .) -}}
{{- end -}}
{{- $secretName -}}
{{- end -}}

{{/*
Get the key of the secret containing the sync master key
*/}}
{{- define "syncstorage-rs.masterKey.secretKey" -}}
{{- $secretKey := "master-key" -}}
{{- $secretKey -}}
{{- end -}}

{{/*
Fail if no sync master key is configured, as syncstorage-rs would sign its tokens with an empty secret otherwise
*/}}
{{- define "syncstorage-rs.masterKey.validate" -}}
{{- if not (or .Values.syncstorage.masterKey.existingSecret .Values.syncstorage.masterKey.value) -}}
    {{- fail "syncstorage.masterKey.value or syncstorage.masterKey.existingSecret is required" -}}
{{- end -}}
{{- end -}}

{{/*
Get the public URL of the sync server, registered as storage node in the Tokenserver database.
Defaults to the first host of the Ingress (https if it is covered by TLS) or of the HTTPRoute (https).
Returns an empty string if none of them is configured.
*/}}
{{- define "syncstorage-rs.publicUrl" -}}
{{- $url := "" -}}
{{- if .Values.syncstorage.config.publicUrl -}}
    {{- $url = .Values.syncstorage.config.publicUrl | trimSuffix "/" -}}
{{- else if and .Values.ingress.enabled .Values.ingress.hosts -}}
    {{- $host := (first .Values.ingress.hosts).host -}}
    {{- $scheme := "http" -}}
    {{- range .Values.ingress.tls -}}
        {{- if has $host .hosts -}}
            {{- $scheme = "https" -}}
        {{- end -}}
    {{- end -}}
    {{- $url = printf "%s://%s" $scheme $host -}}
{{- else if and .Values.route.main.enabled .Values.route.main.hostnames -}}
    {{- $url = printf "https://%s" (first .Values.route.main.hostnames) -}}
{{- end -}}
{{- if and $url (not (regexMatch "^https?://[^/]+$" $url)) -}}
    {{- fail (printf "syncstorage.config.publicUrl must consist of the scheme (http or https) and the host only, e.g. https://sync.example.com, not %s" $url) -}}
{{- end -}}
{{- $url -}}
{{- end -}}

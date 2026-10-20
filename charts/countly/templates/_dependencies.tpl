{{/*
Interface to the MongoDB used by Countly: either the bundled replica set of the chart mongodb-community
(see its named templates mongodb-community.*) or the external server configured with externalMongodb.*
*/}}

{{/*
User of the bundled replica set Countly connects with: the first user
*/}}
{{- define "countly.mongodb.bundledUser" -}}
{{- $users := .Values.mongodb.mongodb.users | default list }}
{{- if not $users }}
{{- fail "mongodb.mongodb.users must contain the user Countly connects with" }}
{{- end }}
{{- toYaml (first $users) }}
{{- end -}}

{{- define "countly.mongodb.hostname" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- include "mongodb-community.hostname" .Subcharts.mongodb -}}
  {{- else -}}
    {{- required "externalMongodb.hostname is required if mongodb.enabled is false" (tpl .Values.externalMongodb.hostname $) -}}
  {{- end -}}
{{- end -}}

{{- define "countly.mongodb.port" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- include "mongodb-community.port" .Subcharts.mongodb -}}
  {{- else -}}
    {{- .Values.externalMongodb.port | default 27017 | toString -}}
  {{- end -}}
{{- end -}}

{{- define "countly.mongodb.replicaSet" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- include "mongodb-community.replicaSetName" .Subcharts.mongodb -}}
  {{- else -}}
    {{- tpl .Values.externalMongodb.replicaSet $ -}}
  {{- end -}}
{{- end -}}

{{- define "countly.mongodb.database" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- "countly" -}}
  {{- else -}}
    {{- tpl .Values.externalMongodb.database $ -}}
  {{- end -}}
{{- end -}}

{{- define "countly.mongodb.username" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- (include "countly.mongodb.bundledUser" . | fromYaml).name -}}
  {{- else -}}
    {{- tpl .Values.externalMongodb.username $ -}}
  {{- end -}}
{{- end -}}

{{- define "countly.mongodb.secretName" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- include "mongodb-community.userPasswordSecretName" (dict "context" .Subcharts.mongodb "user" (include "countly.mongodb.username" .)) -}}
  {{- else if .Values.externalMongodb.existingSecret -}}
    {{- tpl .Values.externalMongodb.existingSecret $ -}}
  {{- else -}}
    {{- printf "%s-mongodb" (include "countly.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "countly.mongodb.passwordKey" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- include "mongodb-community.userPasswordSecretKey" (dict "context" .Subcharts.mongodb "user" (include "countly.mongodb.username" .)) -}}
  {{- else if .Values.externalMongodb.existingSecret -}}
    {{- .Values.externalMongodb.existingSecretPasswordKey | default "password" -}}
  {{- else -}}
    {{- "password" -}}
  {{- end -}}
{{- end -}}

{{/*
Options of the MongoDB driver as JSON
*/}}
{{- define "countly.mongodb.options" -}}
  {{- if .Values.mongodb.enabled -}}
    {{- dict "authSource" ((include "countly.mongodb.bundledUser" . | fromYaml).db | default "admin") | toJson -}}
  {{- else -}}
    {{- .Values.externalMongodb.options | default dict | toJson -}}
  {{- end -}}
{{- end -}}

{{/*
Environment variables configuring the MongoDB connection of the api and frontend. Countly builds the connection
string from them and URL-encodes the credentials. The replica set is given as a single seed (replSetServers), so
that the driver and the command line tools used by Countly find the primary themselves.
*/}}
{{- define "countly.mongodb.env" -}}
{{- $host := printf "%s:%s" (include "countly.mongodb.hostname" .) (include "countly.mongodb.port" .) -}}
{{- $replicaSet := include "countly.mongodb.replicaSet" . -}}
{{- if $replicaSet -}}
- name: COUNTLY_CONFIG__MONGODB_REPLSETSERVERS
  value: {{ list $host | toJson | quote }}
- name: COUNTLY_CONFIG__MONGODB_REPLICANAME
  value: {{ $replicaSet | quote }}
{{- else -}}
- name: COUNTLY_CONFIG__MONGODB_HOST
  value: {{ include "countly.mongodb.hostname" . | quote }}
- name: COUNTLY_CONFIG__MONGODB_PORT
  value: {{ include "countly.mongodb.port" . | quote }}
{{- end }}
- name: COUNTLY_CONFIG__MONGODB_DB
  value: {{ include "countly.mongodb.database" . | quote }}
{{- with include "countly.mongodb.username" . }}
- name: COUNTLY_CONFIG__MONGODB_USERNAME
  value: {{ . | quote }}
- name: COUNTLY_CONFIG__MONGODB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "countly.mongodb.secretName" $ | quote }}
      key: {{ include "countly.mongodb.passwordKey" $ | quote }}
{{- end }}
- name: COUNTLY_CONFIG__MONGODB_DBOPTIONS
  value: {{ include "countly.mongodb.options" . | quote }}
{{- end -}}

{{/*
Init container waiting until the bundled replica set has a primary and accepts the credentials of Countly, so that
Countly does not restart while the operator sets up the replica set. Uses the image of the api or frontend.
Usage: include "countly.mongodb.waitInitContainer" (dict "context" $ "component" .Values.api)
*/}}
{{- define "countly.mongodb.waitInitContainer" -}}
- name: wait-for-mongodb
  image: "{{ .component.image.registry }}/{{ .component.image.repository }}:{{ .component.image.tag | default .context.Chart.AppVersion }}"
  imagePullPolicy: {{ .component.image.pullPolicy }}
  {{- with .component.securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  command:
    - node
    - -e
    - |
      const { MongoClient } = require('mongodb');
      const env = process.env;
      const credentials = encodeURIComponent(env.COUNTLY_CONFIG__MONGODB_USERNAME) + ':' + encodeURIComponent(env.COUNTLY_CONFIG__MONGODB_PASSWORD);
      const url = 'mongodb://' + credentials + '@' + JSON.parse(env.COUNTLY_CONFIG__MONGODB_REPLSETSERVERS).join(',') + '/' + env.COUNTLY_CONFIG__MONGODB_DB;
      const options = Object.assign({ replicaSet: env.COUNTLY_CONFIG__MONGODB_REPLICANAME, serverSelectionTimeoutMS: 5000 }, JSON.parse(env.COUNTLY_CONFIG__MONGODB_DBOPTIONS));
      (async () => {
        for (;;) {
          const client = new MongoClient(url, options);
          try {
            await client.connect();
            await client.db().command({ ping: 1 });
            console.log('MongoDB is ready');
            process.exit(0);
          } catch (err) {
            console.log('Waiting for MongoDB: ' + err.message);
            await client.close().catch(() => {});
            await new Promise((resolve) => setTimeout(resolve, 5000));
          }
        }
      })();
  env:
    {{- include "countly.mongodb.env" .context | nindent 4 }}
{{- end -}}

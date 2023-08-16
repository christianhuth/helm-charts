{{- define "proxysql.pod" -}}
metadata:
  annotations:
    checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
  {{- with .Values.podAnnotations }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "proxysql.selectorLabels" . | nindent 4 }}
spec:
  {{- with .Values.imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  serviceAccountName: {{ include "proxysql.serviceAccountName" . }}
  securityContext:
    {{- toYaml .Values.podSecurityContext | nindent 4 }}
  initContainers:
    - name: tcp-keepalive
      securityContext:
        runAsUser: 0
        runAsGroup: 0
        privileged: true
      image: alpine:3.18
      command: [sh, -c]
      args:
        - |
          echo "10" > /proc/sys/net/ipv4/tcp_keepalive_intvl
          echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
          echo "10" > /proc/sys/net/ipv4/tcp_keepalive_time
      resources:
        {{- toYaml .Values.resources | nindent 12 }}
  containers:
    - name: {{ .Chart.Name }}
      securityContext:
        {{- toYaml .Values.securityContext | nindent 8 }}
      image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
      imagePullPolicy: {{ .Values.image.pullPolicy }}
      command:
        - proxysql
        - "-f"
        - "--idle-threads"
        - "-D"
        - "/var/lib/proxysql"
        - "--reload"
      ports:
        - name: mysql
          containerPort: {{ .Values.proxysql.mysql.port }}
          protocol: TCP
        - name: proxysql
          containerPort: {{ .Values.proxysql.port }}
          protocol: TCP
        {{- if .Values.proxysql.web.enabled }}
        - name: web
          containerPort: {{ .Values.proxysql.web.port }}
          protocol: TCP
        {{- end }}
        {{- if .Values.metrics.enabled }}
        - name: metrics
          containerPort: 6070
          protocol: TCP
        {{- end }}
      livenessProbe:
        exec:
          command:
            - /usr/local/bin/healthcheck.sh
        initialDelaySeconds: 10
        periodSeconds: 20
        timeoutSeconds: 5
      readinessProbe:
        exec:
          command:
            - /usr/local/bin/healthcheck.sh
        initialDelaySeconds: 10
        periodSeconds: 20
        timeoutSeconds: 5
      volumeMounts:
        - name: proxysql-config
          mountPath: /etc/proxysql.cnf
          subPath: proxysql.cnf
          readOnly: true
        - name: healthcheck
          mountPath: /usr/local/bin/healthcheck.sh
          subPath: healthcheck.sh
        - name: status
          mountPath: /usr/local/bin/status.sh
          subPath: status.sh
      {{- if and .Values.proxysql.cluster.enabled .Values.proxysql.cluster.claim.enabled }}
        - name: {{ include "proxysql.fullname" . }}-pv
          mountPath: /var/lib/proxysql
      {{- end }}
      resources:
        {{- toYaml .Values.resources | nindent 8 }}
  volumes:
    - name: proxysql-config
      configMap:
        name: {{ .Values.proxysql.configmap | default (include "proxysql.fullname" .) }}
    - name: healthcheck
      configMap:
        name: {{ .Values.proxysql.configmap | default (include "proxysql.fullname" .) }}
        items:
          - key: healthcheck.sh
            path: healthcheck.sh
            mode: 0777
    - name: status
      configMap:
        name: {{ .Values.proxysql.configmap | default (include "proxysql.fullname" .) }}
        items:
          - key: status.sh
            path: status.sh
            mode: 0777
  {{- with .Values.nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.affinity }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.tolerations }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}

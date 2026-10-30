{{/*
Expand the name of the chart.
*/}}
{{- define "cloudcart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to all resources
*/}}
{{- define "cloudcart.labels" -}}
helm.sh/chart: {{ include "cloudcart.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: cloudcart
{{- if .Values.global.environment }}
env: {{ .Values.global.environment }}
{{- end }}
{{- end }}

{{/*
Selector labels for pods matching services
Usage: {{ include "cloudcart.selectorLabels" "cart" }}
*/}}
{{- define "cloudcart.selectorLabels" -}}
app.kubernetes.io/name: {{ . }}
app.kubernetes.io/instance: cloudcart-{{ . }}
{{- end }}

{{/*
Grafana Alloy annotation-autodiscovery: scrape /metrics on backend pods
*/}}
{{- define "cloudcart.metricsAnnotations" -}}
k8s.grafana.com/scrape: "true"
k8s.grafana.com/metrics.path: "/metrics"
k8s.grafana.com/metrics.portNumber: "8000"
{{- end }}

{{/*
Spread a service's replicas across nodes and zones (soft: the scheduler tries, never blocks).
Usage: {{ include "cloudcart.topologySpread" "cart" | nindent 8 }}
*/}}
{{- define "cloudcart.topologySpread" -}}
- maxSkew: 1
  topologyKey: kubernetes.io/hostname
  whenUnsatisfiable: ScheduleAnyway
  labelSelector:
    matchLabels:
      app.kubernetes.io/name: {{ . }}
- maxSkew: 1
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: ScheduleAnyway
  labelSelector:
    matchLabels:
      app.kubernetes.io/name: {{ . }}
{{- end }}

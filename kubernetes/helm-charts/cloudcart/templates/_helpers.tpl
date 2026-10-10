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
{{/*
Expand the name of the chart.
*/}}
{{- define "node-group.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "node-group.fullname" -}}
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
{{- define "node-group.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "node-group.labels" -}}
helm.sh/chart: {{ include "node-group.chart" . }}
{{ include "node-group.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "node-group.selectorLabels" -}}
app.kubernetes.io/name: {{ include "node-group.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "node-group.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "node-group.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "yandex.machine-class.spec" -}}

{{- with .Values.bootDisk  }}
bootDiskSpec:
  autoDelete: {{ .autoDelete | default true }}
  imageID: {{ .imageID | default "fd8ingbofbh3j5h7i8ll" }}
  size: {{ mul .size 1073741824 | default "21474836480" }}
  typeID: {{ .typeID | default "network-hdd" }}
{{- end }}

{{- with .Values.metadata.cloudLabels }}
labels:
  {{- toYaml . | nindent 2 }}
{{- end }}

networkInterfaceSpecs:
{{- with .Values.networkInterfaces  }}
- assignPublicIPAddress: {{ .nat | default true }}
  subnetID: {{ .subnetID }}
networkType: {{ .networkType | default "STANDARD" }}
regionID: {{ .regionID | default "ru-central1" }}
zoneID: {{ .zoneID }}
{{- end }}

platformID: standard-v3

{{- with .Values.resources  }}
resourcesSpec:
  coreFraction: {{ .coreFraction | default 20 }}
  cores: {{ .cores | default 4 }}
  memory: {{ mul .memory 1073741824 | default "8589934592" }}
{{- end }}

schedulingPolicy: {}

secretRef:
  name: machine-class.{{ .Release.Name }}
  namespace: {{ .Values.machineContoller.namespace | default "fraima-ccm" }}

{{- end }}

{{- define "yandex.machine-class.name" -}}
{{ .Release.Name }}-{{ (include "yandex.machine-class.spec" .) | sha256sum | substr 0 8 }}
{{- end }}

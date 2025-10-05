{{/*
Expand the name of the chart.
*/}}
{{- define "connections-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "connections-helm.fullname" -}}
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
{{- define "connections-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "connections-helm.labels" -}}
helm.sh/chart: {{ include "connections-helm.chart" . }}
{{ include "connections-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "connections-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "connections-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "connections-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "connections-helm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Frontend fullname
*/}}
{{- define "connections-helm.frontend.fullname" -}}
{{- printf "%s-%s" (include "connections-helm.fullname" .) "frontend" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Backend fullname
*/}}
{{- define "connections-helm.backend.fullname" -}}
{{- printf "%s-%s" (include "connections-helm.fullname" .) "backend" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Frontend selector labels
*/}}
{{- define "connections-helm.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "connections-helm.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
Backend selector labels
*/}}
{{- define "connections-helm.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "connections-helm.name" . }}-backend
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Frontend labels
*/}}
{{- define "connections-helm.frontend.labels" -}}
helm.sh/chart: {{ include "connections-helm.chart" . }}
{{ include "connections-helm.frontend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Backend labels
*/}}
{{- define "connections-helm.backend.labels" -}}
helm.sh/chart: {{ include "connections-helm.chart" . }}
{{ include "connections-helm.backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

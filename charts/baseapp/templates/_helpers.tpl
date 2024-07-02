{{/*
Expand the name of the chart.
*/}}
{{- define "baseapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Expand the namespaceOverride of the chart.
*/}}
{{- define "baseapp.namespaceOverride" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" }}
{{- end }}



{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "baseapp.fullname" -}}
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
Define the service name
*/}}
{{- define "baseapp.servicename" -}}
{{- if .Values.service.name }}
{{- .Values.service.name }}
{{- else }}
{{- printf "%s-svc" (include "baseapp.name" .) }}
{{- end }}
{{- end }}

{{/*
Define the namespace
*/}}
{{- define "baseapp.namespace" -}}
{{- if .Values.namespace -}}
    {{- .Values.namespace -}}
{{- else -}}
    {{- $name := include "baseapp.name" . -}}
    {{- $parts := splitList "-" $name -}}
    {{- $firstPart := first $parts -}}
    {{- printf "%s-%s" .Values.environment $firstPart -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "baseapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Define the Logstore Name
*/}}
{{- define "baseapp.LogstoreName" -}}
{{- $prefix := "aliyun_logs_" -}}
{{- if .Values.LogstoreName -}}
    {{- printf "%s%s" $prefix .Values.LogstoreName -}}
{{- else -}}
    {{- printf "%s%s" $prefix .Release.Name -}}
{{- end -}}
{{- end -}}




{{/*
Common labels
*/}}
{{- define "baseapp.labels" -}}
helm.sh/chart: {{ include "baseapp.chart" . }}
{{ include "baseapp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "baseapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "baseapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "baseapp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "baseapp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

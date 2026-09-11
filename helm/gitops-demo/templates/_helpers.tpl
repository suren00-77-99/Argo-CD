{{- define "gitops-demo.name" -}}
gitops-demo
{{- end }}

{{- define "gitops-demo.fullname" -}}
{{- .Release.Name -}}
{{- end }}

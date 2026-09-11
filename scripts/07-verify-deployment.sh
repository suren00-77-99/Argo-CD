#!/usr/bin/env bash
set -euo pipefail

kubectl get applications -n argocd
kubectl get all -n gitops-demo
kubectl get pods -n gitops-demo -o wide
kubectl rollout status deployment/gitops-demo-frontend -n gitops-demo --timeout=180s
kubectl rollout status deployment/gitops-demo-backend -n gitops-demo --timeout=180s

echo "Deployed image versions:"
kubectl get deploy -n gitops-demo \
  -o jsonpath='{range .items[*]}{.metadata.name}{" => "}{.spec.template.spec.containers[0].image}{"\n"}{end}'

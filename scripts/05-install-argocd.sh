#!/usr/bin/env bash
set -euo pipefail

: "${ARGOCD_VERSION:?Set ARGOCD_VERSION, for example v3.1.8}"

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd \
  -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

kubectl rollout status deployment/argocd-server -n argocd --timeout=300s

echo "Argo CD installed."
echo "Initial admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
echo
echo
echo "GUI access:"
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "Open https://localhost:8080"
echo "Username: admin"
echo "Password: value printed above"

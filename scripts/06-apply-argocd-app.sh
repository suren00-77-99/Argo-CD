#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/application.yaml

kubectl get applications -n argocd

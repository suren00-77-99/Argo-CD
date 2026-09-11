#!/usr/bin/env bash
set -euo pipefail

: "${CLUSTER_NAME:?Set CLUSTER_NAME}"
: "${AWS_REGION:?Set AWS_REGION}"

aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$AWS_REGION"

echo "=== Cluster ==="
kubectl cluster-info

echo "=== Nodes ==="
kubectl get nodes -o wide

echo "=== System Pods ==="
kubectl get pods -n kube-system

echo "=== StorageClasses ==="
kubectl get storageclass

echo "=== EBS/EFS CSI Pods ==="
kubectl get pods -n kube-system | grep -E 'ebs-csi|efs-csi' || true

echo "=== Helm lint ==="
helm lint helm/gitops-demo \
  -f environments/dev/frontend-values.yaml \
  -f environments/dev/backend-values.yaml

echo "=== Helm template validation ==="
helm template gitops-demo helm/gitops-demo \
  -f environments/dev/frontend-values.yaml \
  -f environments/dev/backend-values.yaml >/tmp/rendered.yaml

kubectl apply --dry-run=server -f /tmp/rendered.yaml

echo "Validation completed."

#!/usr/bin/env bash
set -euo pipefail

# Run after exporting:
# CLUSTER_NAME=your-eks-cluster
# AWS_REGION=ap-south-1
#
# This script creates IAM service accounts with IRSA for EBS/EFS CSI drivers.
# It does NOT hard-code your ARN. The generated ARN is printed by eksctl.

: "${CLUSTER_NAME:?Set CLUSTER_NAME}"
: "${AWS_REGION:?Set AWS_REGION}"

eksctl utils associate-iam-oidc-provider \
  --cluster "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --approve

eksctl create iamserviceaccount \
  --cluster "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --namespace kube-system \
  --name ebs-csi-controller-sa \
  --role-name "${CLUSTER_NAME}-AmazonEKS_EBS_CSI_DriverRole" \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --override-existing-serviceaccounts

eksctl create iamserviceaccount \
  --cluster "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --namespace kube-system \
  --name efs-csi-controller-sa \
  --role-name "${CLUSTER_NAME}-AmazonEKS_EFS_CSI_DriverRole" \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonElasticFileSystemFullAccess \
  --approve \
  --override-existing-serviceaccounts

echo "Use the created role ARNs in your EKS add-on configuration."

#!/usr/bin/env bash
set -euo pipefail

# Run after exporting:
suren-eks-cluster=suren-eks-cluster
AWS_REGION=ap-south-1
#
# This script creates IAM service accounts with IRSA for EBS/EFS CSI drivers.
# It does NOT hard-code your ARN. The generated ARN is printed by eksctl.

: "${suren-eks-cluster:?Set suren-eks-cluster}"
: "${AWS_REGION:?Set AWS_REGION}"

eksctl utils associate-iam-oidc-provider \
  --cluster "suren-eks-cluster" \
  --region "ap-south-1" \
  --approve

eksctl create iamserviceaccount \
  --cluster "suren-eks-cluster" \
  --region "ap-south-1" \
  --namespace kube-system \
  --name ebs-csi-controller-sa \
  --role-name "${suren-eks-cluster}-AmazonEKS_EBS_CSI_DriverRole" \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --override-existing-serviceaccounts

eksctl create iamserviceaccount \
  --cluster "suren-eks-cluster" \
  --region "ap-south-1" \
  --namespace kube-system \
  --name efs-csi-controller-sa \
  --role-name "${suren-eks-cluster}-AmazonEKS_EFS_CSI_DriverRole" \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonElasticFileSystemFullAccess \
  --approve \
  --override-existing-serviceaccounts

echo "Use the created role ARNs in your EKS add-on configuration."

#!/usr/bin/env bash
set -euo pipefail

: "${CLUSTER_NAME:?Set CLUSTER_NAME}"
: "${AWS_REGION:?Set AWS_REGION}"
: "${EBS_ROLE_ARN:?Set EBS_ROLE_ARN}"
: "${EFS_ROLE_ARN:?Set EFS_ROLE_ARN}"

aws eks update-kubeconfig --name "suren-eks-cluster" --region "ap-south-1"

aws eks create-addon \
  --cluster-name "suren-eks-cluster" \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn "arn:aws:iam::322686612450:role/eks-cluster-AmazonEKS_EBS_CSI_DriverRoleroot" \
  --resolve-conflicts OVERWRITE || \
aws eks update-addon \
  --cluster-name "suren-eks-cluster" \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn "arn:aws:iam::322686612450:role/eks-cluster-AmazonEKS_EBS_CSI_DriverRoleroot" \
  --resolve-conflicts OVERWRITE

# EFS CSI is commonly installed as the AWS EFS CSI managed add-on where supported.
aws eks create-addon \
  --cluster-name "suren-eks-cluster" \
  --addon-name aws-efs-csi-driver \
  --service-account-role-arn "$EFS_ROLE_ARN" \
  --resolve-conflicts OVERWRITE || \
aws eks update-addon \
  --cluster-name "suren-eks-cluster" \
  --addon-name aws-efs-csi-driver \
  --service-account-role-arn "$EFS_ROLE_ARN" \
  --resolve-conflicts OVERWRITE

aws eks describe-addon --cluster-name "suren-eks-cluster" --addon-name aws-ebs-csi-driver \
  --query 'addon.status' --output text
aws eks describe-addon --cluster-name "suren-eks-cluster" --addon-name aws-efs-csi-driver \
  --query 'addon.status' --output text

#!/usr/bin/env bash
set -euo pipefail

: "${CLUSTER_NAME:?Set CLUSTER_NAME}"
: "${AWS_REGION:?Set AWS_REGION}"
: "${EBS_ROLE_ARN:?Set EBS_ROLE_ARN}"
: "${EFS_ROLE_ARN:?Set EFS_ROLE_ARN}"

aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$AWS_REGION"

aws eks create-addon \
  --cluster-name "$CLUSTER_NAME" \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn "$EBS_ROLE_ARN" \
  --resolve-conflicts OVERWRITE || \
aws eks update-addon \
  --cluster-name "$CLUSTER_NAME" \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn "$EBS_ROLE_ARN" \
  --resolve-conflicts OVERWRITE

# EFS CSI is commonly installed as the AWS EFS CSI managed add-on where supported.
aws eks create-addon \
  --cluster-name "$CLUSTER_NAME" \
  --addon-name aws-efs-csi-driver \
  --service-account-role-arn "$EFS_ROLE_ARN" \
  --resolve-conflicts OVERWRITE || \
aws eks update-addon \
  --cluster-name "$CLUSTER_NAME" \
  --addon-name aws-efs-csi-driver \
  --service-account-role-arn "$EFS_ROLE_ARN" \
  --resolve-conflicts OVERWRITE

aws eks describe-addon --cluster-name "$CLUSTER_NAME" --addon-name aws-ebs-csi-driver \
  --query 'addon.status' --output text
aws eks describe-addon --cluster-name "$CLUSTER_NAME" --addon-name aws-efs-csi-driver \
  --query 'addon.status' --output text

# CD / GitOps Repository

This repository contains only deployment configuration.

## GitOps model

CI repository:
`code -> lint/syntax -> unit test -> build -> scan -> ECR -> update this repo`

CD repository:
`Git change -> Argo CD detects change -> Helm renders chart -> Kubernetes deploys`

Argo CD continuously watches this repository. Do not build Docker images here.

## Important placeholders

Replace:
- `123456789012` with your AWS account ID.
- `YOUR_ECR_REGISTRY` with your ECR registry.
- `YOUR_ORG` with your GitHub organization.
- `YOUR_GITOPS_REPO_URL` with the CD repository URL.
- `YOUR_EBS_ROLE_ARN` with the EBS CSI IAM role ARN.
- `YOUR_EFS_ROLE_ARN` with the EFS CSI IAM role ARN.

For EBS/EFS add-ons, the IAM role ARN is normally supplied to the EKS add-on configuration. The exact ARN depends on your AWS account and cluster setup.

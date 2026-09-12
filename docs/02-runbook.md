# Deployment Runbook

## 1. Configure variables

```bash
export CLUSTER_NAME=suren-eks-cluster
export AWS_REGION=ap-south-1
export EBS_ROLE_ARN=arn:aws:iam::123456789012:role/REPLACE_EBS_ROLE
export EFS_ROLE_ARN=arn:aws:iam::123456789012:role/REPLACE_EFS_ROLE
export ARGOCD_VERSION=v3.1.8
```

Use the Argo CD version approved by your organization.

## 2. Check tools

```bash
./scripts/01-prerequisites.sh
```

## 3. Configure EBS/EFS CSI IAM

```bash
./scripts/02-create-eks-addon-roles.sh
```

Record the generated IAM role ARNs.

## 4. Install/update EBS and EFS CSI add-ons

```bash
./scripts/03-install-addons.sh
```

Confirm status is `ACTIVE`.

## 5. Validate cluster and Helm

```bash
./scripts/04-validate-cluster.sh
```

Expected:
- nodes are Ready
- CSI components are healthy
- Helm lint returns 0
- Helm template renders
- server-side Kubernetes validation succeeds

## 6. Install Argo CD

```bash
./scripts/05-install-argocd.sh
```

For lab access:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open:
`https://localhost:8080`

Username:
`admin`

Password:
the generated initial secret value printed by the script.

For production, immediately rotate the admin password and preferably use SSO/RBAC instead of sharing the admin account.

## 7. Configure repository URL

Replace `YOUR_GITOPS_REPO_URL` in:
- `argocd/project.yaml`
- `argocd/application.yaml`

Replace ECR placeholders in:
- `helm/gitops-demo/values.yaml`
- environment values

## 8. Create Argo CD Application

```bash
./scripts/06-apply-argocd-app.sh
```

Check:

```bash
kubectl get applications -n argocd
```

## 9. CI-driven deployment

A normal application change follows:

```text
git push
  |
  +--> lint + syntax
  |
  +--> unit tests
  |
  +--> Docker build
  |
  +--> Trivy scan
  |
  +--> push image to ECR
  |
  +--> CI changes image tag in CD repo
  |
  +--> git push to CD repo
  |
  +--> Argo CD detects commit
  |
  +--> Helm renders chart
  |
  +--> Argo CD syncs EKS
  |
  +--> Kubernetes rolling update
```

## 10. Verify

```bash
./scripts/07-verify-deployment.sh
```

Also inspect:

```bash
argocd app get gitops-demo
argocd app sync gitops-demo
argocd app history gitops-demo
```

Only run manual `argocd app sync` if you intentionally use manual sync. This example has automated sync enabled.

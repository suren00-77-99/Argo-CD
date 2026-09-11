# Interview Explanation

## How does CI/CD work in your project?

"I use a two-repository GitOps model.

The first repository contains frontend and backend source code and the CI pipeline. The CI pipeline performs linting and syntax checks, unit tests, Docker image builds, vulnerability scanning with Trivy, and pushes successful images to Amazon ECR.

After the image is pushed, CI updates only the image tag in the separate GitOps repository.

The second repository contains Helm charts, environment-specific values, and Argo CD Application definitions. Argo CD watches this repository and continuously reconciles the EKS cluster with the desired state in Git.

So CI does not directly deploy the application with kubectl. CI publishes the artifact and changes the desired state. Argo CD performs the deployment."

## How does the new image automatically deploy?

"The image gets a unique immutable tag based on the Git commit SHA. CI pushes that tag to ECR and updates the frontend and backend image tags in the GitOps repository. Argo CD detects the Git commit and syncs the Helm release. Kubernetes performs the rolling update."

## How do you verify deployment?

"I check Argo CD application health and sync status, then check Kubernetes pods, deployment rollout status, and the actual image running in the pod."

Example:

```bash
kubectl get application -n argocd
kubectl get pods -n gitops-demo
kubectl rollout status deployment/gitops-demo-frontend -n gitops-demo
kubectl rollout status deployment/gitops-demo-backend -n gitops-demo
kubectl get deploy -n gitops-demo \
  -o jsonpath='{range .items[*]}{.metadata.name}{" => "}{.spec.template.spec.containers[0].image}{"\n"}{end}'
```

## Why separate repositories?

"It separates application development from deployment desired state. It also provides a clean Git audit trail for production deployments and allows Argo CD to use Git as the source of truth."

## Why not use latest?

"I avoid `latest` because it is mutable and makes rollback and auditing difficult. I use an immutable commit-SHA tag."

## What happens if the deployment fails?

"Argo CD reports the application as degraded or out of sync. I check the application events, Kubernetes events, pod logs, rollout status, image pull errors, readiness probes, and Helm-rendered manifests. Because deployment state is in Git, rollback can be done by reverting the GitOps commit or changing the image tag to a known-good version."

## What is Helm doing?

"Helm packages the Kubernetes manifests and parameterizes values such as image repository, image tag, replicas, ports, and environment-specific configuration. Argo CD renders the Helm chart and applies the resulting desired state."

## What is EBS/EFS used for?

"EBS CSI provides Kubernetes integration with AWS EBS block storage, normally for persistent volumes such as databases. EFS CSI provides integration with Amazon EFS for shared file storage. The CSI drivers require AWS IAM permissions, commonly provided using IAM roles for service accounts or EKS Pod Identity depending on the setup."

## Security

- GitHub Actions uses OIDC rather than long-lived AWS keys.
- ECR is private.
- Image scanning blocks HIGH/CRITICAL vulnerabilities in this lab.
- Argo CD uses RBAC.
- Production should use SSO and disable/remove the default admin workflow where appropriate.
- Secrets should not be committed to Git. Use AWS Secrets Manager/External Secrets or another approved secret-management solution.

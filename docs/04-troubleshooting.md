# Troubleshooting

## Argo CD is OutOfSync

```bash
kubectl get applications -n argocd
argocd app diff gitops-demo
argocd app get gitops-demo
```

Check:
- CD repository URL
- branch
- chart path
- values files
- image tag
- repository permissions

## ImagePullBackOff

```bash
kubectl describe pod -n gitops-demo <pod>
```

Check:
- ECR repository exists
- image tag exists
- EKS nodes/pods have ECR pull permissions
- repository and region are correct

## CrashLoopBackOff

```bash
kubectl logs -n gitops-demo <pod>
kubectl describe pod -n gitops-demo <pod>
```

Check:
- application startup command
- port
- readiness/liveness probe
- Python runtime errors

## Helm failure

```bash
helm lint helm/gitops-demo \
  -f environments/dev/frontend-values.yaml \
  -f environments/dev/backend-values.yaml

helm template gitops-demo helm/gitops-demo \
  -f environments/dev/frontend-values.yaml \
  -f environments/dev/backend-values.yaml
```

## Rollback

Preferred GitOps rollback:

```bash
git log --oneline
git revert <bad-commit>
git push
```

Then Argo CD reconciles the cluster to the reverted state.

Avoid making manual cluster changes that are not represented in Git, because Argo CD may overwrite them.

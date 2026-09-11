# Architecture

```text
                 +----------------------+
                 | Developer            |
                 | Git push             |
                 +----------+-----------+
                            |
                            v
              +---------------------------+
              | CI Repository             |
              | Python + HTML source      |
              +-------------+-------------+
                            |
             +--------------+--------------+
             | lint/syntax | unit test     |
             | build       | image scan    |
             | push to ECR                |
             +--------------+--------------+
                            |
                            v
              +---------------------------+
              | CD / GitOps Repository    |
              | Helm values image tag     |
              +-------------+-------------+
                            |
                            | watch
                            v
              +---------------------------+
              | Argo CD                   |
              | Helm render + sync        |
              +-------------+-------------+
                            |
                            v
                 +----------------------+
                 | EKS Cluster          |
                 | frontend + backend   |
                 +----------------------+
```

The key GitOps rule is:

**CI builds and publishes. CD repository declares what should run. Argo CD reconciles the cluster to that Git state.**

The CI pipeline never directly runs `kubectl apply` against the application.

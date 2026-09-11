# AWS IAM Notes

Do not copy example ARNs into a real environment.

Typical forms are:

EBS CSI role:
`arn:aws:iam::<ACCOUNT_ID>:role/<EBS_ROLE_NAME>`

EFS CSI role:
`arn:aws:iam::<ACCOUNT_ID>:role/<EFS_ROLE_NAME>`

GitHub Actions deployment role:
`arn:aws:iam::<ACCOUNT_ID>:role/<GITHUB_ACTIONS_ROLE_NAME>`

The GitHub Actions role should have only the permissions required to authenticate to ECR and push to the required repositories, plus permission to access the GitOps repository through GitHub. It should not need unrestricted cluster-admin permissions in the GitOps design.

For production, use least privilege and your organization's approved EKS add-on/IAM mechanism.

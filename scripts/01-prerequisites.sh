#!/usr/bin/env bash
set -euo pipefail

command -v aws >/dev/null || { echo "Install AWS CLI"; exit 1; }
command -v kubectl >/dev/null || { echo "Install kubectl"; exit 1; }
command -v helm >/dev/null || { echo "Install Helm"; exit 1; }
command -v eksctl >/dev/null || { echo "Install eksctl"; exit 1; }

aws sts get-caller-identity

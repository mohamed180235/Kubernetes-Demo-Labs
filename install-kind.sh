#!/usr/bin/env bash
set -euo pipefail

KIND_VERSION="$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest \
  | grep '"tag_name":' | cut -d'"' -f4)"

curl -Lo kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
chmod +x kind
sudo mv kind /usr/local/bin/kind

kind version

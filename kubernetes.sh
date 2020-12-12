#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"
source "${CDIR}/repositories.sh"

title "Installing Kubernetes"
repoKubernetes
sudo apt update -y
sudo apt install -y kubectl
breakLine

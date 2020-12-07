#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# Kubernetes
##########################################################
installKubernetes() {
    title "Adding repository"
    repoKubernetes
    title "Installing Kubernetes"
    sudo apt install -y kubectl
    breakLine
}
installKubernetes
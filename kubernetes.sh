#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Kubernetes"
repoKubernetes() {
    if [[ ! -f /etc/apt/sources.list.d/kubernetes.list ]]; then
        notify "Adding Kubernetes repository"
        curl -fsSL "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | sudo apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    fi
}
if _cmd_ apt; then
    repoKubernetes
    sudo apt update -y
    sudo apt install -y kubectl
fi
if _cmd_ pacman; then
    sudo pacman -S kubectl --noconfirm
fi

breakLine

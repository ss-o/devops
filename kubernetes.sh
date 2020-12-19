#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Kubernetes"

git clone https://github.com/kubernetes/kubernetes ~/.kubernetes
cd ~/.kubernetes && make quick-release

#if _cmd_ apt; then
#    sudo apt update -y
#    sudo apt install -y kubectl
#fi
#if _cmd_ pacman; then
#    sudo pacman -S kubectl --noconfirm
#fi

breakLine

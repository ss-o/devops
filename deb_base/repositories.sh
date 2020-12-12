#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

# PHP
##########################################################
repoPhp() {
    if [[ ! -f /etc/apt/sources.list.d/php.list ]]; then
        notify "Adding PHP sury repository"
        curl -fsSL "https://packages.sury.org/php/apt.gpg" | sudo apt-key add -
        echo "deb https://packages.sury.org/php/ ${versionDeb} main" | sudo tee /etc/apt/sources.list.d/php.list
    fi
}

# Docker CE
##########################################################
repoDocker() {
    if [[ ! -f /var/lib/dpkg/info/docker-ce.list ]]; then
        notify "Adding Docker repository"
        curl -fsSL "https://download.docker.com/linux/debian/gpg" | sudo apt-key add -
        case $versionArch in
        x86_64) sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" ;;
        aarch64) sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" ;;
        *) notify "Platform Unknown" ;;
        esac
    fi
}

repoKubernetes() {
    if [[ ! -f /etc/apt/sources.list.d/kubernetes.list ]]; then
        notify "Adding Kubernetes repository"
        curl -fsSL "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | sudo apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    fi
}

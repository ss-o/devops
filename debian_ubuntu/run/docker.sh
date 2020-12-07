#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# Docker
##########################################################
installDocker() {
    title "Installing Docker"
    echo "Installing docker"
    wget get.docker.com -O dockerInstall.sh
    chmod +x dockerInstall.sh
    ./dockerInstall.sh
     rm dockerInstall.sh
    # Adds user to the `docker` group so that docker commands can be run without sudo
     sudo usermod -aG docker ${USER}
}
installDocker

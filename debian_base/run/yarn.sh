#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# Yarn
##########################################################
installYarn() {
    title "Adding repository"
    repoYarn
    title "Installing Yarn"
    sudo apt install -y yarn
    breakLine
}
installYarn

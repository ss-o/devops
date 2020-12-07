#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"
# Node
##########################################################
installNode() {
    title "Installing Node ${versionNode}"
    curl -L "https://deb.nodesource.com/setup_${versionNode}.x" | sudo -E bash -
    sudo apt install -y nodejs npm

    if [[ ${versionDeb} = "stretch" ]]; then
        sudo chown -R "$(whoami)" /usr/lib/node_modules
        sudo chmod -R 777 /usr/lib/node_modules
    fi

    if [[ ${versionDeb} = "buster" ]]; then
        sudo chown -R "$(whoami)" /usr/share/npm/node_modules
        sudo chmod -R 777 /usr/share/npm/node_modules
    fi
    if [[ ${versionDeb} = "focal" ]]; then
        sudo chown -R "$(whoami)" /usr/lib/node_modules
        sudo chmod -R 777 /usr/lib/node_modules
    fi

    if [[ ${versionDeb} = "bionic" ]]; then
        sudo chown -R "$(whoami)" /usr/share/npm/node_modules
        sudo chmod -R 777 /usr/share/npm/node_modules
    fi

    breakLine
}
installNode
#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

title "Reinstall nodejs npm yarn"

install_nodjs-npm-yarn() {
    wget --no-cache -O - https://raw.githubusercontent.com/natancabral/ubuntu-bash-script-config/main/run/node-js-npm-yarn-reinstall.sh | bash
}
install_nodjs-npm-yarn
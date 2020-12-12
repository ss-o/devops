#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Node ${versionNode}"
curl -L "https://deb.nodesource.com/setup_${versionNode}.x" | sudo -E bash -
sudo apt install -y nodejs npm

breakLine

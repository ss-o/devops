#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Node ${versionNode}"
notify "Adding apt-key"
curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
notify "Adding sources.list"
echo "deb https://deb.nodesource.com/${versionNode} $versionDeb main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://deb.nodesource.com/${versionNode} $versionDeb main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
sudo apt install -y nodejs

breakLine

#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Ruby with DAPP v${versionDapp}"
sudo apt install -y ruby-dev gcc pkg-config
sudo chown -R ${USER} /var/lib/gems
sudo chown -R ${USER} /usr/local/bin
sudo gem install mixlib-cli -v 1.7.0
sudo gem install dapp -v ${versionDapp}
breakLine

#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/../utils.sh"

title "Installing NVM"
[[ -d "$HOME/.nvm" ]] && sudo rm -r "$HOME/.nvm"
mkdir -p ~/.nvm
source ~/.bashrc
notify "Cloning NVM"

git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout v${versionNvm}
. "$NVM_DIR/nvm.sh"
cd - >/dev/null 2>&1

source ~/.bashrc
nvm install v${versionNode} --latest-npm

breakLine

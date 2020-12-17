#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP GO
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing NVM"

[[ -d "$HOME/.nvm" ]] && sudo rm -r "$HOME/.nvm"
mkdir -p ~/.nvm && source ~/.bashrc

notify "Cloning NVM" && echo
git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout v${versionNvm}
. "$NVM_DIR/nvm.sh"
cd - >/dev/null 2>&1

source ~/.bashrc

notify "Installing Node" && echo
nvm install v${versionNode}
nvm use v${versionNode}

notify "Installing Npm" && echo
nvm install-latest-npm

notify "Installing Yarn" && echo
npm install -g gulp yarn --unsafe-perm

notify "Setting python binding"
npm config set python $(which python)

source ~/.bashrc

notify "Installing Npm tools" && echo
npm install -g typescript
npm install -g markdown-it
npm install -g tldr
npm install -g nb.sh

sudo "$(which nb)" completions install

notify "Installing Yarn tools" && echo
yarn global add heroku
yarn global add jshint
yarn global add prettier
yarn global add typescript-language-server
yarn global add bash-language-server
yarn global add webpack

breakLine

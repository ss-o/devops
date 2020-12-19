#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP NVM
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

# ============================================================================= #
#  ➜ ➜ ➜ TRAP
# ============================================================================= #
trap '' SIGINT SIGQUIT SIGTSTP

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utilities.sh"

build_nvm() {

    title "Installing NVM"

    [[ -d "$HOME/.nvm" ]] && sudo rm -r "$HOME/.nvm"
    _miss_dir "$HOME/.nvm"

    notify "Cloning NVM" && echo
    NVM_DIR="$HOME/.nvm"

    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout v${versionNvm}
    . "$NVM_DIR/nvm.sh"
    cd - >/dev/null 2>&1

    notify "Setting current owner as owner of ~/.nvm"
    chown ${USER:=$(/usr/bin/id -run)}:$USER -R ~/.nvm

    _reload_bashrc

    notify "Setting up NVM" && echo
    nvm install v${versionNode}
    nvm use v${versionNode}
    nvm alias default v${versionNode}

    notify "Installing Npm" && echo
    nvm install-latest-npm

    notify "Installing Npm tools" && echo
    npm install -g typescript
    npm install -g markdown-it
    npm install -g npm
    npm install -g tldr
    npm install -g nb.sh

    notify "Setting python binding" && echo
    npm config set python $(which python)

    sudo "$(which nb)" completions install

    notify "Installing Yarn" && echo
    npm install -g gulp yarn --unsafe-perm

    notify "Installing Yarn tools" && echo
    yarn global add heroku
    yarn global add jshint
    yarn global add prettier
    yarn global add typescript-language-server
    yarn global add bash-language-server
    yarn global add webpack

    _reload_bashrc

    breakLine
    exit 0
}
while true; do
    build_nvm
done

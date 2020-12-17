#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP RBENV
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utils.sh"

if _cmd_ rbenv; then
    notify "rbenv already install installed, wnat to reinstall?" && echo
    if _confirm; then
        return
    else
        exit
    fi
fi

title "Installing rbenv" && echo
sudo rm -rf ~/.rbenv

notify "Cloning rbenv" && echo
git clone https://github.com/Digital-Clouds/rbenv.git ~/.rbenv

notify "Cloning ruby-build" && echo
git clone https://github.com/Digital-Clouds/ruby-build.git ~/.rbenv/plugins/ruby-build

_source_bashrc

notify "Installing Ruby" && echo
rbenv install ${versionRuby} #Installing required version of Ruby
rbenv global ${versionRuby}

notify "Gem installing tools" && echo
gem install bundler rdoc rails mixlib-cli dapp

rbenv rehash

notify "To verify that rbenv is properly set up, running rbenv doctor" && echo
sleep 2

./rbenv-docktor.sh

breakLine

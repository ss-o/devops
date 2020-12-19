#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP RBENV
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utilities.sh"

# ============================================================================= #
#  ➜ ➜ ➜ TRAP
# ============================================================================= #
trap '' SIGINT SIGQUIT SIGTSTP

rbenv_build() {

    if _cmd_ apt; then
        apt-get-update-if-needed
        list="cmake make curl zlib1g-dev build-essential pkg-config libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev"
        for check in $list; do
            _apt_ "${check}"
        done
    fi
    if _cmd_ rbenv; then
        notify "rbenv already install installed, want to reinstall?" && echo
        if _confirm; then
            return
        else
            exit 0
        fi
    fi

    title "Installing rbenv" && echo
    if [ -d ~/.rbenv ]; then
        notify "Deleting previous installation"
        sudo rm -r ~/.rbenv
    fi

    notify "Cloning to ~/.rbenv" && echo
    git clone https://github.com/Digital-Clouds/rbenv.git ~/.rbenv

    notify "Cloning ~/.rbenv/plugins/ruby-build" && echo
    git clone https://github.com/Digital-Clouds/ruby-build.git ~/.rbenv/plugins/ruby-build

    _reload_bashrc || echo "Failed reload bash"

    notify "Installing Ruby ${versionRuby}" && echo
    rbenv install -v ${versionRuby} #Installing required version of Ruby
    rbenv global ${versionRuby}
    rbenv rehash

    notify "Runing gem install" && echo
    gem install bundler rdoc rails mixlib-cli dapp

    notify "To verify that rbenv is properly set up, running rbenv doctor" && echo
    sleep 2
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

    breakLine
    exit 0
}

while true; do
    rbenv_build
done

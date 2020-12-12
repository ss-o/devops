#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing rbenv" && echo
sudo rm -rf ~/.rbenv

notify "Cloning rbenv" && echo
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
source ~/.bashrc

notify "Cloning ruby-build" && echo
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bashrc

notify "Installing Ruby" && echo
rbenv install ${versionRuby} #Installing required version of Ruby
rbenv global ${versionRuby}

notify "Gem installing tools" && echo
gem install bundler rdoc rails mixlib-cli dapp

breakLine

exec "$SHELL"

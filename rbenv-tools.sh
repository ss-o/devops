#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing rbenv"

sudo rm -rf ~/.rbenv

notify "Cloning rbenv"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
source ~/.bashrc

notify "Cloning ruby-build"
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bashrc

notify "Installing Ruby"
rbenv install ${versionRuby} #Installing required version of Ruby
rbenv global ${versionRuby}
gem install bundler

breakLine

title "Installing DAPP"
gem install mixlib-cli -v 1.7.0
gem install dapp
breakLine
gem update
breakLine

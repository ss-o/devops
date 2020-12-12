#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

#title "Installing Ruby with DAPP v${versionDapp}"
#sudo apt install -y ruby-dev gcc pkg-config
#sudo chown -R ${USER} /var/lib/gems
#sudo chown -R ${USER} /usr/local/bin
#sudo gem install mixlib-cli -v 1.7.0
#sudo gem install dapp -v ${versionDapp}
#breakLine

title "Installing rbenv"
notify "Installing dependencies"
sudo apt install -y git curl autoconf bison build-essential \
    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
    libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

sudo rm -rf ~/.rbenv
notify "Cloning rbenv"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
source ~/.bashrc
notify "Cloning ruby-build"
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bashrc
rbenv install ${versionRuby} #Installing required version of Ruby

breakLine

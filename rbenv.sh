#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing rbenv"

sudo rm -rf ~/.rbenv/
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
#		echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
#		echo 'eval "$(rbenv init -)"' >> ~/.bashrc
#		export PATH="$HOME/.rbenv/bin:$PATH"
#		eval "$(rbenv init -)"
#		source ~/.bashrc
#		type rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
#		echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
#		source ~/.bashrc
rbenv install 2.7.1 #Installing required version of Ruby

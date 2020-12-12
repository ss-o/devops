#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/../utils.sh"

title "Install python"

if ! _cmd_ python; then
    sudo pacman -S python3
fi

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python ${PWD}/get-pip.py --user
sudo ln -vsf ${PWD}/usr/share/zsh/site-functions/_pipenv /usr/share/zsh/site-functions/_pipenv
pip install --user --upgrade pip
pip install --user autopep8
pip install --user httpie
pip install --user importmagic
pip install --user pipenv
pip install --user progressbar2
pip install --user pylint
pip install --user python-language-server
pip install --user trash-cli
pip install --user virtualenv
pip install --user virtualenvwrapper
rm -fr get-pip.py

breakLine

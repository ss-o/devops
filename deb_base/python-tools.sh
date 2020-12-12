#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/../utils.sh"

title "Installing Python3 with PIP"
sudo apt install -y build-essential libssl-dev libffi-dev python-dev python3-pip

mkdir -p ${HOME}/.local/bin
source ~/.bashrc
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 ${PWD}/get-pip.py --user
sudo ln -vsf ${PWD}/usr/share/zsh/site-functions/_pipenv /usr/share/zsh/site-functions/_pipenv
pip install --user --upgrade pip
pip install --user autopep8
pip install --user wheel
pip install --user setuptools
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

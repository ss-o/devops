#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Python, PIP & tools"

if ! _cmd_ python; then
    if _exec_ apt; then
        sudo apt install -y build-essential libssl-dev libffi-dev python-dev python3-pip
    fi
    if _exec_ pacman; then
        sudo pacman -S python --noconfirm
    fi
fi

mkdir -p ${HOME}/.local/bin
source ~/.bashrc
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 ${PWD}/get-pip.py --user
pip install --user --upgrade pip
pip install --user autopep8
pip install --user diagrams
pip install --user wheel
pip install --user setuptools
pip install --user httpie
pip install --user importmagic
pip install --user pipx
pip install --user pipenv
pip install --user vscodex
pip install --user vstask
pip install --user pppiv
pip install --user vscod
pip install --user progressbar2
pip install --user faker
pip install --user vspoetry
pip install --user flake8
pip install --user pylint
pip install --user pygments
pip install --user python-language-server
pip install --user trash-cli
pip install --user virtualenv
pip install --user virtualenvwrapper
rm -fr get-pip.py

#pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user

breakLine

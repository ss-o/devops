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
python3 -m pip install --user --upgrade pip
python3 -m pip install --user virtualenv
pip install --user --upgrade pip
pip install --user autopep8
pip install --user httpie
pip install --user importmagic
pip install --user pipenv
pip install --user pygments
pip install --user virtualenvwrapper
rm -fr get-pip.py

#pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user

breakLine

#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Python, PIP & tools"

#if ! _cmd_ python; then
    if _exec_ apt; then
        sudo apt install -y build-essential libssl-dev libffi-dev  python3-venv python-tk python-dev python3-pip
    fi
    if _exec_ pacman; then
        sudo pacman -S python python-virtualenv python-pipenv python-pip --noconfirm
    fi
#fi

mkdir -p ${HOME}/.local/bin
source ~/.bashrc
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 ${PWD}/get-pip.py --user
pip install --user --upgrade pip
pip install --user autopep8
pip install --user httpie
pip install --user importmagic
pip install --user pipenv
pip install --user pygments
pip install --user matplotlib
pip install --user pylint
pip install --user flake8
pip install --user mypy
pip install --user pydocstyle
pip install --user pycodestyle
pip install --user prospector
pip install --user pylama
pip install --user bandit
pip install --user poetry
pip install --user flask
pip install --user jupyter
pip install --user virtualenv
pip install --user virtualenvwrapper
rm -fr get-pip.py

#pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user
notify "Generating ~/.pylintrc"
pylint --generate-rcfile > ~/.pylintrc

breakLine

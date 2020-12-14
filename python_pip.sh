#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

if _cmd_ apt; then
sudo apt install -y build-essential \
python3-dev python3-pip \
python3-venv zlib1g-dev libssl-dev libffi-dev \
libncurses5-dev libgdbm-dev libnss3-dev \
libssl-dev libreadline-dev libffi-dev curl
fi
if _cmd_ pacman; then
sudo pacman -S cmake gcc python python-virtualenv python-pip python-setuptools
fi

[[ ! -d "$HOME/.local" ]] && mkdir -p "$HOME/.local"
[[ ! -d "/usr/local/bin" ]] && mkdir -p "/usr/local/bin"
source ~/.bashrc

sudo ln -sf /usr/bin/python3 /usr/bin/python
sudo ln -sf /usr/bin/pip3 /usr/bin/pip

notify "Installing PIP" && echo

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python ${PWD}/get-pip.py --user

notify "Installing Tools using PIP" && echo
pip install --user --upgrade pip
pip install --user autopep8
pip install --user black
pip install --user cheat
pip install --user django
pip install --user faker
pip install --user flake8
pip install --user httpie
pip install --user importmagic
pip install --user jupyter
pip install --user litecli
pip install --user matplotlib
pip install --user pandas
pip install --user pipenv
pip install --user poetry
pip install --user progressbar2
pip install --user psycopg2-binary
pip install --user py-spy
pip install --user pydoc_utils
pip install --user pyflakes
pip install --user pylint
pip install --user python-language-server
pip install --user tldr
pip install --user conda
pip install --user pygments
pip install --user virtualenv
pip install --user virtualenvwrapper
pip install --user yapf

rm -fr get-pip.py

#pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user

breakLine
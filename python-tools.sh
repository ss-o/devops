#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Python, PIP & tools"

#if ! _cmd_ python; then
if _exec_ apt; then
	sudo apt install -y build-essential libssl-dev libffi-dev python3-venv python-tk python-dev python3-pip
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
pip install --user black
pip install --user cheat
pip install --user diagrams
pip install --user django
pip install --user faker
pip install --user flake8
pip install --user gif-for-cli
pip install --user graph-cli
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
pip install --user r7insight_python
pip install --user redis
pip install --user tldr
pip install --user pygments
pip install --user virtualenv
pip install --user virtualenvwrapper
pip install --user yapf

rm -fr get-pip.py

#pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user
notify "Generating ~/.pylintrc"
pylint --generate-rcfile > ~/.pylintrc

breakLine

exec "$SHELL"


#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

if _exec_ apt; then
       . "deb_base/deps-devops.sh"
fi
if _exec_ pacman; then
       . "archlinux/deps.sh"
fi


title "Installing Python" && echo

mkdir -p ${HOME}/.local/bin
source ~/.bashrc

git clone https://github.com/ss-o/cpython.git
cd cpython
git checkout v${versionPython}
./configure --enable-optimizations --with-ensurepip=install
make -j 4
sudo make altinstall
cd - >/dev/null 2>&1
sudo rm -r cpython

python3 -m pip install --upgrade pip setuptools wheel

notify "Installing PIP" && echo
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 ${PWD}/get-pip.py --user --prefix="$HOME/.local"

notify "Installing Tools using PIP" && echo
pip install --user --upgrade pip
pip install --user autopep8
#pip install --user black
#pip install --user cheat
#pip install --user django
#pip install --user faker
#pip install --user flake8
#pip install --user httpie
#pip install --user importmagic
#pip install --user jupyter
#pip install --user litecli
#pip install --user matplotlib
#pip install --user pandas
pip install --user pipenv
#pip install --user poetry
#pip install --user progressbar2
#pip install --user psycopg2-binary
#pip install --user py-spy
#pip install --user pydoc_utils
#pip install --user pyflakes
#pip install --user pylint
#pip install --user python-language-server
#pip install --user tldr
#pip install --user conda
#pip install --user pygments
pip install --user virtualenv
pip install --user virtualenvwrapper
#pip install --user yapf

rm -fr get-pip.py

#pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user
#notify "Generating ~/.pylintrc" && echo
#pylint --generate-rcfile > ~/.pylintrc

breakLine

exec "$SHELL"

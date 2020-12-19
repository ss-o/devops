#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP PYENV
# ============================================================================= #
#set -euo pipefaile
[ -n "${DEBUG:-}" ] && set -x

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utilities.sh"

# ============================================================================= #
#  ➜ ➜ ➜ TRAP
# ============================================================================= #
trap '' SIGINT SIGQUIT SIGTSTP

build_pyenv() {

    _miss_dir "${HOME}/.local"
    _miss_dir "${HOME}/.pyenv"

    if _cmd_ apt; then
        list="build-essential libssl-dev zlib1g-dev libbz2-dev libxml2-dev \
                libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev libxmlsec1-dev \
                xz-utils tk-dev libffi-dev liblzma-dev python-openssl git"
        for check in $list; do
            _apt_ "${check}"
        done
    fi
    if _cmd_ pacman; then
        list="base-devel openssl zlib bzip2 readline sqlite curl \
            llvm ncurses xz tk libffi python-pyopenssl git"
        for check in $list; do
            _pacman_ "${check}"
        done
    fi
    if _cmd_ yum; then
        sudo yum install @development zlib-devel bzip2 bzip2-devel readline-devel sqlite \
            sqlite-devel openssl-devel xz xz-devel libffi-devel findutils
    fi

    title "Installing Pyenv"

    notify "Cloning to ~/.pyenv" && echo
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv

    _reload_bashrc

    notify "Installing Python-${versionPython}" && echo
    pyenv install "${versionPython}"
    pyenv global "${versionPython}"
    pyenv rehash

    _reload_bashrc

    notify "Installing Pyenv doctor"
    git clone https://github.com/pyenv/pyenv-doctor.git "$(pyenv root)/plugins/pyenv-doctor"
    pyenv doctor

    notify "Installing Tools using PIP" && echo
    pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user
    pip install autopep8
    pip install black
    pip install cheat
    pip install django
    pip install faker
    pip install flake8
    pip install httpie
    pip install importmagic
    pip install jupyter
    pip install litecli
    pip install matplotlib
    pip install pandas
    pip install pipenv
    pip install poetry
    pip install progressbar2
    pip install pydoc_utils
    pip install pyflakes
    pip install pylint
    pip install python-language-server
    pip install pygments
    pip install virtualenv
    pip install virtualenvwrapper
    pip install yapf
    pip install thefuck

    _reload_bashrc

    breakLine
    exit 0
}
while true; do
    build_pyenv
done

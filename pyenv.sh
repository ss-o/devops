#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP PYENV
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utils.sh"

[[ ! -d "$HOME/.local" ]] && mkdir -p "$HOME/.local"
[[ ! -d "/usr/local/bin" ]] && mkdir -p "/usr/local/bin"
[[ -d "$HOME/.pyenv" ]] && sudo rm -r "$HOME/.pyenv"
mkdir -p ~/.pyenv

install_pip_manually() {
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python ${PWD}/get-pip.py --user
    rm -fr get-pip.py
}

if _cmd_ apt; then
    sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
fi
if _cmd_ pacman; then
    sudo pacman -S base-devel openssl zlib bzip2 readline sqlite curl \
        llvm ncurses xz tk libffi python-pyopenssl git --noconfirm --needed
fi
if _cmd_ yum; then
    sudo yum install @development zlib-devel bzip2 bzip2-devel readline-devel sqlite \
        sqlite-devel openssl-devel xz xz-devel libffi-devel findutils
fi

title "Installing Pyenv"

notify "Cloning to ~/.pyenv" && echo
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

_source_bashrc

notify "Installing Python-${versionPython}" && echo
pyenv rehash
pyenv install ${versionPython}
pyenv global ${versionPython}

notify "Installig PIP" && echo

if ! type -P pip; then
    set +e
    pip2="$(type -P pip2 2>/dev/null)"
    pip3="$(type -P pip3 2>/dev/null)"
    set -e
    if [ -f /usr/local/bin/pip ]; then
        echo "/usr/local/bin/pip already exists, not symlinking - check your \$PATH includes /usr/local/bin (\$PATH = $PATH)"
    elif [ -n "$pip3" ]; then
        sudo ln -sv "$pip3" /usr/local/bin/pip
    elif [ -n "$pip2" ]; then
        sudo ln -sv "$pip2" /usr/local/bin/pip
    else
        sudo easy_install pip || :
    fi
fi

notify "Installing Tools using PIP" && echo
pip install --upgrade pip wheel setuptools
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
#pip install --user pipenv
pip install poetry
pip install progressbar2
pip install psycopg2-binary
pip install py-spy
pip install pydoc_utils
pip install pyflakes
pip install pylint
pip install python-language-server
pip install pygments
pip install virtualenv
pip install virtualenvwrapper
pip install yapf
pip install thefuck

_source_bashrc

#pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user

breakLine

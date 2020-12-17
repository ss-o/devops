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

[[ -d "$HOME/.pyenv" ]] && sudo rm -r "$HOME/.pyenv"
mkdir -p ~/.pyenv

notify "Cloning to ~/.pyenv"
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

_source_bashrc

notify "Installing Python-${versionPython}"
pyenv install ${versionPython}

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

notify "Installing PIP" && echo

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python ${PWD}/get-pip.py --user

notify "Installing Tools using PIP" && echo
pip install --user --upgrade pip wheel setuptools
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
pip install --user pygments
pip install --user virtualenv
pip install --user virtualenvwrapper
pip install --user yapf
pip install --user thefuck

rm -fr get-pip.py

_source_bashrc

#pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user

breakLine

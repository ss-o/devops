#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP PYTHON
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utils.sh"

[[ ! -d "$HOME/.local" ]] && mkdir -p "$HOME/.local"
[[ ! -d "/usr/local/bin" ]] && mkdir -p "/usr/local/bin"

if _cmd_ apt; then
    sudo apt install -y build-essential \
        python3-dev python3-pip \
        python3-venv zlib1g-dev libssl-dev libffi-dev \
        libncurses5-dev libgdbm-dev libnss3-dev \
        libssl-dev libreadline-dev libffi-dev curl
fi
if _cmd_ pacman; then
    sudo pacman -S cmake gcc python python-virtualenv python-pip python-setuptools --noconfirm
fi

if ! type -P python &>/dev/null; then
    set +e
    python2="$(type -P python2 2>/dev/null)"
    python3="$(type -P python3 2>/dev/null)"
    set -e
    if [ -n "$python3" ]; then
        echo "alternatives: setting python -> $python3"
        sudo alternatives --set python "$python3"
    elif [ -n "$python2" ]; then
        echo "alternatives: setting python -> $python2"
        sudo alternatives --set python "$python2"
    fi
fi

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

#pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user

breakLine

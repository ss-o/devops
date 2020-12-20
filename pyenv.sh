#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP PYENV
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

# ============================================================================= #
#  ➜ ➜ ➜ TRAP
# ============================================================================= #
trap '' SIGINT SIGQUIT SIGTSTP

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utilities.sh"

build_pyenv() {
    set +e
    [[ -d "$HOME/.pyenv" ]] && sudo rm -r "$HOME/.pyenv"
    _miss_dir "${HOME}/.local"
    _reload_bashrc

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
    set -e

    title "Installing Pyenv"

    notify "Cloning to ~/.pyenv" && echo
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv

    _reload_bashrc

    notify "Installing Python-${versionPython}" && echo
    pyenv install "${versionPython}"
    pyenv global "${versionPython}"
    pyenv rehash

    _reload_bashrc

    if ! type -P python &>/dev/null; then
        set +e
        python2="$(type -P python2 2>/dev/null)"
        python3="$(type -P python3 2>/dev/null)"
        set -e
        if [ -n "$python3" ]; then
            printSubhead "Python uses $python3"
        elif [ -n "$python2" ]; then
            printSubhead "Python uses $python2"
        fi
    fi

    if ! type -P pip; then
        set +e
        pip2="$(type -P pip2 2>/dev/null)"
        pip3="$(type -P pip3 2>/dev/null)"
        set -e
        if [ -f /usr/local/bin/pip ]; then
            echo "/usr/local/bin/pip already exists, not symlinking - check your \$PATH includes /usr/local/bin (\$PATH = $PATH)"
        elif [ -f $HOME/.local/bin/pip ]; then
            echo "~/.local/bin/pip already exists, not symlinking - check your \$PATH includes ~/,local/bin (\$PATH = $PATH)"
        elif [ -n "$pip3" ]; then
            $sudo ln -sv "$pip3" /usr/local/bin/pip
        elif [ -n "$pip2" ]; then
            $sudo ln -sv "$pip2" /usr/local/bin/pip
        else
            $sudo easy_install pip || :
        fi
    fi

    notify "Installing Tools using PIP" && echo
    python="${PYTHON:-python}"
    python="$(type -P "$python")"
    $python -m pip install --upgrade pip setuptools wheel
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
    #    pip install pandas
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
    #    pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user

    _reload_bashrc

    notify "Installing Pyenv doctor"
    git clone https://github.com/pyenv/pyenv-doctor.git "$(pyenv root)/plugins/pyenv-doctor"
    pyenv doctor

    breakLine
    exit 0
}
while true; do
    build_pyenv
done

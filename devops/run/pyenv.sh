#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

title "Installing pyenv"
install_pyenv() {
curl https://pyenv.run | bash
}
install_pyenv
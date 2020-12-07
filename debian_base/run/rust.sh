#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

title "Installing Rust"
install_rust() {
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
}
install_rust
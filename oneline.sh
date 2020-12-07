install_pyenv() {
curl https://pyenv.run | bash
}

install_rust() {
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
}
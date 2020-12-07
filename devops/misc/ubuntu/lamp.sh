
# https://github.com/natancabral/ubuntu-bash-script-config#install
install_lamp() {
    wget --no-cache -O - https://raw.githubusercontent.com/natancabral/ubuntu-bash-script-config/main/run/lamp.sh | bash
}
remove_lamp() {
    wget --no-cache -O - https://raw.githubusercontent.com/natancabral/ubuntu-bash-script-config/main/run/uninstall-lamp.sh | bash
}
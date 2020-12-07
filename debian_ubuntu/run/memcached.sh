#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# Memcached
##########################################################
installMemcached() {
    title "Installing Memcached"
    sudo apt install -y memcached
    sudo systemctl start memcached
    sudo systemctl enable memcached
    breakLine
}
installMemcached
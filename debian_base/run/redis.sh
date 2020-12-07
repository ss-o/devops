#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# Redis
##########################################################
installRedis() {
    title "Installing Redis"
    sudo apt install -y redis-server
    sudo systemctl start redis
    sudo systemctl enable redis
    breakLine
}
installRedis
#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Memcached"
if _exec_ apt; then
    sudo apt install -y memcached
elif _exec_ pacman; then
    sudo pacman -S memcached --noconfirm
fi

notify "Enabling memcached"

sudo systemctl start memcached
sudo systemctl enable memcached

breakLine

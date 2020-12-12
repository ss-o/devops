#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing snap"

if _exec_ apt; then
    sudo apt install -y snapd
elif _exec_ pacman; then
    sudo pacman -S snapd --noconfirm
fi

notify "Enabling snapd & apparmor service"
sudo systemctl start snapd
sudo systemctl enable snapd
sudo systemctl start apparmor
sudo systemctl enable apparmor

notify "Reloading bash"
source ~/.bashrc

notify "Reloading snap"
sudo snap refresh

breakLine

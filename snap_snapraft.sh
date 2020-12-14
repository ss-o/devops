#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing snap"

if _exec_ apt; then
    sudo apt install -y snapd
elif _exec_ pacman; then
    sudo pacman -S snapd --noconfirm
fi

notify "Enabling snapd & apparmor service" && echo
sudo systemctl start snapd
sudo systemctl enable snapd
sudo systemctl start apparmor
sudo systemctl enable apparmor

notify "Reloading bash" && echo
source ~/.bashrc

notify "Reloading snap" && echo
sudo snap refresh
notify "Installing snapcraft" && echo
sudo snap install snapcraft --classic

breakLine

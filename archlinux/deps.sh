#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/../utils.sh"

title "Installing dependencies"

sudo pacman -S base base-devel unrar hugo ethtool \
    debootstrap oath-toolkit imagemagick profile-sync-daemon \
    pkgfile dconf-editor rsync debian-archive-keyring \
    nmap htop gvfs p7zip lzop arch-install-scripts curl \
    llvm llvm-libs lldb tree shellcheck bash-completion \
    cmatrix mlocate pacman-contrib x11-ssh-askpass \
    sshfs packer lsof mkcert \
    sudo pkgfile --update

breakLine

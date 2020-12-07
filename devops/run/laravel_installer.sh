#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# Laravel Installer
##########################################################
installLaravel() {
    title "Installing Laravel Installer"
    composer global require "laravel/installer"
    echo "export PATH=\"$PATH:$HOME/.config/composer/vendor/bin\"" | tee -a ~/.bashrc
    breakLine
}
installLaravel
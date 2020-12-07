#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"
# PHP
##########################################################
installPhp() {
    title "Adding repository"
    repoPhp
    title "Installing PHP ${versionPhp}"
    sudo apt install -y php${versionPhp} php${versionPhp}-{bcmath,cli,common,curl,dev,gd,intl,mbstring,mysql,sqlite3,xml,zip} php-pear php-memcached php-redis
    sudo apt install -y libphp-predis php-xdebug php-ds
    php --version

    sudo pecl install igbinary ds
    installedPhp=1
    breakLine
}
installPhp
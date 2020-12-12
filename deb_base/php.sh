#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/../utils.sh"
source "${CDIR}/repositories.sh"

title "Installing PHP ${versionPhp}"
repoPhp
sudo apt update -y
sudo apt install -y php${versionPhp} php${versionPhp}-{bcmath,cli,common,curl,dev,gd,intl,mbstring,mysql,sqlite3,xml,zip} php-pear php-memcached php-redis
sudo apt install -y libphp-predis php-xdebug php-ds
php --version

sudo pecl install igbinary ds
breakLine

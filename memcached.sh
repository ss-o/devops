#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Memcached"
sudo apt install -y memcached
sudo systemctl start memcached
sudo systemctl enable memcached
breakLine

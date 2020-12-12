#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/../utils.sh"

title "Installing docker"

curl -fsSL https://get.docker.com -o get-docker.sh
sudo bash get-docker.sh
sudo rm get-docker.sh
notify "Configuring and enabling docker"
sudo usermod -aG docker ${USER}
sudo systemctl enable docker
sudo systemctl start docker

breakLine

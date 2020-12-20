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

if type -P docker-compose &>/dev/null; then
    echo "Docker Compose already installed, skipping install..."
else
    echo "========================="
    echo "Installing Docker Compose"
    echo "========================="
    echo
    dir=~/bin
    mkdir -pv "$dir"
    wget -c "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -O "$dir/docker-compose"
    chmod +x "$dir/docker-compose"
fi

breakLine

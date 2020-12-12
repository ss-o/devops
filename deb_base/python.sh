#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/../utils.sh"

title "Installing Python3 with PIP"
sudo apt install -y build-essential libssl-dev libffi-dev python-dev python3-pip
sudo ln -s /usr/bin/pip3 /usr/bin/pip
export PATH=/usr/local/bin/python:$PATH

breakLine

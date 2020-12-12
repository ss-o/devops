#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing GoLang ${versionGo}"

case $versionArch in
x86_64)
    curlToFile "https://dl.google.com/go/go${versionGo}.linux-amd64.tar.gz" "go.tar.gz"
    tar xvf go.tar.gz
    ;;
aarch64)
    curlToFile "https://dl.google.com/go/go${versionGo}.linux-arm64.tar.gz" "go.tar.gz"
    tar xvf go.tar.gz
    ;;
*) notify "Unknown platform" ;;
esac

if [[ -d /usr/local/go ]]; then
    sudo rm -rf /usr/local/go
fi

sudo mv go /usr/local
rm go.tar.gz -f

# shellcheck source=/dev/null
source ~/.bashrc

breakLine

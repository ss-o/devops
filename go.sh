#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP GO
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utilities.sh"

# ============================================================================= #
#  ➜ ➜ ➜ TRAP
# ============================================================================= #
trap '' SIGINT SIGQUIT SIGTSTP

title "Installing Go ${versionGo}"

printSubhead "$distroname $versionDeb $versionArch"
sleep 1

build_go() {

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

    _reload_bashrc

    notify "Setting up Go"
    echo
    go get github.com/davecheney/httpstat
    go get github.com/joho/godotenv
    go get github.com/briandowns/spinner
    go get github.com/donutloop/toolkit/worker
    cd "${CDIR}"

    _reload_bashrc

    breakLine
    exit 0
}
while true; do
    build_go
done

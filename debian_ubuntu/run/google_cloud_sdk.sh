#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# Google Cloud SDK
##########################################################
installGoogleSdk() {
    title "Installing Google Cloud SDK";
    sudo apt install -y google-cloud-sdk;
    breakLine;
}
installGoogleSdk
#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Google Cloud SDK"

curl https://sdk.cloud.google.com | bash
test -L ${HOME}/.config/gcloud || rm -rf ${HOME}/.config/gcloud

breakLine

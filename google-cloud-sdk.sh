#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP GOOGLE-CLOUD-SDK
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utils.sh"

title "Installing Google Cloud SDK"

curl https://sdk.cloud.google.com | bash
test -L ${HOME}/.config/gcloud || rm -rf ${HOME}/.config/gcloud

breakLine

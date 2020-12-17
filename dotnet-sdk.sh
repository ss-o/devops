#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SETUP DOTNET
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/lib/utils.sh"

title "Installing dotnet SDK" && echo
wget https://dotnet.microsoft.com/download/dotnet-core/scripts/v1/dotnet-install.sh
bash dotnet-install.sh
rm dotnet-install.sh

_source_bashrc

breakLine

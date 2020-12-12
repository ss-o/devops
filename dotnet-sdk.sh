#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing dotnet SDK" && echo
wget https://dotnet.microsoft.com/download/dotnet-core/scripts/v1/dotnet-install.sh
bash dotnet-install.sh
rm dotnet-install.sh
source ~/.bashrc

 breakLine

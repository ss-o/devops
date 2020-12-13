#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing Circle-ci" && echo
curl -fLSs https://circle.ci/cli | sudo bash
circleci update install
source ~/.bashrc

breakLine

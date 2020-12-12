#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

if _cmd_ npm; then
    title "Installing typescript"
    npm install -g typescript
    breakLine
else
    notify "NPM required to install typescript"
fi

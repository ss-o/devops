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

notify "Installing Go tools"
echo
GO111MODULE=on go get golang.org/x/tools/gopls@latest
GO111MODULE="on" go get -u -v golang.org/x/tools/cmd/goimports
go get -u -v github.com/golang/dep/cmd/dep
GO111MODULE="on" go get -u -v github.com/x-motemen/ghq
go get -u -v github.com/kyoshidajp/ghkw
go get -u -v github.com/simeji/jid/cmd/jid
go get -u -v github.com/jmhodges/jsonpp
GO111MODULE="on" go get -u -v github.com/mithrandie/csvq
go get -u -d github.com/magefile/mage
cd "${GOPATH}/src/github.com/magefile/mage"
go run bootstrap.go
cd "${CDIR}"

exec "$SHELL"
breakLine

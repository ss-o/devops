#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# GoLang
##########################################################
installGoLang() {
    title "Installing GoLang ${versionGo}"
    if [ "uname -m" == "aarch64" ]; then
    curlToFile "https://dl.google.com/go/go${versionGo}.linux-arm64.tar.gz" "go.tar.gz"
    elif
    curlToFile "https://dl.google.com/go/go${versionGo}.linux-amd64.tar.gz" "go.tar.gz"
    tar xvf go.tar.gz
    else
    sudo apt install -y golang
    fi
    if [[ -d /usr/local/go ]]; then
        sudo rm -rf /usr/local/go
    fi

    sudo mv go /usr/local
    rm go.tar.gz -f

    title "Adding /etc/bash_completion.d/go"
    sudo curl -o /etc/bash_completion.d/go "https://raw.githubusercontent.com/kura/go-bash-completion/master/etc/bash_completion.d/go"

    {
        echo -e "export GOROOT=\"/usr/local/go\"" \
            "\nexport GOPATH=\"$HOME/go\"" \
            "\nexport PATH=\"$PATH:/usr/local/go/bin:$GOPATH/bin\""
    } >>~/.bashrc

    # shellcheck source=/dev/null
    source ~/.bashrc
    mkdir "${GOPATH}"
    sudo chown -R root:root "${GOPATH}"

    breakLine
}
installGoLang

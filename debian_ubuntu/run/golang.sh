#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# GoLang
##########################################################
installGoLang() {
    title "Installing GoLang ${versionGo}"
    getarch="uname -m"
    
    case "$geterch" in
        aarch64) curlToFile "https://dl.google.com/go/go${versionGo}.linux-arm64.tar.gz" "go.tar.gz"
                tar xvf go.tar.gz ;; 
        x86_64)  curlToFile "https://dl.google.com/go/go${versionGo}.linux-amd64.tar.gz" "go.tar.gz"
                tar xvf go.tar.gz ;;
        *)      sudo apt install -y golang ;;
    esac

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
    [ -d "$GOPATH" ] && sudo rm -r "$GOPATH" && mkdir "${GOPATH}"
    
    sudo chown -R root:root "${GOPATH}"

    breakLine
}
installGoLang

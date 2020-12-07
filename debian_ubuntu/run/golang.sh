# GoLang
##########################################################
installGoLang() {
    title "Installing GoLang ${versionGo}"
    curlToFile "https://dl.google.com/go/go${versionGo}.linux-amd64.tar.gz" "go.tar.gz"
    tar xvf go.tar.gz

    if [[ -d /usr/local/go ]]; then
        sudo rm -rf /usr/local/go
    fi

    sudo mv go /usr/local
    rm go.tar.gz -f

    {
        echo -e "export GOROOT=\"/usr/local/go\"" \
            "\nexport GOPATH=\"$HOME/go\"" \
            "\nexport PATH=\"$PATH:/usr/local/go/bin:$GOPATH/bin\""
    } >>~/.bashrc

    # shellcheck source=/dev/null
    source ~/.bashrc
    mkdir "${GOPATH}"
    sudo chown -R root:root "${GOPATH}"

    installedGo=1
    breakLine
}
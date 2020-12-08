#!/usr/bin/env bash
DOTFILES="${HOME}/.dotfiles"

topgrade_install() {
    gituser="r-darwish"
    gitrepo="topgrade"
    ARCH=$(uname -m)

    case $ARCH in

    'x86_64')
        get_download_url() {
            wget -q -nv -O- https://api.github.com/repos/$gituser/$gitrepo/releases/latest 2>/dev/null | jq -r '.assets[] | select(.browser_download_url | contains("x86_64-unknown-linux-gnu")) | .browser_download_url'
        }
        URL=$(get_download_url)
        log_info "Found - $URL"
        ;;
    'aarch64')
        get_download_url() {
            wget -q -nv -O- https://api.github.com/repos/$gituser/$gitrepo/releases/latest 2>/dev/null | jq -r '.assets[] | select(.browser_download_url | contains("aarch64-unknown-linux-gnu")) | .browser_download_url'
        }
        URL=$(get_download_url)
        log_info "Found - $URL"
        ;;
    'armv7l')
        get_download_url() {
            wget -q -nv -O- https://api.github.com/repos/$gituser/$gitrepo/releases/latest 2>/dev/null | jq -r '.assets[] | select(.browser_download_url | contains("armv7-unknown-linux-gnueabihf")) | .browser_download_url'
        }
        URL=$(get_download_url)
        log_info "Found - $URL"
        ;;
    *)
        echo -ne "Platform not found. Failed download"
        sleep 3
        log_info "Exiting... "
        exit 0
        ;;
    esac
    execute_binary() {
        mkdir -p ~/.bin
        BASE=$(basename $URL)
        wget -q -nv -O $BASE $URL
        if [ ! -f $BASE ]; then
            echo "Didn't download $URL properly.  Where is $BASE?"
            exit 1
        fi
        echo
        mv $BASE ~/.bin
        log_info "Moved to ~/.bin/* "
        tarfile="$(cd $HOME/.bin && find . -name "*.tar.gz")"
        cd ~/.bin && tar -xzf $tarfile
        log_info "Extracting files... "
        rm $tarfile
        log_info "Removing unnecessary files "
        chmod +x ~/.bin/*
    }
    execute_binary
}
topgrade_install
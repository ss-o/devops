#!/usr/bin/env bash
SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/utils.sh"

# Helm
##########################################################
installHelm() {
    
    title "Installing Helm v${versionHelm}"    

    case "$(uname -m)" in
        aarch64) curl -fsSl "https://get.helm.sh/helm-v${versionHelm}-linux-arm64.tar.gz" -o helm.tar.gz
                tar -zxvf helm.tar.gz
                sudo mv linux-arm64/helm /usr/local/bin/helm
                sudo rm -rf linux-arm64 && sudo rm helm.tar.gz
                ;; 
        x86_64) curl -fsSl "https://get.helm.sh/helm-v${versionHelm}-linux-amd64.tar.gz" -o helm.tar.gz
                tar -zxvf helm.tar.gz
                sudo mv linux-amd64/helm /usr/local/bin/helm
                sudo rm -rf linux-amd64 && sudo rm helm.tar.gz
                ;;
        armv7l)  curl -fsSl "https://get.helm.sh/helm-v${versionHelm}-linux-arm.tar.gz" -o helm.tar.gz
                tar -zxvf helm.tar.gz
                sudo mv linux-arm/helm /usr/local/bin/helm
                sudo rm -rf linux-arm && sudo rm helm.tar.gz
                ;;
        *)      echo "Not found"
    esac
    breakLine
}
installHelm

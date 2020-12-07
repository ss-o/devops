#!/usr/bin/env bash

SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SRCDIR}/repositories.sh"

# Disallow running with sudo or su
##########################################################
if [[ "$EUID" -eq 0 ]]; then
    printf "\033[1;101mNein, Nein, Nein!! Please do not run this script as root (no su or sudo)! \033[0m \n"
    exit
fi

sudo apt install -y lsb-release
versionDeb="$(lsb_release -c -s)"
#if [[ ${versionDeb} != "stretch" ]] && [[ ${versionDeb} != "buster" ]]; then
#    printf "\033[1;101mUnfortunatly your OS Version (%s) is not supported. \033[0m \n" "${versionDeb}"
#    exit
#fi

###############################################################
## HELPERS
###############################################################

_confirm() {
  read -r -p "${1:-Continue?} [y/N]" response
  case $response in
  [yY][eE][sS] | [yY])
    true
    ;;
  *)
    false
    ;;
  esac
}

title() {
    printf "\033[1;42m"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ' '
    printf '%-*s\n' "${COLUMNS:-$(tput cols)}" "  # $1" | tr ' ' ' '
    printf '%*s' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ' '
    printf "\033[0m"
    printf "\n\n"
}

breakLine() {
    printf "\n"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    printf "\n\n"
    sleep .5
}

notify() {
    printf "\n"
    printf "\033[1;46m %s \033[0m" "$1"
}

curlToFile() {
    notify "Downloading: $1 ----> $2"
    sudo curl -fSL "$1" -o "$2"
}

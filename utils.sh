#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

###############################################################
## PACKAGE VERSIONS - CHANGE AS REQUIRED
###############################################################
versionPhp="7.4"
versionGo="1.15.6"
versionNode="12"
versionRuby="2.7.0"
versionDapp="0.43.2"
versionHelm="2.14.1"
versionSops="3.1.1"

# Disallow running with sudo or su
##########################################################
if [[ "$EUID" -eq 0 ]]; then
    printf "\033[1;101mNein, Nein, Nein!! Please do not run this script as root (no su or sudo)! \033[0m \n"
    exit
fi

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

_cmd_() { command -v "$1" >/dev/null 2>&1; }
_exec_() { type -fP "$1" >/dev/null 2>&1; }
_miss_dir() { [[ ! -d "$1" ]] && mkdir -p "$1"; }
_execroot() { [[ "$(whoami)" != "root" ]] && exec sudo -- "$0" "$@"; }

_date() { date "+%d-%m-%Y"; }
_time() { date "+%H-%M-%S"; }

## System information
if ! _cmd_ lsb_release; then
    sudo apt install -y lsb-release
fi
if ! _cmd_ git; then
    sudo apt install -y git
fi
versionDeb="$(lsb_release -c -s)"
versionArch="$(uname -m)"
versionKernel="$(uname -r)"

if [ -f "/etc/os-release" ]; then
    distroname=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)
elif [ -f "/etc/debian_version" ]; then
    distroname="debian"
elif [ -f "/etc/redhat-release" ]; then
    distroname=redhat
elif [ -f "/etc/fedora-release" ]; then
    distroname=fedora
elif [ -f "/etc/arch-release" ]; then
    distroname=arch
elif [ -f "/etc/alpine-release" ]; then
    distroname=alpine
else
    distroname="Unknown"
fi

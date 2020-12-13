#!/usr/bin/env bash
set -e

CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

###############################################################
## PACKAGE VERSIONS - CHANGE AS REQUIRED
###############################################################
versionPhp="7.4"
versionGo="1.15.6"
versionPython="3.9.1"
versionPypy="7.3.3"
versionNvm="0.37.2"
versionNode="12.2.0"
versionRuby="2.7.0"

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

apt-deps() {
    source apt.list
}

pacman-deps() {
    source pacman.list
}

apt-get-update-if-needed() {
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        sudo apt-get update -y
    else
        echo "Skipping apt-get update."
    fi
}

_cmd_() { command -v "$1" >/dev/null 2>&1; }
_exec_() { type -fP "$1" >/dev/null 2>&1; }
_miss_dir() { [[ ! -d "$1" ]] && mkdir -p "$1"; }
_execroot() { [[ "$(whoami)" != "root" ]] && exec sudo -- "$0" "$@"; }

_date() { date "+%d-%m-%Y"; }
_time() { date "+%H-%M-%S"; }

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

## System information
if [ "$distroname" = "debian" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get-update-if-needed
    ! _cmd_ lsb_release && sudo apt install -y lsb-release
    ! _cmd_ git && sudo apt install -y git
fi
if [ "$distroname" = "ubuntu" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get-update-if-needed
    ! _cmd_ lsb_release && sudo apt install -y lsb-release
    ! _cmd_ git && sudo apt install -y git
fi
if [ "$distroname" = "arch" ]; then
    sudo pacman -Syu --noconfirm
    if ! _cmd_ yay; then
        wget https://github.com/Jguer/yay/releases/download/v10.1.0/yay_10.1.0_x86_64.tar.gz
        tar xzvf yay_10.1.0_x86_64.tar.gz
        sudo cp -r yay_10.1.0_x86_64/yay /usr/bin/yay
        sudo rm -r "yay_10.1.0_x86_64.tar.gz" "yay_10.1.0_x86_64"
    fi
    ! _cmd_ lsb_release && sudo pacman -S lsb-release --noconfirm
    ! _cmd_ git && sudo pacman -S git --noconfirm
fi

versionDeb="$(lsb_release -c -s)"
versionArch="$(uname -m)"
versionKernel="$(uname -r)"

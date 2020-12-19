#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ GET OS INFO
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

distro_name() {
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
}

do_curr_arch() {
    versionArch="$(uname -m)"

    case "$versionArch" in
    *)
        echo "Unknown"
        "$1"
        ;;
    armv5)
        echo "armv5"
        "$1"
        ;;
    armv7h)
        echo "armv7h"
        "$1"
        ;;
    aarch64)
        echo "aarch64"
        "$1"
        ;;
    armv6h)
        echo "armv6h"
        "$1"
        ;;
    i686)
        echo "i686"
        "$1"
        ;;
    x86_64)
        echo "x86_64"
        "$1"
        ;;
    esac
}

versionDeb="$(lsb_release -c -s)"
versionKernel="$(uname -r)"

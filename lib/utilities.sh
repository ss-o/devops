#!/usr/bin/env bash
# ============================================================================= #
#  ➜ ➜ ➜ SS-O UTILITIES
# ============================================================================= #
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

# Do not allow to run as root
if [[ "$EUID" -eq 0 ]]; then
    printf "\033[1;101mPlease do not run this script as root (no su or sudo)! \033[0m \n"
    exit
fi

curr_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${curr_dir}/colors.sh"
source "${curr_dir}/versions.sh"
source "${curr_dir}/os.sh"

# ============================================================================= #
#  ➜ ➜ ➜ FUNCTIONS & UTILITIES
# ============================================================================= #
_cmd_() { command -v "$1" >/dev/null 2>&1; }
_exec_() { type -fP "$1" >/dev/null 2>&1; }
_miss_dir() { [[ ! -d "$1" ]] && mkdir -p "$1"; }
_execroot() { [[ "$(whoami)" != "root" ]] && exec sudo -- "$0" "$@"; }

_date() { date "+%d-%m-%Y"; }
_time() { date "+%H-%M-%S"; }

title() {
    printf "${On_Blue}"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ' '
    printf '%-*s\n' "${COLUMNS:-$(tput cols)}" "  # $1" | tr ' ' ' '
    printf '%*s' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ' '
    printf "${BBlack}"
    printf "\n"
}

breakLine() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    sleep .5
}

### Prints a block of indented text.
#   $1=[string] - text to print
#   $2=[int] - indent length (default=4)
#   $3=[int] - indent length of first line (default=$2)
printb() {
    local int_indent_block=${2:-4}
    local int_indent_line=${3:-${int_indent_block}}
    local int_line=$(($(tput cols) - ${int_indent_block}))
    local IFS=$'\n'
    for line in $(printf "$1\n" | fold -s -w ${int_line}); do
        if [ ${int_indent_line} -gt 0 ]; then
            printf "%-${int_indent_line}s" " "
        fi
        printf "${line}\n"
        int_indent_line=${int_indent_block}
    done
}

printHeader() { echo -e "${BBlue}" "$@" "${NC}"; }
printSubhead() { echo -e "${Blue}" "$@" "${NC}"; }
printBtext() { echo -e "${BWhite}" "$@" "${NC}"; }
printText() { echo -e "${White}" "$@" "${NC}"; }

draw_cc() {
    for cc in 90 31 91 32 33 34 35 95 36 97; do
        echo -en "\r \e[${c}m "$1" \e[0m "
        sleep 1
    done
}

notify() {
    printf "\n"
    printf "${On_Red} %s ${BWhite}" "$1"
    printf "\n"
}

### Download show progress bar only
wgetShowProgress() {
    wget "${1}" --quiet --show-progress
}

### Download with curl
curlToFile() {
    notify "Downloading: $1 ----> $2"
    sudo curl -fSL "$1" -o "$2"
}

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

### Ask confirmation (Yes/No)
_ask_confirm() {
    unset CONFIRM
    COUNT=$((${#1} + 6))
    until [[ ${CONFIRM} =~ ^(y|n|Y|N|yes|no|Yes|No|YES|NO)$ ]]; do
        echo -ne "${On_Green}${1} ${Red}[y/n]\n"
        for ((CHAR = 1; CHAR <= COUNT; CHAR++)); do echo -ne "-"; done
        echo -ne "\n${NC}"
        read -r CONFIRM
    done
}

apt-get-update-if-needed() {
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        sudo apt-get update -y
    else
        echo "Skipping apt-get update."
    fi
}

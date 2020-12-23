#!/usr/bin/env bash
#TODO: # Cleanup dotfiles. Create welcome script on login

#set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

#Relative Paths from Script Instead of Invocation Directory
#To change to a relative path from a script's location,
#rather than the current working directory.
# Using /usr/bin/dirname.
#export SRC_DIR=$(cd "$(dirname "$0")/.."; pwd)
# Using the "remove matching suffix pattern" parameter expansion.
#export SRC_DIR=$(cd "${0%/*}/.."; pwd)
# ============================================================================= #
#  ➜ ➜ ➜ SS-O UTILITIES
# ============================================================================= #
curr_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$curr_dir/colors.sh"
source "$curr_dir/visual.sh"
source "$curr_dir/versions.sh"
source "$curr_dir/os.sh"

# ============================================================================= #
#  ➜ ➜ ➜ FUNCTIONS & UTILITIES
# ============================================================================= #
# Do not allow to run as root
dont_allow_root() {
    if [[ "$EUID" -eq 0 ]]; then
        printf "${On_Red}Please do not run this script as root (no su or sudo)! ${NC}"
        exit 1
    fi
}

# Check is current user is root
if_is_root() {
    if [ "$(id -u)" -ne 0 ]; then
        printf "You must be root user to continue"
        exit 1
    fi

    RID=$(id -u root 2>/dev/null)
    if [ $? -ne 0 ]; then
        Error "User root no found. You should create it to continue"
        exit 1
    fi
    if [ "$RID" -ne 0 ]; then
        Error "User root UID not equals 0. User root must have UID 0"
        exit 1
    fi
}

_cmd_() { command -v "$1" >/dev/null 2>&1; }
_exec_() { type -fP "$1" >/dev/null 2>&1; }
_miss_dir() { [[ ! -d "$1" ]] && mkdir -p "$1"; }
_execroot() { [[ "$(whoami)" != "root" ]] && exec sudo -- "$0" "$@"; }

_reload_bashrc() { cd ${HOME} && source .bashrc && cd - >/dev/null 2>&1; }
_reload_zshrc() { cd ${HOME} && source .bashrc && cd - >/dev/null 2>&1; }

_date() { date "+%d-%m-%Y"; }
_time() { date "+%H-%M-%S"; }

title() {
    printf "${On_LGreen}"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ' '
    printf '%-*s\n' "${COLUMNS:-$(tput cols)}" "  # $1" | tr ' ' ' '
    printf '%*s' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ' '
    printf "${NC}"
    printf "\n"
}

printHeader() { echo -e "${BBlue}" "$@" "${NC}"; }
printSubhead() { echo -e "${Blue}" "$@" "${NC}"; }
printBtext() { echo -e "${BWhite}" "$@" "${NC}"; }
printText() { echo -e "${White}" "$@" "${NC}"; }

draw_c() {
for c in 90 31 91 32 33 34 35 95 36 97; do
    echo -en "\r \e[${c}m "$1" \e[0m "
done
}

notify() {
    printf "\n"
    printf "${On_IRed} %s ${NC}\n" "$1"
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

git_strap() {
    local repo="$1"
    local dest="$2"
    local name=''
    name=$(basename "$repo")
    if [ ! -d "$dest/.git" ]; then
        log_info "Installing $name..."
        #    mkdir -p "$dest"
        git clone --depth 1 "$repo" "$dest"
    else
        log_info "Pulling $name..."
        (
            builtin cd "$dest" && git pull --depth 1 --rebase origin "$(git symbolic-ref refs/remotes/origin/HEAD | awk -F'[/]' '{print $NF}')" ||
                log_warn "Exec in compatibility mode [git pull --rebase]" &&
                builtin cd "$dest" && git fetch --unshallow && git rebase origin/"$(git symbolic-ref refs/remotes/origin/HEAD | awk -F'[/]' '{print $NF}')"
        )
    fi
}

link_file() {
    local src="$1" dst="$2"
    local overwrite='' backup='' skip=''
    local action=''
    if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then
        if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
            local currentSrc="$(readlink "$dst")"
            echo
            show_header "File $dst ($(basename "$src")) already exists, what do you want to do?"
            show_msg "[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
            echo
            read -n 1 action
            case "$action" in
            o)
                overwrite=true
                ;;
            O)
                overwrite_all=true
                ;;
            b)
                backup=true
                ;;
            B)
                backup_all=true
                ;;
            s)
                skip=true
                ;;
            S)
                skip_all=true
                ;;
            *) ;;

            esac
        fi
        overwrite=${overwrite:-$overwrite_all}
        backup=${backup:-$backup_all}
        skip=${skip:-$skip_all}
        if [ "$overwrite" == "true" ]; then
            clear
            rm -rf "$dst" && log_info "Removed $dst"
            sleep 1
        fi
        if [ "$backup" == "true" ]; then
            clear
            mv "$dst" "${dst}.backup" && log_info "Backup made - ${dst}.backup"
            sleep 1
        fi
        if [ "$skip" == "true" ]; then
            clear
            log_info "Skipped $src"
            sleep 1
        fi
    fi
    if [ "$skip" != "true" ]; then # "false" or empty
        clear
        ln -fs "$1" "$2" && log_ok "Linked $1 to $2"
        sleep 1
    fi
}

check_dependencies() {
    if _exec_ git; then
        return
    else
        log_warn "Missing git" && exit
    fi
    if _exec_ zsh; then
        return
    else
        log_warn "Missing zsh" && exit
    fi
    if _exec_ bash; then
        return
    else
        log_warn "Missing bash" && exit
    fi
    if _exec_ python; then
        return
    else
        log_warn "Missing python" && exit
    fi
}

check_dotfiles_dir() {
    if [ ! -d "$HOME/.dotfiles" ]; then
        git_strap "$DOTSRC" "$DOTFILES" || log_error "Something went wrong"
        cd "${DOTFILES}"
    fi
}

### Download show progress bar only
wgetBar() {
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

install-deps-apt() {
    apt-get-update-if-needed
    sudo apt-get install -y apt-utils aptitude \
        profile-sync-daemon git build-essential \
        gvfs-bin cmake make gcc g++ openssh-client gnupg2 \
        iproute2 procps lsof htop net-tools psmisc \
        curl wget rsync ca-certificates unzip zip nano vim-tiny \
        less jq lsb-release apt-transport-https dialog \
        libc6 libgcc1 libgssapi-krb5-2 libicu[0-9][0-9] \
        liblttng-ust0 libstdc++6 \
        zlib1g locales sudo ncdu man-db strace
}

_apt_() {
    if dpkg -s "$1" &>/dev/null; then
        sudo apt-get install -y "$1"
    fi
}

install-deps-pacman() {
    sudo pacman -Syy
    sudo pacman -S base base-devel unrar hugo ethtool \
        debootstrap devscripts oath-toolkit imagemagick profile-sync-daemon \
        pkgfile dconf-editor rsync debian-archive-keyring \
        nmap htop gvfs p7zip lzop arch-install-scripts curl \
        llvm llvm-libs lldb tree shellcheck bash-completion \
        cmatrix mlocate pacman-contrib x11-ssh-askpass \
        sshfs packer lsof mkcert
}
_pacman_() {
    if pacman -Qi "$1" &>/dev/null; then
        sudo pacman -S "$1" --noconfirm --needed
    fi
}

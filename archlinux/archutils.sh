# Print package description from the AUR.
aur_pkg_info() {
    # main variables
    local str_description=
    # get description from AUR
    str_aur_description=$(curl -s \
        "https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=$1" |
        grep --color=never -oP \
            'pkgdesc.*(quot|apos);\K.*(?=&(quot|apos);)')
    # if package exists in AUR; then
    if [ $? -eq 0 ]; then
        printf "${clr_Cyan}$1 (AUR) ${clr_white}"
        printf "${str_aur_description}\n"
    # if package does not exist in AUR; then
    else
        printf "${ps_error}no such package or group: "
        printf "${clr_Red}$1\n"
    fi
}

# Print package or package group description from official repos.
official_pkg_info() {
    # main variables
    local str_description=
    local lst_pkgs=
    local pkg=
    # if argument given; then
    if [ ! -z "$1" ]; then
        # get description from Official repositories
        str_description=$(pacman -Si $1 2>/dev/null |
            grep --color=never -Po "Description     : \K.*")
        # if package exists in Official repositories; then
        if [ $? -eq 0 ]; then
            printf "${clr_Cyan}$1 ${clr_white}${str_description}\n"
        # if no package description exists in the repositories; then
        else
            # get package group listing from Official repositories
            lst_pkgs=$(pacman -Sgqg $1 2>/dev/null)
            # if package group exists in the repositories; then
            if [ $? -eq 0 ]; then
                printf "${clr_CyanB}$1 ${clr_whiteB}(group):\n"
                # call pacman -Si for each package in group
                local IFS=$'\n'
                for pkg in $(pacman -Sgqg $1); do
                    str_description=$(pacman -Si ${pkg} 2>/dev/null |
                        grep --color=never -Po "Description     : \K.*")
                    printf "${clr_Cyan}${pkg} ${clr_white}${str_description}\n"
                done
            # if package group does not exist in official repositories; then
            else
                printf "${ps_error}No such package or group in Arch Linux "
                printf "official repositories: ${clr_Red}$1\n"
            fi
        fi
    fi
}

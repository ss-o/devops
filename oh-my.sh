#!/usr/bin/bash

install-oh-my()
{
    local OH_MY=bash
    local OH_MY_INSTALL_DIR="$HOME/.oh-my-${OH_MY}"
    local TEMPLATE="${OH_MY_INSTALL_DIR}/templates/$2"
    local OH_MY_GIT_URL=$3
    local USER_RC_FILE="${USER_RC_PATH}/.${OH_MY}rc"

    if [ -d "${OH_MY_INSTALL_DIR}" ] || [ "${INSTALL_OH_MYS}" != "true" ]; then
        return 0
    fi

    umask g-w,o-w
    mkdir -p ${OH_MY_INSTALL_DIR}
    git clone --depth=1 \
        -c core.eol=lf \
        -c core.autocrlf=false \
        -c fsck.zeroPaddedFilemode=ignore \
        -c fetch.fsck.zeroPaddedFilemode=ignore \
        -c receive.fsck.zeroPaddedFilemode=ignore \
        ${OH_MY_GIT_URL} ${OH_MY_INSTALL_DIR} 2>&1
    echo -e "$(cat "${TEMPLATE}")\nDISABLE_AUTO_UPDATE=true\nDISABLE_UPDATE_PROMPT=true" > ${USER_RC_FILE}
    if [ "${OH_MY}" = "bash" ]; then
        sed -i -e 's/OSH_THEME=.*/OSH_THEME="codespaces"/g' ${USER_RC_FILE}
        mkdir -p ${OH_MY_INSTALL_DIR}/custom/themes/codespaces
        echo "${CODESPACES_BASH}" > ${OH_MY_INSTALL_DIR}/custom/themes/codespaces/codespaces.theme.sh
    else
        sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="codespaces"/g' ${USER_RC_FILE}
        mkdir -p ${OH_MY_INSTALL_DIR}/custom/themes
        echo "${CODESPACES_ZSH}" > ${OH_MY_INSTALL_DIR}/custom/themes/codespaces.zsh-theme
    fi
    # Shrink git while still enabling updates
    cd ${OH_MY_INSTALL_DIR} 
    git repack -a -d -f --depth=1 --window=1

    if [ "${USERNAME}" != "root" ]; then
        cp -rf ${USER_RC_FILE} ${OH_MY_INSTALL_DIR} /root
        chown -R ${USERNAME}:${USERNAME} ${USER_RC_PATH}
    fi
}

if [ "${RC_SNIPPET_ALREADY_ADDED}" != "true" ]; then
    echo "${RC_SNIPPET}" >> /etc/bash.bashrc
    RC_SNIPPET_ALREADY_ADDED="true"
fi
install-oh-my bash bashrc.osh-template https://github.com/ohmybash/oh-my-bash

# Optionally install and configure zsh and Oh My Zsh!
if [ "${INSTALL_ZSH}" = "true" ]; then
    if ! type zsh > /dev/null 2>&1; then
        apt-get-update-if-needed
        apt-get install -y zsh
    fi
    if [ "${ZSH_ALREADY_INSTALLED}" != "true" ]; then
        echo "${RC_SNIPPET}" >> /etc/zsh/zshrc
        ZSH_ALREADY_INSTALLED="true"
    fi
    install-oh-my zsh zshrc.zsh-template https://github.com/ohmyzsh/ohmyzsh
fi
install-oh-my

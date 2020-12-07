#!/usr/bin/env bash

###############################################################
## REPOSITORIES
###############################################################

# PHP
##########################################################
repoPhp() {
    if [[ ! -f /etc/apt/sources.list.d/php.list ]]; then
        notify "Adding PHP sury repository"
        curl -fsSL "https://packages.sury.org/php/apt.gpg" | sudo apt-key add -
        echo "deb https://packages.sury.org/php/ ${versionDeb} main" | sudo tee /etc/apt/sources.list.d/php.list
    fi
}

# Yarn
##########################################################
repoYarn() {
    if [[ ! -f /etc/apt/sources.list.d/yarn.list ]]; then
        notify "Adding Yarn repository"
        curl -fsSL "https://dl.yarnpkg.com/debian/pubkey.gpg" | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    fi
}

# Docker CE
##########################################################
repoDocker() {
    if [[ ! -f /var/lib/dpkg/info/docker-ce.list ]]; then
        notify "Adding Docker repository"
        curl -fsSL "https://download.docker.com/linux/debian/gpg" | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    fi
}

# Kubernetes
##########################################################
repoKubernetes() {
    if [[ ! -f /etc/apt/sources.list.d/kubernetes.list ]]; then
        notify "Adding Kubernetes repository"
        curl -fsSL "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | sudo apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    fi
}

# Wine
##########################################################
repoWine() {
    if [[ ! -f /var/lib/dpkg/info/wine-stable.list ]]; then
        notify "Adding Wine repository"
        sudo dpkg --add-architecture i386
        curl -fsSL "https://dl.winehq.org/wine-builds/winehq.key" | sudo apt-key add -
        curl -fsSL "https://dl.winehq.org/wine-builds/Release.key" | sudo apt-key add -
        sudo apt-add-repository "https://dl.winehq.org/wine-builds/debian/"
    fi
}

# Atom
##########################################################
repoAtom() {
    if [[ ! -f /etc/apt/sources.list.d/atom.list ]]; then
        notify "Adding Atom IDE repository"
        curl -fsSL "https://packagecloud.io/AtomEditor/atom/gpgkey" | sudo apt-key add -
        echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" | sudo tee /etc/apt/sources.list.d/atom.list
    fi
}

# VS Code
##########################################################
repoVsCode() {
    if [[ ! -f /etc/apt/sources.list.d/vscode.list ]]; then
        notify "Adding VSCode repository"
        curl "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor >microsoft.gpg
        sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
        echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    fi
}

# Sublime
##########################################################
repoSublime() {
    if [[ ! -f /etc/apt/sources.list.d/sublime-text.list ]]; then
        notify "Adding Sublime Text repository"
        curl -fsSL "https://download.sublimetext.com/sublimehq-pub.gpg" | sudo apt-key add -
        echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    fi
}

# Remmina
##########################################################
repoRemmina() {
    if [[ ! -f /etc/apt/sources.list.d/remmina.list ]]; then
        notify "Adding Remmina repository"
        sudo touch /etc/apt/sources.list.d/remmina.list
        echo "deb http://ftp.debian.org/debian ${versionDeb}-backports main" | sudo tee --append "/etc/apt/sources.list.d/${versionDeb}-backports.list" >>/dev/null
    fi
}

# Google Cloud SDK
##########################################################
repoGoogleSdk() {
    if [[ ! -f /etc/apt/sources.list.d/google-cloud-sdk.list ]]; then
        notify "Adding GCE repository"
        CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
        export CLOUD_SDK_REPO
        echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
        curl -fsSL "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | sudo apt-key add -
    fi
}

# VLC
##########################################################
repoVlc() {
    if [[ ! -f /etc/apt/sources.list.d/videolan-ubuntu-stable-daily-disco.list ]]; then
        notify "Adding VLC repository"
        sudo add-apt-repository ppa:videolan/stable-daily -y
    fi
}

# MySQL Community Server
##########################################################
repoMySqlServer() {
    if [[ ! -f /var/lib/dpkg/info/mysql-apt-config.list ]]; then
        notify "Adding MySQL Community Server repository"
        curlToFile "https://dev.mysql.com/get/mysql-apt-config_0.8.11-1_all.deb" "mysql.deb"
        sudo dpkg -i mysql.deb
        rm mysql.deb -f
    fi
}
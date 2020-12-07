#!/usr/bin/env bash
# Disallow running with sudo or su
##########################################################
if [[ "$EUID" -eq 0 ]]; then
    printf "\033[1;101mNein, Nein, Nein!! Please do not run this script as root (no su or sudo)! \033[0m \n"
    exit
fi

sudo apt install -y lsb-release
versionDeb="$(lsb_release -c -s)"
if [[ ${versionDeb} != "stretch" ]] && [[ ${versionDeb} != "buster" ]]; then
    printf "\033[1;101mUnfortunatly your OS Version (%s) is not supported. \033[0m \n" "${versionDeb}"
    exit
fi

###############################################################
## HELPERS
###############################################################
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

###############################################################
## INSTALLATION
###############################################################

# Debian Software Center
installSoftwareCenter() {
    sudo apt install -y gnome-software gnome-packagekit
}

# Git
##########################################################
installGit() {
    title "Installing Git"
    sudo apt install -y git
    breakLine
}

# Node
##########################################################
installNode() {
    title "Installing Node ${versionNode}"
    curl -L "https://deb.nodesource.com/setup_${versionNode}.x" | sudo -E bash -
    sudo apt install -y nodejs npm

    if [[ ${versionDeb} = "stretch" ]]; then
        sudo chown -R "$(whoami)" /usr/lib/node_modules
        sudo chmod -R 777 /usr/lib/node_modules
    fi

    if [[ ${versionDeb} = "buster" ]]; then
        sudo chown -R "$(whoami)" /usr/share/npm/node_modules
        sudo chmod -R 777 /usr/share/npm/node_modules
    fi

    installedNode=1
    breakLine
}

# React Native
##########################################################
installReactNative() {
    title "Installing React Native"
    sudo npm install -g create-react-native-app
    breakLine
}

# Cordova
##########################################################
installCordova() {
    title "Installing Apache Cordova"
    sudo npm install -g cordova
    breakLine
}

# Phonegap
##########################################################
installPhoneGap() {
    title "Installing Phone Gap"
    sudo npm install -g phonegap
    breakLine
}

# Webpack
##########################################################
installWebpack() {
    title "Installing Webpack"
    sudo npm install -g webpack
    breakLine
}

# PHP
##########################################################
installPhp() {
    title "Installing PHP ${versionPhp}"
    sudo apt install -y php${versionPhp} php${versionPhp}-{bcmath,cli,common,curl,dev,gd,intl,mbstring,mysql,sqlite3,xml,zip} php-pear php-memcached php-redis
    sudo apt install -y libphp-predis php-xdebug php-ds
    php --version

    sudo pecl install igbinary ds
    installedPhp=1
    breakLine
}

# Ruby
##########################################################
installRuby() {
    title "Installing Ruby with DAPP v${versionDapp}"
    sudo apt install -y ruby-dev gcc pkg-config
    sudo gem install mixlib-cli -v 1.7.0
    sudo gem install dapp -v ${versionDapp}
    breakLine
}

# Python
##########################################################
installPython() {
    title "Installing Python3 with PIP"
    sudo apt install -y build-essential libssl-dev libffi-dev python-dev python3-pip
    sudo ln -s /usr/bin/pip3 /usr/bin/pip
    export PATH=/usr/local/bin/python:$PATH

    installedPython=1
    breakLine
}

# GoLang
##########################################################
installGoLang() {
    title "Installing GoLang ${versionGo}"
    curlToFile "https://dl.google.com/go/go${versionGo}.linux-amd64.tar.gz" "go.tar.gz"
    tar xvf go.tar.gz

    if [[ -d /usr/local/go ]]; then
        sudo rm -rf /usr/local/go
    fi

    sudo mv go /usr/local
    rm go.tar.gz -f

    {
        echo -e "export GOROOT=\"/usr/local/go\"" \
            "\nexport GOPATH=\"$HOME/go\"" \
            "\nexport PATH=\"$PATH:/usr/local/go/bin:$GOPATH/bin\""
    } >>~/.bashrc

    # shellcheck source=/dev/null
    source ~/.bashrc
    mkdir "${GOPATH}"
    sudo chown -R root:root "${GOPATH}"

    installedGo=1
    breakLine
}

# Yarn
##########################################################
installYarn() {
    title "Installing Yarn"
    sudo apt install -y yarn
    breakLine
}

# Memcached
##########################################################
installMemcached() {
    title "Installing Memcached"
    sudo apt install -y memcached
    sudo systemctl start memcached
    sudo systemctl enable memcached
    breakLine
}

# Redis
##########################################################
installRedis() {
    title "Installing Redis"
    sudo apt install -y redis-server
    sudo systemctl start redis
    sudo systemctl enable redis
    breakLine
}

# Composer
##########################################################
installComposer() {
    title "Installing Composer"
    php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
    sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
    sudo rm /tmp/composer-setup.php
    breakLine
}

# Laravel Installer
##########################################################
installLaravel() {
    title "Installing Laravel Installer"
    composer global require "laravel/installer"
    echo "export PATH=\"$PATH:$HOME/.config/composer/vendor/bin\"" | tee -a ~/.bashrc
    breakLine
}

# SQLite Browser
##########################################################
installSqLite() {
    title "Installing SQLite Browser"
    sudo apt install -y sqlitebrowser
    breakLine
}

# DBeaver
##########################################################
installDbeaver() {
    title "Installing DBeaver SQL Client"
    curlToFile "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb" "dbeaver.deb"
    sudo apt install -y -f ~/dbeaver.deb
    sudo rm ~/dbeaver.deb
    breakLine
}

# Redis Desktop Manager
##########################################################
installRedisDesktopManager() {
    title "Installing Redis Desktop Manager"
    sudo snap install redis-desktop-manager
    breakLine
}

# Docker
##########################################################
installDocker() {
    title "Installing Docker CE with Docker Compose"
    sudo apt install -y docker-ce
    curlToFile "https://github.com/docker/compose/releases/download/${versionDockerCompose}/docker-compose-$(uname -s)-$(uname -m)" "/usr/local/bin/docker-compose"
    sudo chmod +x /usr/local/bin/docker-compose

    sudo groupadd docker
    sudo usermod -aG docker "${USER}"

    notify "Install a separate runc environment? (recommended on chromebooks)"

    while true; do
        read -p -r "(y/n)" yn
        case ${yn} in
        [Yy]*)
            if [[ ${installedGo} -ne 1 ]] && [[ "$(command -v go)" == '' ]]; then
                breakLine
                installGoLang
            fi

            sudo sed -i -e 's/ExecStartPre=\/sbin\/modprobe overlay/#ExecStartPre=\/sbin\/modprobe overlay/g' /lib/systemd/system/containerd.service

            sudo apt install libseccomp-dev -y
            go get -v github.com/opencontainers/runc

            cd "${GOPATH}/src/github.com/opencontainers/runc" || exit
            make BUILDTAGS='seccomp apparmor'

            sudo cp "${GOPATH}/src/github.com/opencontainers/runc/runc" /usr/local/bin/runc-master

            curlToFile "${repoUrl}docker/daemon.json" /etc/docker/daemon.json
            sudo systemctl daemon-reload
            sudo systemctl restart containerd.service
            sudo systemctl restart docker
            break
            ;;
        [Nn]*) break ;;
        *) echo "Please answer yes or no." ;;
        esac
    done

    breakLine
}

# Kubernetes
##########################################################
installKubernetes() {
    title "Installing Kubernetes"
    sudo apt install -y kubectl
    breakLine
}

# Helm
##########################################################
installHelm() {
    title "Installing Helm v${versionHelm}"
    curl -fsSl "https://storage.googleapis.com/kubernetes-helm/helm-v${versionHelm}-linux-amd64.tar.gz" -o helm.tar.gz
    tar -zxvf helm.tar.gz
    sudo mv linux-amd64/helm /usr/local/bin/helm
    sudo rm -rf linux-amd64 && sudo rm helm.tar.gz
    breakLine
}

# Sops
##########################################################
installSops() {
    title "Installing Sops v${versionSops}"
    wget -O sops_${versionSops}_amd64.deb "https://github.com/mozilla/sops/releases/download/${versionSops}/sops_${versionSops}_amd64.deb"
    sudo dpkg -i sops_${versionSops}_amd64.deb
    sudo rm sops_${versionSops}_amd64.deb
    breakLine
}

# Wine
##########################################################
installWine() {
    title "Installing Wine & Mono"
    sudo apt install -y cabextract
    sudo apt install -y --install-recommends winehq-stable
    sudo apt install -y mono-vbnc winbind

    notify "Installing WineTricks"
    curlToFile "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" "winetricks"
    sudo chmod +x ~/winetricks
    sudo mv ~/winetricks /usr/local/bin

    notify "Installing Windows Fonts"
    winetricks allfonts

    notify "Installing Smooth Fonts for Wine"
    curlToFile ${repoUrl}"wine_fontsmoothing.sh" "wine_fontsmoothing"
    sudo chmod +x ~/wine_fontsmoothing
    sudo ./wine_fontsmoothing
    clear

    notify "Installing Royale 2007 Theme"
    curlToFile "http://www.gratos.be/wincustomize/compressed/Royale_2007_for_XP_by_Baal_wa_astarte.zip" "Royale_2007.zip"

    sudo chown -R "$(whoami)" ~/
    mkdir -p ~/.wine/drive_c/Resources/Themes/
    unzip ~/Royale_2007.zip -d ~/.wine/drive_c/Resources/Themes/

    notify "Cleaning up..."
    rm ~/wine_fontsmoothing -f
    rm ~/Royale_2007.zip -f
}

# Postman
##########################################################
installPostman() {
    title "Installing Postman"
    curlToFile "https://dl.pstmn.io/download/latest/linux64" "postman.tar.gz"
    sudo tar xfz ~/postman.tar.gz

    sudo rm -rf /opt/postman/
    sudo mkdir /opt/postman/
    sudo mv ~/Postman*/* /opt/postman/
    sudo rm -rf ~/Postman*
    sudo rm -rf ~/postman.tar.gz
    sudo ln -s /opt/postman/Postman /usr/bin/postman

    notify "Adding desktop file for Postman"
    curlToFile ${repoUrl}"desktop/postman.desktop" "/usr/share/applications/postman.desktop"
    breakLine
}

# Atom IDE
##########################################################
installAtom() {
    title "Installing Atom IDE"
    sudo apt install -y atom
    breakLine
}

# VS Code
##########################################################
installVsCode() {
    title "Installing VS Code IDE"
    sudo apt install -y code
    breakLine
}

# Sublime Text
##########################################################
installSublime() {
    title "Installing Sublime Text"
    sudo apt install -y sublime-text
    sudo pip install -U CodeIntel

    sudo chown -R "$(whoami)" ~/

    mkdir -p ~/.config/sublime-text-3/Packages/User

    notify "Adding package control for sublime"
    wget "https://packagecontrol.io/Package%20Control.sublime-package" -o ".config/sublime-text-3/Installed Packages/Package Control.sublime-package"

    notify "Adding pre-installed packages for sublime"
    curlToFile "${repoUrl}settings/PackageControl.sublime-settings" ".config/sublime-text-3/Packages/User/Package Control.sublime-settings"

    notify "Applying default preferences to sublime"
    curlToFile "${repoUrl}settings/Preferences.sublime-settings" ".config/sublime-text-3/Packages/User/Preferences.sublime-settings"

    notify "Installing additional binaries for sublime auto-complete"
    curlToFile "https://github.com/emmetio/pyv8-binaries/raw/master/pyv8-linux64-p3.zip" "bin.zip"

    sudo mkdir -p ".config/sublime-text-3/Installed Packages/PyV8/"
    sudo unzip ~/bin.zip -d ".config/sublime-text-3/Installed Packages/PyV8/"
    sudo rm ~/bin.zip

    installedSublime=1
    breakLine
}

# PHP Storm
##########################################################
installPhpStorm() {
    title "Installing PhpStorm IDE ${versionPhpStorm}"
    curlToFile "https://download.jetbrains.com/webide/PhpStorm-${versionPhpStorm}.tar.gz" "phpstorm.tar.gz"
    sudo tar xfz ~/phpstorm.tar.gz

    sudo rm -rf /opt/phpstorm/
    sudo mkdir /opt/phpstorm/
    sudo mv ~/PhpStorm-*/* /opt/phpstorm/
    sudo rm -rf ~/phpstorm.tar.gz
    sudo rm -rf ~/PhpStorm-*

    notify "Adding desktop file for PhpStorm"
    curlToFile ${repoUrl}"desktop/jetbrains-phpstorm.desktop" "/usr/share/applications/jetbrains-phpstorm.desktop"
    breakLine
}

# Remmina
##########################################################
installRemmina() {
    title "Installing Remmina Client"
    sudo apt install -t "${versionDeb}-backports" remmina remmina-plugin-rdp remmina-plugin-secret -y
    breakLine
}

# Google Cloud SDK
##########################################################
installGoogleSdk() {
    title "Installing Google Cloud SDK"
    sudo apt install -y google-cloud-sdk
    breakLine
}

# Popcorn Time
##########################################################
installPopcorn() {
    title "Installing Popcorn Time v${versionPopcorn}"
    sudo apt install -y libnss3 vlc

    if [[ -d /opt/popcorn-time ]]; then
        sudo rm -rf /opt/popcorn-time
    fi

    curlToFile "https://github.com/popcorn-official/popcorn-desktop/releases/download/v${versionPopcorn}/Popcorn-Time-${versionPopcorn}-amd64.deb" 'popcorn.deb'
    sudo apt install ./popcorn.deb
    rm -f popcorn.deb
    breakLine
}

# ZSH
##########################################################
installZsh() {
    title "Installing ZSH Terminal Plugin"
    sudo apt install -y zsh fonts-powerline
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    if [[ -f "${HOME}/.zshrc" ]]; then
        sudo mv "${HOME}/.zshrc" "${HOME}/.zshrc.bak"
    fi

    if [[ -f "${HOME}/.oh-my-zsh/themes/agnoster.zsh-theme" ]]; then
        sudo mv "${HOME}/.oh-my-zsh/themes/agnoster.zsh-theme" "${HOME}/.oh-my-zsh/themes/agnoster.zsh-theme.bak"
    fi

    echo '/bin/zsh' >>~/.bashrc
    sudo chsh -s $(which zsh) $(whoami)

    installedZsh=1
    breakLine
}

# MySql Community Server
##########################################################
installMySqlServer() {
    title "Installing MySql Community Server"
    sudo apt install -y mysql-server
    sudo systemctl enable mysql
    sudo systemctl start mysql

    installedMySqlServer=1
    breakLine
}

# Locust
##########################################################
installLocust() {
    title "Installing Locust"
    sudo pip3 install locust
    breakLine
}

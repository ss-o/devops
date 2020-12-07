dev_dependencies() {
    sudo apt install -y software-properties-common apt-transport-https build-essential \
        checkinstall libreadline-gplv2-dev libxssl libncursesw5-dev libssl-dev libsqlite3-dev \
        tk-dev libgdbm-dev libc6-dev libbz2-dev autoconf automake libtool make g++ unzip flex bison gcc \
        libssl-dev libyaml-dev libreadline6-dev zlib1g zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev \
        libpq-dev libpcap-dev libmagickwand-dev libappindicator3-1 libindicator3-7 imagemagick xdg-utils
}

update_upgrade() {
    sudo apt update && sudo apt upgrade -y
    sudo apt --fix-broken install -y
}

install_snap() {
    #Snap Installation & Setup
    sudo apt install -y snapd
    sudo systemctl start snapd
    sudo systemctl enable snapd
    sudo systemctl start apparmor
    sudo systemctl enable apparmor
    export PATH=$PATH:/snap/bin
    sudo snap refresh
}

install_curl-wget() {
    sudo apt-get install -y wget curl
}

install_golang() {
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt update
    sudo apt install golang-go
}

install_git() {
    apt-get install software-properties-common python-software-properties
add-apt-repository ppa:git-core/ppa
apt-get install
apt-get install git -y
}
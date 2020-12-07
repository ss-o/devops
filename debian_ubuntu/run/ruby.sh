
# Ruby
##########################################################
installRuby() {
    title "Installing Ruby with DAPP v${versionDapp}"
    sudo apt install -y ruby-dev gcc pkg-config
    sudo gem install mixlib-cli -v 1.7.0
    sudo gem install dapp -v ${versionDapp}
    breakLine
}
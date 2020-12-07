# Memcached
##########################################################
installMemcached() {
    title "Installing Memcached"
    sudo apt install -y memcached
    sudo systemctl start memcached
    sudo systemctl enable memcached
    breakLine
}
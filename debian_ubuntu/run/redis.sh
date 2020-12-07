# Redis
##########################################################
installRedis() {
    title "Installing Redis"
    sudo apt install -y redis-server
    sudo systemctl start redis
    sudo systemctl enable redis
    breakLine
}
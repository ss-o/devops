# Installation of Docker Community Edition
if ! which docker > /dev/null; then
    echo "Installing docker"
    execute wget get.docker.com -O dockerInstall.sh
    execute chmod +x dockerInstall.sh
    execute ./dockerInstall.sh
    execute rm dockerInstall.sh
    # Adds user to the `docker` group so that docker commands can be run without sudo
    execute sudo usermod -aG docker ${USER}
fi

# Install Docker CLI if not already installed
#if type docker > /dev/null 2>&1; then
#    echo "Docker CLI already installed."
#else
#    curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | (OUT=$(apt-key add - 2>&1) || echo $OUT)
#    echo "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
#    apt-get update
#    apt-get -y install --no-install-recommends docker-ce-cli
#fi
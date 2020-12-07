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
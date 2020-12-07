# Laravel Installer
##########################################################
installLaravel() {
    title "Installing Laravel Installer"
    composer global require "laravel/installer"
    echo "export PATH=\"$PATH:$HOME/.config/composer/vendor/bin\"" | tee -a ~/.bashrc
    breakLine
}
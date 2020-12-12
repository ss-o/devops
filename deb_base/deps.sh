#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/../utils.sh"

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Function to call apt-get if needed
apt-get-update-if-needed() {
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update
    else
        echo "Skipping apt-get update."
    fi
}

install-deps() {

    apt-get-update-if-needed

    PACKAGE_LIST="apt-utils \
    shellcheck \
    sshfs \
    profile-sync-daemon"
}
install-deps

# Install libssl1.1 if available
if [[ ! -z $(apt-cache --names-only search ^libssl1.1$) ]]; then
    PACKAGE_LIST="${PACKAGE_LIST}       libssl1.1"
fi

# Install appropriate version of libssl1.0.x if available
LIBSSL=$(dpkg-query -f '${db:Status-Abbrev}\t${binary:Package}\n' -W 'libssl1\.0\.?' 2>&1 || echo '')
if [ "$(echo "$LIBSSL" | grep -o 'libssl1\.0\.[0-9]:' | uniq | sort | wc -l)" -eq 0 ]; then
    if [[ ! -z $(apt-cache --names-only search ^libssl1.0.2$) ]]; then
        # Debian 9
        PACKAGE_LIST="${PACKAGE_LIST}       libssl1.0.2"
    elif [[ ! -z $(apt-cache --names-only search ^libssl1.0.0$) ]]; then
        # Ubuntu 18.04, 16.04, earlier
        PACKAGE_LIST="${PACKAGE_LIST}       libssl1.0.0"
    fi
fi

echo "Packages to verify are installed: ${PACKAGE_LIST}"
sudo apt-get -y install --no-install-recommends ${PACKAGE_LIST} 2> >(grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2)

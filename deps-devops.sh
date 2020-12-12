#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

sudo apt install -y \
    software-properties-common \
    apt-transport-https \
    build-essential \
    checkinstall \
    libreadline-gplv2-dev \
    libxssl \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    autoconf \
    automake \
    libtool \
    make \
    g++ \
    unzip \
    flex \
    bison \
    gcc \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm5 \
    libgdbm-dev \
    libpq-dev \
    libpcap-dev \
    libmagickwand-dev \
    libappindicator3-1 \
    libindicator3-7 \
    imagemagick \
    xdg-utils

#!/usr/bin/python
# encoding: utf-8
# -*- coding: utf8 -*-

import os

CENTOS_RELEASE_FILE = "/etc/centos-release"
UBUNTU_RELEASE_FILE = "/etc/issue"

UBUNTU_SYSTEMD_RELEASE_FILE = "/etc/os-release"
CENTOS_SYSTEMD_RELEASE_FILE = UBUNTU_SYSTEMD_RELEASE_FILE


def is_ubuntu():
    if os.path.exists(UBUNTU_RELEASE_FILE):
        with open(UBUNTU_RELEASE_FILE, "r") as f:
            if "ubuntu" in f.readline().lower():
                return True
            else:
                return False


def is_ubuntu14():
    # last non-systemd version
    version = get_version_id(centos=False, get_major=True)
    if version:
        if int(version) <= 14:
            return True
        else:
            return False
    return False


def is_centos():
    if os.path.exists(CENTOS_RELEASE_FILE):
        return True
    else:
        return False


def is_centos6():
    # last no-systemd version
    version = get_version_id(centos=True, get_major=True)
    if version:
        if int(version) <= 6:
            return True
        else:
            return False
    return False


def get_version_id(centos=True, get_major=False):
    if centos and is_centos():
        if os.path.exists(CENTOS_RELEASE_FILE):
            with open(CENTOS_RELEASE_FILE, "r") as f:
                if get_major:
                    return f.readline().strip().split()[2].split(".")[0]
                else:
                    return f.readline().strip().split()[2]
    if not centos and is_ubuntu():
        if os.path.exists(UBUNTU_RELEASE_FILE):
            with open(UBUNTU_RELEASE_FILE, "r") as f:
                if get_major:
                    return f.readline().strip().split()[1].split(".")[0]
                else:
                    return f.readline().strip().split()[1]
    return ""


if __name__ == '__main__':
    print "** usage example **"
    print "Ubuntu" if is_ubuntu() else "",
    print "CentOS" if is_ubuntu() else "",
    print 14 if is_ubuntu() and is_ubuntu14() else "",
    print 16 if is_ubuntu() and not is_ubuntu14() else "",
    print 6 if is_centos() and is_centos6() else "",
    print 7 if is_centos() and not is_centos6() else "",

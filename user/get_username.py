#!/usr/bin/env python3
# encoding: utf-8
# -*- coding: utf8 -*-

import getpass


def get_system_username():
    """
    Return the current system user's username, or an empty string if the
    username could not be determined.
    """
    try:
        result = getpass.getuser()
    except (ImportError, KeyError):
        return ''
    return result


if __name__ == '__main__':
    print get_system_username()

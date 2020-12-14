# -*- coding: utf-8 -*-
import json
import time
import os

CLRF = '\r\n'
SERVER_STR = 'hpot/0.1.1'

MIMES = {
    'doc': 'application/msword',
    'exe': 'application/octet-stream',
    'pdf': 'application/pdf',
    'ppt': 'application/vnd.ms-powerpoint',
    'gz': 'application/x-gzip',
    'js': 'application/x-javascript',
    'bmp': 'image/bmp',
    'gif': 'image/gif',
    'jpe': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'jpg': 'image/jpeg',
    'svg': 'image/svg+xml',
    'ico': 'image/x-icon',
    'css': 'text/css',
    'htm': 'text/html',
    'html': 'text/html',
}

STATUS_MESSAGE = {
    100: '100 Continue',
    200: '200 OK',
    301: '301 Moved Permanently',
    304: '304 Not Modified',
    400: '400 Bad Request',
    403: '403 Forbidden',
    404: '404 Not Found',
    405: '405 Method Not Allowed',
    500: '500 Internal Server Error',
    502: '502 Bad Gateway',
    503: '503 Service Unavailable',
    504: '504 Gateway Time-out',
    505: '505 HTTP Version Not Supported'
}


def load_config(conf_file):
    with open(conf_file, 'r') as f:
        return json.loads(f.read())

CONFIG = load_config('config.json')


def dir_exist(path):
    return os.path.isdir(path)


def file_exist(path):
    return os.path.isfile(path)


def can_read(path):
    for i in oct(os.stat(path).st_mode)[-3:]:
        if int(i) >= 4:
            return True
    return False


def modified_time(path):
    return os.stat(path).st_mtime


def unix_time(t, fmt):
    return time.mktime(time.strptime(t, fmt))


def log_err(msg):
    print '[error] %s' % msg
    exit()

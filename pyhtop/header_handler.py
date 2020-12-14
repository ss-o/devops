# -*- coding: utf-8 -*-
from util import modified_time, unix_time


def host_handler(request, value):
    pass


def connection_handler(request, value):
    if value.lower() == 'keep-alive':
        request.keep_alive = True


def user_agent_handler(request, value):
    pass


def if_modified_since_handler(request, value):
    if not request.err:
        if modified_time(request.file_path) < unix_time(value, '%a, %d %b %Y %H:%M:%S GMT'):
            request.status = 304

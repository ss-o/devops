# -*- coding: utf-8 -*-

import time


class Request:
    file_no = 0
    http_message = b''
    response_message = b''
    response_done = False
    err = False

    active_time = time.time()
    keep_alive = False
    recv_done = False

    method = ''
    path = ''
    file_path = ''
    file_len = 0
    version = ''
    host = ''
    status = 200
    headers = {}
    mime = ''

    def __init__(self, file_no):
        self.file_no = file_no

    def get_message(self):
        return self.http_message

    def update_active_time(self, active_time):
        self.active_time = active_time

    def append_message(self, message):
        self.http_message += message

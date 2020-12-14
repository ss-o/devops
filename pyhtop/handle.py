# -*- coding: utf-8 -*-
from BaseHTTPServer import BaseHTTPRequestHandler
from StringIO import StringIO
from util import CLRF, STATUS_MESSAGE, SERVER_STR, MIMES, CONFIG
from util import dir_exist, file_exist, can_read
from response import err_page
from header_handler import *
import time

header_handler = {
    'host': host_handler,
    'connection': connection_handler,
    'user_agent': user_agent_handler,
    'if-modified_since': if_modified_since_handler
}


class RequestHandler(BaseHTTPRequestHandler):
    def __init__(self, request_text):
        self.rfile = StringIO(request_text)
        self.raw_requestline = self.rfile.readline()
        self.error_code = self.error_message = None
        self.parse_request()

    def send_error(self, code, message):
        self.error_code = code
        self.error_message = message


def handle_request(request):
    result = RequestHandler(request.get_message())

    request.path = result.path
    request.method = result.command
    request.version = result.request_version

    for key in result.headers.keys():
        request.headers[key] = result.headers[key]

    handle_request_line(request)
    handle_headers(request)

    request.response_message = build_response(request)


def valid_method(method):
    methods = ('GET', 'POST', 'PUT', 'CONNECT', 'HEAD', 'OPTIONS', 'TRACE', 'DELETE')
    if method in methods:
        return True
    return False


def build_err_response(request, status):
    # e.g. HTTP/1.1 404 Not Found\r\n
    response_line = '%s %s%s' % (request.version, STATUS_MESSAGE[status], CLRF)

    headers = ''
    headers += 'Date: %s%s' % (time.strftime('%a, %d %b %Y %H:%M:%S GMT', time.localtime()), CLRF)
    headers += 'Server: %s%s' % (SERVER_STR, CLRF)
    headers += 'Content-Type: text/html%s' % CLRF
    content = err_page(status)
    headers += 'Content-Length: %d%s%s' % (len(content), CLRF, CLRF)

    response = response_line + headers + content
    return response


def build_response(request):

    response_line = '%s %s%s' % (request.version.upper(), STATUS_MESSAGE[request.status], CLRF)
    response_header = ''
    response_body = ''

    if request.keep_alive:
        response_header += 'Connection: keep-alive%s' % CLRF
    else:
        response_header += 'Connection: close%s' % CLRF

    response_header += 'Server: %s%s' % (SERVER_STR, CLRF)

    if request.status == 200:
        with open(request.file_path, 'r') as f:
            response_body = f.read()
            request.file_len = len(response_body)

        response_header += 'Content-Type: %s%s' % (request.mime, CLRF)
        response_header += 'Content-Length: %d%s' % (request.file_len, CLRF)
        response_header += 'Date: %s%s' % (time.strftime('%a, %d %b %Y %H:%M:%S GMT', time.localtime()), CLRF)
        response_header += 'Last-Modified: %s%s%s' % (time.strftime('%a, %d %b %Y %H:%M:%S GMT',
                                                                    time.localtime(modified_time(request.file_path))),
                                                      CLRF,
                                                      CLRF)
    elif request.status == 304:
        pass
    else:
        response_body = err_page(request.status)
        response_header += 'Content-Type: %s%s' % ('text/html', CLRF)
        response_header += 'Content-Length: %d%s%s' % (len(response_body), CLRF, CLRF)
    return response_line + response_header + response_body


def handle_request_line(request):
    # only support GET now
    if not valid_method(request.method) or request.method != 'GET':
        request.status = 405

    handle_uri(request)

    if request.version.upper() == 'HTTP/1.1':
        request.keep_alive = True
    elif request.version == 'HTTP/1.0':
        request.keep_alive = False
    else:
        request.status = 505
        request.err = True


def handle_uri(request):
    if request.path.find('?'):
        request.path = request.path[:request.path.find('?')]

    abs_path = '{0}/{1}'.format(CONFIG['root'], request.path)
    # dir
    if dir_exist(abs_path):
        if not can_read(abs_path):
            request.status = 403
            request.err = True
        else:
            request.file_path = '{0}/{1}'.format(abs_path, CONFIG['index'])
            request.mime = MIMES['html']
    # regular file
    elif file_exist(abs_path):
        if not can_read(abs_path):
            request.status = 403
            request.err = True
        else:
            request.file_path = abs_path
            suffix = request.file_path.split('.')[-1]
            if suffix in MIMES.keys():
                request.mime = MIMES[suffix]
            else:
                request.status = 400
                request.err = True
    else:
        request.status = 404
        request.err = True


def handle_headers(request):
    for header in request.headers.keys():
        if header in header_handler.keys():
            header_handler[header](request, request.headers[header])

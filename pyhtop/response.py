# -*- coding: utf-8 -*-
from util import STATUS_MESSAGE


def err_page(status):
    err_message = STATUS_MESSAGE[status]
    template = '<html><head><title>%s' \
               '</title><head><body><center><p>%s' \
               '</p><hr /></center></body></html>' % (err_message, err_message)
    return template

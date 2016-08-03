lapis = require "lapis"

import respond_to from require "lapis.application"

class extends lapis.Application
    [body_read_test: "/body-test"]: =>
        return ngx.read_body!

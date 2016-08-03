lapis = require "lapis"

import respond_to from require "lapis.application"

class extends lapis.Application
    [body_read_test: "/body-test"]: =>
        ngx.req.read_body!
        return ngx.req.get_body_data!

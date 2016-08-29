lapis = require "lapis"
http = require "lapis.nginx.http"
config = require("lapis.config").get!

import respond_to, json_params from require "lapis.application"
import hmac_sha1 from require "lapis.util.encoding"

class extends lapis.Application
    [request_test: "/req-test"]: =>
        body, status, headers = http.simple "https://api.github.com/meta"
        data = (require "cjson").decode body
        @html ->
            pre body
            p data

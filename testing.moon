lapis = require "lapis"
http = require "lapis.nginx.http"
config = require("lapis.config").get!

import respond_to, json_params from require "lapis.application"
import hmac_sha1 from require "lapis.util.encoding"

class extends lapis.Application
    [body_read_test: "/body-test"]: =>
        ngx.req.read_body!
        return ngx.req.get_body_data!
    [request_test: "/req-test"]: =>
        body, status, headers = http.simple "https://api.github.com/meta"
        data = (require "cjson").decode body
        @html ->
            pre body
            p data
    [markdown_test: "/markdown"]: =>
        discount = require "discount"
        result = discount("# This is a header\n\n[and this is a link](https://guard13007.com) to my **homepage**.\n", "nohtml")
        --return result, layout: false, content_type: "text/plain"
        --return result
        --@html -> raw -> result
        @html -> raw result

config = require "lapis.config"
import sql_password, session_secret from require "secret"

config "production", ->
    session_name "guard13007com"
    secret session_secret
    postgres ->
        host "127.0.0.1"
        user "postgres"
        password sql_password
        database "guard13007com"
    port 8150
    num_workers 4
    code_cache "on"

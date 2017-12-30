config = require "lapis.config"
import sql_password, session_secret from require "secret"

config {"production", "development", "livedev"}, ->
    session_name "guard13007com"
    secret session_secret
    postgres ->
        host "127.0.0.1"
        user "postgres"
        password sql_password
    digest_rounds 12

config "production", ->
    postgres ->
        database "guard13007com"
    port 8150
    num_workers 4
    code_cache "on"

config {"development", "livedev"}, ->
    postgres ->
        database "devguard13007com"
    num_workers 2
    code_cache "off"

config "development", ->
    port 9000

config "livedev", ->
    port 8155

config = require "lapis.config"
import sql_password, session_secret, githook_secret from require "secret"

config {"production", "development"}, ->
    session_name "guard13007com"
    secret session_secret
    postgres ->
        host "127.0.0.1"
        user "postgres"
        password sql_password
    githook_secret githook_secret --haha fixed! >:D
    digest_rounds 9

config "production", ->
    postgres ->
        database "guard13007com"
    port 8150
    num_workers 4
    code_cache "on"
    githook "master"

config "development", ->
    postgres ->
        database "devguard13007com"
    port 8155
    num_workers 2
    code_cache "off"
    githook "dev"

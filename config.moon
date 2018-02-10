config = require "lapis.config"
import sql_password, session_secret from require "secret"

config {"production", "development", "localdev"}, ->
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
    githook_branch "master"

config {"development", "localdev"}, ->
    postgres ->
        database "devguard13007com"
    num_workers 2
    code_cache "off"
    githook_branch "dev"

config "localdev", ->
    port 9000

config "development", ->
    port 8155

config = require "lapis.config"
import sql_password, session_secret from require "secret"

config {"production", "development"}, ->
  session_name "guard13007com"
  secret session_secret
  postgres ->
    host "127.0.0.1"
    user "guard13007com"
    password sql_password

config "production", ->
  postgres ->
    database "guard13007com"
  num_workers 4
  code_cache "on"
  githook_branch "master"
  port 8150

config "development", ->
  postgres ->
    database "devguard13007com"
  num_workers 2
  code_cache "off"
  githook_branch "dev"
  port 8155

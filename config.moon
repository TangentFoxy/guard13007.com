config = require "lapis.config"

postgres_password = os.getenv "POSTGRES_PASSWORD"
session_secret = os.getenv "SESSION_SECRET"

config {"production", "development"}, ->
  session_name "guard13007com"
  secret session_secret
  postgres ->
    host "guard13007comdb"
    user "postgres"
    database "postgres"
    password postgres_password
  port 8080

config "production", ->
  num_workers 4
  code_cache "on"
  githook_branch "master"

config "development", ->
  num_workers 2
  code_cache "off"
  githook_branch "dev"

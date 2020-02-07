config = require "lapis.config"

config {"production", "development"}, ->
  session_name "guard13007com"
  secret os.getenv("SESSION_SECRET") or "totally a secret"
  postgres ->
    host "guard13007comdb"
    user "postgres"
    database "postgres"
    password os.getenv("POSTGRES_PASSWORD") or "" --might not work always!
  port 80

config "production", ->
  num_workers 4
  code_cache "on"
  githook_branch "master"

config "development", ->
  num_workers 2
  code_cache "off"
  githook_branch "dev"

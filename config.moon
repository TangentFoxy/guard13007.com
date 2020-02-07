config = require "lapis.config"

config "production", ->
  session_name "guard13007com"
  secret os.getenv("SESSION_SECRET") or "totally a secret"
  postgres ->
    host os.getenv("DB_HOST") or "guard13007comdb"
    user os.getenv("DB_USER") or "postgres"
    database os.getenv("DB_NAME") or "postgres"
    password os.getenv("DB_PASS") or "" --blank password may not function as no password?
  port 80
  num_workers 4
  code_cache "on"
  githook_branch "master"
  digest_rounds 9 -- I am assuming this is needed and don't know why it wasn't specified (maybe it was in the old settings table)

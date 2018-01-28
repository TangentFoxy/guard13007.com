config = require "lapis.config"
import sql_password, session_secret, domain_name from require "secret"

config {"production", "development"}, ->
  session_name "fursimile"
  secret session_secret
  postgres ->
    host "127.0.0.1"
    user "postgres"
    password sql_password
  digest_rounds 12

config "production", ->
  postgres ->
    database "fursimile"
  port 9450
  num_workers 4
  code_cache "on"
  domain domain_name

config "development", ->
  postgres ->
    database "fursimile_dev"
  port 9455
  num_workers 2
  code_cache "off"
  domain "dev.#{domain_name}"

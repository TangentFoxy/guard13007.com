lapis = require "lapis"
config = require("lapis.config").get!

-- execute = (cmd) ->
--   handle = io.popen cmd
--   result = handle\read "*a"
--   handle\close!
--   return result

execute = (cmd) ->
  return os.execute "sudo -Hu www-data #{cmd} >> /srv/guard13007.com/logs/updates.log 2>&1"

read = ->
  handle, err = io.open "/srv/guard13007.com/logs/updates.log", "r"
  if handle
    result = handle\read "*a"
    handle\close!
    return result
  else
    return err

class GithookApp extends lapis.Application
  [githook: "/githook"]: =>
    result = "#{execute "git pull origin"}\n"
    result ..= "#{execute "moonc ."}\n"
    result ..= "#{execute "lapis migrate #{config._name} --trace"}\n"
    result ..= "#{execute "lapis build #{config._name} --trace"}\n"
    -- result ..= "#{execute "chown -R www-data:www-data ./"}"
    return {
      json: {
        status: "unknown",
        :result,
        log: read!
      }
    }

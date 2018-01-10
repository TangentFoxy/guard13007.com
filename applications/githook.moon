lapis = require "lapis"
config = require("lapis.config").get!

execute = (cmd) ->
  handle = io.popen cmd
  result = handle\read "*a"
  handle\close!
  return result

execute = os.execute

class GithookApp extends lapis.Application
  [githook: "/githook"]: =>
    result = "#{execute "sudo git pull origin"}\n"
    result ..= "#{execute "sudo moonc ."}\n"
    result ..= "#{execute "sudo lapis migrate #{config._name} --trace"}\n"
    result ..= "#{execute "sudo lapis build #{config._name} --trace"}\n"
    result ..= "#{execute "sudo chown -R www-data:www-data ./"}"
    return {
      json: {
        status: "unknown",
        message: result
      }
    }

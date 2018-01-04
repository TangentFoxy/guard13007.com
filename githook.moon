lapis = require "lapis"
config = require("lapis.config").get!

execute = (cmd) ->
  handle = io.popen cmd
  result = handle\read "*a"
  handle\close!
  return result

class GithookApp extends lapis.Application
  [githook: "/githook"]: =>
    result = "#{execute "git pull origin"}\n"
    result ..= "#{execute "moonc ."}\n"
    result ..= "#{execute "lapis migrate #{config._name} --trace"}\n"
    result ..= "#{execute "lapis build #{config._name} --trace"}\n"
    return {
      json: {
        status: "unknown",
        message: result
      }
    }

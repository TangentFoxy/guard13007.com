lapis = require "lapis"
config = require("lapis.config").get!

class GithookApp extends lapis.Application
  [githook: "/githook"]: =>
    os.execute "echo \"Updating server...\" >> logs/updates.log"
    result = 0 == os.execute "git pull origin >> logs/updates.log"
    result = (0 == os.execute "moonc . 2>> logs/updates.log") and result
    result = (0 == os.execute "lapis migrate #{config._name} >> logs/updates.log") and result
    result = (0 == os.execute "lapis build #{config._name} >> logs/updates.log") and result
    if result
      return { json: { status: "successful", message: "server updated to latest version" } }
    else
      return { json: { status: "failure", message: "check logs/updates.log"} }, status: 500 --Internal Server Error

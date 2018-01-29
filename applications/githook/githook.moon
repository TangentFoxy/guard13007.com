lapis = require "lapis"
config = require("lapis.config").get!

import respond_to, json_params from require "lapis.application"
import hmac_sha1 from require "lapis.util.encoding"
import insert from table

const_compare = (string1, string2) ->
  local fail, dummy

  for i = 1, 100
    if string1\sub(i,i) ~= string2\sub(i,i)
      fail = true
    else
      dummy = true -- attempting to make execution time equal

  return not fail

hex_dump = (str) ->
  len = string.len str
  hex = ""

  for i = 1, len
    hex ..= string.format( "%02x", string.byte( str, i ) )

  return hex

execute = (cmd) ->
  handle = io.popen "#{cmd}\necho $?"
  result = handle\read "*a"
  handle\close!
  return result

run_update = (branch) ->
  log = {}
  insert log, execute "git checkout #{branch}"
  insert log, execute "git pull origin"
  insert log, execute "git submodule init"
  insert log, execute "git submodule update"
  insert log, execute "for file in $(find . -type f -name \"*.moon\" 2> /dev/null); do moonc \"$file\"; done"
  insert log, execute "lapis migrate #{config._name}"
  insert log, execute "lapis build #{config._name}"

  exit_codes = {}
  failure = false
  full_log = ""
  for result in *log
    last_line = result\find "[^%c]*$"

    full_log ..= result\sub 1, last_line

    exit_code = tonumber result\sub(last_line)\gsub("\n", "")
    failure = true if exit_code != 0
    insert exit_codes, exit_code

  if failure
    return status: 500, json: {
      status: "failure"
      message: "a subprocess returned a non-zero exit code"
      log: full_log
      :exit_codes
    }
  else
    return status: 200, json: {
      status: "success"
      message: "server updated to latest version of '#{branch}'"
      log: full_log
      :exit_codes
    }

class extends lapis.Application
  [githook: "/githook"]: respond_to {
    GET: =>
      return status: 405, "Method Not Allowed"

    POST: json_params =>
      branch = "master" or config.githook_branch
      if config.githook_secret
        ngx.req.read_body!
        if body = ngx.req.get_body_data!
          authorized = const_compare "sha1=#{hex_dump hmac_sha1 config.githook_secret, body}", @req.headers["X-Hub-Signature"]
          unless authorized
            return status: 401, "Unauthorized"
          if @params.ref == "refs/heads/#{branch}"
            return run_update branch
          elseif @params.ref == nil
            return status: 400, json: {
              status: "invalid request"
              message: "'ref' not defined in request body"
            }
          else
            return status: 200, json: {
              status: "success"
              message: "ignored push (looking for updates to '#{branch}')"
            }
        else
          return status: 400, json: {
            status: "invalid request"
            message: "no request body"
          }
      else
        return run_update branch
    }

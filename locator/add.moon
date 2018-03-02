config = require "locator_config"

execute = (cmd, capture_exit_code=true) ->
  local handle
  if capture_exit_code
    handle = io.popen "#{cmd}\necho $?"
  else
    handle = io.popen cmd
  result = handle\read "*a"
  handle\close!

  exit_start, exit_end = result\find "(%d*)[%c]$"
  exit_code = tonumber result\sub(exit_start, exit_end)\sub 1, -2
  output = result\sub 1, exit_start - 1

  if exit_code == 0
    return output
  else
    error "sub-process '#{cmd}' returned status #{exit_code}.\n\n#{output}"

list = execute "git remote"
remotes = {}
for line in list\gmatch "[^\n]+"
  remotes[line] = true

for item in *config
  if item.remote and item.remote.fetch -- if configured to pull
    unless item.remote.branch
      item.remote.branch = "master"

    if item.remote.name -- if we want a named remote
      unless remotes[item.remote.name] -- add it if needed
        execute "git remote add -f #{item.remote.name} #{item.remote.fetch}"
        if item.remote.push and not ("boolean" == type item.remote.push)
          execute "git remote set-url --push #{item.remote.name} #{item.remote.push}"

    -- we actually ignore names with in-script usage..
    execute "git subtree add --prefix #{item.path\gsub "%.", "/"} #{item.remote.fetch} #{item.remote.branch} --squash"

local config = require("locator_config")
local execute
execute = function(cmd, capture_exit_code)
  if capture_exit_code == nil then
    capture_exit_code = true
  end
  local handle
  if capture_exit_code then
    handle = io.popen(tostring(cmd) .. "\necho $?")
  else
    handle = io.popen(cmd)
  end
  local result = handle:read("*a")
  handle:close()
  local exit_start, exit_end = result:find("(%d*)[%c]$")
  local exit_code = tonumber(result:sub(exit_start, exit_end):sub(1, -2))
  local output = result:sub(1, exit_start - 1)
  if exit_code == 0 then
    return output
  else
    return error("sub-process '" .. tostring(cmd) .. "' returned status " .. tostring(exit_code) .. ".\n\n" .. tostring(output))
  end
end
local list = execute("git remote")
local remotes = { }
for line in list:gmatch("[^\n]+") do
  remotes[line] = true
end
for _index_0 = 1, #config do
  local item = config[_index_0]
  if item.remote and item.remote.fetch then
    if not (item.remote.branch) then
      item.remote.branch = "master"
    end
    if item.remote.name then
      if not (remotes[item.remote.name]) then
        execute("git remote add -f " .. tostring(item.remote.name) .. " " .. tostring(item.remote.fetch))
        if item.remote.push and not ("boolean" == type(item.remote.push)) then
          execute("git remote set-url --push " .. tostring(item.remote.name) .. " " .. tostring(item.remote.push))
        end
      end
    end
    execute("git subtree add --prefix " .. tostring(item.path:gsub("%.", "/")) .. " " .. tostring(item.remote.fetch) .. " " .. tostring(item.remote.branch) .. " --squash")
  end
end

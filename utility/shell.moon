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

  return exit_code, output

{
  :execute
}

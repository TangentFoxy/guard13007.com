execute = (cmd) ->
  handle = io.popen "#{cmd}\necho $?"
  output = handle\read "*a"
  handle\close!

  exit_start, exit_end = output\find "(%d*)[%c]$"
  exit_code = tonumber output\sub(exit_start, exit_end)\sub 1, -2

  output = output\sub 1, exit_start - 1
  if "\n" == output\sub -1
    output = output\sub 1, -2

  if exit_code == nil
    exit_code = math.huge -- if we have a function not return any error code...

  return output, exit_code

{
  :execute
}

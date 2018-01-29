execute = (cmd) ->
  handle = io.popen "#{cmd}\necho $?"
  output = handle\read "*a"
  handle\close!

  last_line = output\find "[^%c]*$"
  return output\sub(1, last_line), tonumber output\sub last_line

{
  :execute
}

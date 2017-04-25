local resty_room
fn = ->
  resty_random = require "resty.random"
pcall(fn)

random_number = ->
  a, b, c, d = string.byte resty_random.bytes(4), 1, 2, 3, 4
  return a + b * 256 + c * 65536 + d * 16777216

return {
  :random_number
}

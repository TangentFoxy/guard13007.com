import bytes from require "resty.random"
import byte from string
import floor from math

-- return a random number between min/max
random = (min, max) ->
  unless max
    max = min or 1
    min = 0

  a, b, c, d = byte bytes(4), 1, 2, 3, 4
  value = a + b * 256 + c * 65536 + d * 16777216 -- 0 to 4294967296
  range = max - min

  if max == floor(max) and min == floor(min)
    return floor value * range / 4294967296 + min
  else
    return value * range / 4294967296 + min

-- map a value within a range of numbers to another range
map = (min1, max1, value, min2, max2) ->
  range1 = max1 - min1
  range2 = max2 - min2
  return ((value - min1) * range2 / range1) + min2

{
  :random
  :map
}

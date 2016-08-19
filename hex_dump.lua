-- this was copied (and modified heavily) from https://gist.githubusercontent.com/Elemecca/6361899/raw/3c0e08285f452eb65268946f1695b8eb1117ed5b/hex_dump.lua
-- this is temporary at the moment for testing if it even works for my use case (githook)

return function(str)
    local len = string.len(str)
    local hex = ""

    for i = 1, len do
        hex = hex .. string.format( "%02x ", string.byte( str, i ) )
    end

    return hex
end


local TileTypes = require("data.tiles.types")

local M = {}
local by_char =  {}

for _, v in ipairs(TileTypes) do
	M[v.type] = v
    by_char[v.char] = v.type

end


function M.create_from_char(c)
  local kind = by_char[c]
  return M.create(kind)
end



function M.create(type)
  return table.copy(M[type])
end


return M

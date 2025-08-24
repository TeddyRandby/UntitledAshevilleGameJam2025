
local EntityTypes = require("data.entities.types")

local M = {}

for _, v in ipairs(EntityTypes) do
	M[v.type] = v
end

function M.create(type)
  return table.copy(M[type])
end


return M

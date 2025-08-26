
local EntityTypes = require("data.entity.types")

local M = {}

for _, v in ipairs(EntityTypes) do
	M[v.type] = v
end

function M.create(type)

  local potential_entity = table.copy(M[type])

  if potential_entity.create then
    potential_entity.create(potential_entity)
  end
  
  if not potential_entity.w then
    potential_entity.w = 1
  end
  if not potential_entity.h then
    potential_entity.h = 1
  end


  return potential_entity
end


return M

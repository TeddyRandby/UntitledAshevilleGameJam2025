
local EntityTypes = require("data.entity.types")

local M = {}

local function deep_print(tbl, indent, visited) --TODO Gross, for debug
  indent = indent or 0
  visited = visited or {}

  if visited[tbl] then
    print(string.rep("  ", indent) .. "*recursive reference*")
    return
  end
  visited[tbl] = true

  for k, v in pairs(tbl) do
    local keyStr = tostring(k)
    if type(v) == "table" then
      print(string.rep("  ", indent) .. keyStr .. " = {")
      deep_print(v, indent + 1, visited)
      print((string.rep("  ", indent) .. "}"))
    else
      print((string.rep("  ", indent) .. keyStr .. " = " .. tostring(v)))
    end
  end
end

for _, v in ipairs(EntityTypes) do
	M[v.type] = v
end

function M.create(type)

  local potential_entity = table.copy(M[type])

  if potential_entity.create then
    potential_entity.create(potential_entity)
  end
  
  if not potential_entity.size_x then
    potential_entity.size_x = 1
  end
  if not potential_entity.size_y then
    potential_entity.size_y = 1
  end


  return potential_entity
end


return M

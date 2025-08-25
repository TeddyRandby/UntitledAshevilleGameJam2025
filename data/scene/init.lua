local M = {}

local SceneTypes = require("data.scene.types")

for _, v in ipairs(SceneTypes) do
	M[v.type] = v
  if v.backdrop_name then
    v.backdrop = love.graphics.newImage("resources/" .. v.backdrop_name)
  end
end

function M.create(type)
  return table.copy(M[type])
end

return M

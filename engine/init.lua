local Scene = require("data.scene")
---@class Engine
---@field scenes Scene[]
---@field scene_buffer Scene[]
---@field rng love.RandomGenerator
---@field time integer
local M = {
  time = 0,
  --- The actual stack of scenes.
  scene_stack = {},
  --- A temporary buffer of scenes, queued by components, to be entered
  --- after processing this frame.
  scene_buffer = {},
}

function M:load()
	self.rng = love.math.newRandomGenerator(os.clock())
  table.insert(self.scene_stack, Scene.main)
end

---@param dt number
function M:update(dt)
	self.time = self.time + dt

	local scene = table.peek(self.scene_stack)

  assert(scene ~= nil, "No scene found!")
  assert(#scene.layout ~= 0, "No components in scene")

	for _, component in ipairs(scene.layout) do
		component()
	end

	if #self.scene_buffer > 0 then
		table.append(self.scene_stack, self.scene_buffer)
		self.scene_buffer = {}
	end
end

return M

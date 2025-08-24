local Scene = require("data.scene")
local Page = require("data.page")

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

  --- The list of pages in the players hand
  player_hand = {},
}

---@param scene SceneType
---@param data any
function M:scene_push(scene, data)
  local template = Scene[scene]
  assert(template ~= nil, "Unknown scene: " .. scene)
  template = table.copy(template)
  template.data = data
	table.insert(self.scene_buffer, template)
end

---@return Scene
function M:current_scene()
	local scene = table.peek(self.scene_stack)
  assert(scene ~= nil, "Missing scene")
  return scene
end

--- Rewind to the previous scene.
function M:scene_rewind()
	local scene = table.pop(self.scene_stack)

	if scene ~= nil then
		print("REWIND OVER .. ", scene)
	end

	if scene ~= "settling" then
		-- self:__enterscene(self:current_scene())
	end
end

---@param scene SceneType
function M:scene_rewindto(scene)
	repeat
		local popped_scene = table.pop(self.scene_stack)

		if popped_scene ~= nil then
			print("REWINDTO OVER .. ", popped_scene)
			-- self:__exitscene(popped_scene)
		end
	until self:current_scene() == scene

	-- self:__enterscene(self:current_scene())
end

function M:load()
	self.rng = love.math.newRandomGenerator(os.clock())
  table.insert(self.scene_stack, Scene.main)
  for _ = 0, 4 do
    table.insert(self.player_hand, Page.create(1, 1, 1))
  end
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

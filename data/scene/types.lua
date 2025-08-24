---@alias Component function
---@alias SceneType "main" | "combat"

---@class Scene
---@field type SceneType
---@field layout Component[]
---@field data? unknown

local Components = require("data.scene.components")

local _, NormalizedPageHeight = UI.page.getNormalizedDim()

---@type Scene[]
return {
	{
		type = "main",
		layout = {
			function()
				View:button(0.5, 0.5, "Play", function()
					Engine:scene_push("combat")
				end)
			end,
		},
	},
	{
		type = "combat",
		layout = {
			Components.hand(0.1, -NormalizedPageHeight * 0.5, function(i, p)
				return {
					dragend = function()
						print("Played page: " .. table.concat(p.words, ","))
					end,
				}
			end),
		},
	},
}

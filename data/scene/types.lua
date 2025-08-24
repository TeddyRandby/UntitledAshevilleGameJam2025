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
      function()
        View:button(0.5, 0.5, "cast", function()
          Engine:cast(Engine.player_spell)
        end)
      end,
      Components.hand(0.1, -NormalizedPageHeight * 0.8, function(i, p)
        return {
          dragend = function()
            Engine:play(i)
          end,
        }
      end),
    },
  },
}

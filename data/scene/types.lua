---@alias Component function
---@alias SceneType "main" | "combat" | "room"

---@class Scene
---@field type SceneType
---@field backdrop_name? string
---@field backdrop? love.Image
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
        View:button(0.5, 0.5, "play", function()
          Engine:scene_push("combat")
        end)
      end,
      function()
        View:button(0.5, 0.75, "Room", function()
          Engine:scene_push("room")
        end)
      end,
    },
  },
  {
    type = "combat",
    backdrop_name = "BattleScne.png",
    layout = {
      function()
        View:button(0.5, 0.5, "cast", function()
          Engine:player_cast()
          Engine:scene_rewind()
        end)
      end,
      Components.healthbar(0.01, 0.01, function()
        return Engine.player_health / 3
      end),
      Components.spell_in_progress(0.01, 0.2, function()
        return Engine.player_spell
      end),
      Components.hand(0.1, -NormalizedPageHeight * 0.8, function(i, p)
        return {
          dragend = function()
            if Engine:playable(i) then
              Engine:play(i)
            end
          end,
        }
      end),
    },
  },
    {
    type = "room",
    layout = {
      Components.healthbar(0.01, 0.01, function()
        return Engine.player_health / 3
      end),
      Components.room(),
    },
  },
}

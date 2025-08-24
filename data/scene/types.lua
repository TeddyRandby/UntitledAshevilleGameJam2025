---@alias Component function
---@alias SceneType "main"

---@class Scene
---@field type SceneType
---@field layout Component[]
---@field data? unknown
---
---@type Scene[]
return {
  {
    type = "main",
    layout = {
      function()
        View:text("Hello world", 0.1, 0.1)
        View:button(0.5, 0.5, "Play", function()
          print("clicked play")
        end)
      end
    },
  },
}

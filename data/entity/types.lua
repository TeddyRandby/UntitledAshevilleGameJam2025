return {
  {
    type = "player",
    position_x = 10,
    position_y = 5,
    speed = 5
  },

  {
    type = "enemy",
    speed = 5,
    position_x = nil,
    position_y = nil,
    collision = function()
      Engine:scene_push("combat")
    end
  },

  {
    type = "crate"

  }
}

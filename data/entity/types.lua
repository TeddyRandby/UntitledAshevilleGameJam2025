return {
  {
    type = "player",
    position_x = 4,
    position_y = 3,
    speed = 3
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
    type = "health_shrine",
    position_x = nil,
    position_y = nil,
    collision = function()
      Engine:heal(1)
    end
  },
  {
    type = "letter_shrine",
    position_x = nil,
    position_y = nil,
    size_x = 1,
    size_y = 2,
    create = function(self)
      self.letter = Engine:get_random_letter()
    end,
    collision = function(self)
      Engine:learn(self.letter)
    end
  },
  {
    type = "page_shrine",
    position_x = nil,
    position_y = nil,
    collision = function()
      Engine:heal(1)
    end
  }
}

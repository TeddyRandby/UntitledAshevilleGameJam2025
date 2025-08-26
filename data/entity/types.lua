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
      Engine:setup_combat()
      Engine:scene_push("combat")
    end
  },
  {
    type = "health_shrine",
    position_x = nil,
    position_y = nil,
    w = 1,
    h = 2,
    collision = function(self)
      Engine:heal(1)
      Room.remove_from_room(Engine.room, self)
    end
  },
  {
    type = "letter_shrine",
    position_x = nil,
    position_y = nil,
    w = 1,
    h = 2,
    create = function(self)
      self.letter = Engine:get_random_letter()
    end,
    collision = function(self)
      Engine:learn(self.letter)
      Room.remove_from_room(Engine.room, self)
    end
  },
  {
    type = "page_shrine",
    position_x = nil,
    position_y = nil,
    w = 1,
    h = 2,
    create = function(self)
      self.page = Engine:create_random_page(1)
    end,
    collision = function(self)
      table.insert(Engine.player_deck, self.page)
      Room.remove_from_room(Engine.room, self)
    end
  }
}

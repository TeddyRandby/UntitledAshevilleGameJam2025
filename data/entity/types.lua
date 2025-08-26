return {
  {
    type = "player",
    position_x = 4,
    position_y = 3,
    speed = 3,
    create = function(self)
      self.anim = UI.anim.create_player()
    end
  },
  {
    type = "enemy",
    speed = 5,
    position_x = nil,
    position_y = nil,
    collision = function(self)
      Engine:setup_combat(self)
      Engine:scene_push("combat")
    end
  },
  {
    type = "page_drop",
    create = function(self)
      self.page = Engine:create_random_page(1)
      self.anim = UI.anim.create_pagedrop()
    end,
    collision = function(self)
      table.insert(Engine.player_deck, self.page)
      Room.remove_from_room(Engine.room, self)
    end
  },
  {
    type = "health_shrine",
    position_x = nil,
    position_y = nil,
    collision = function(self)
      Engine:heal(1)
      Room.remove_from_room(Engine.room, self)
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
      Room.remove_from_room(Engine.room, self)
    end
  },
  {
    type = "page_shrine",
    position_x = nil,
    position_y = nil,
    create = function(self)
      self.page = Entity.create("page_drop")
    end,
    collision = function(self)
      Room.remove_from_room(Engine.room, self)

      self.page.position_x = Engine.player.position_x
      self.page.position_y = Engine.player.position_y - 1

      Room.insert_into_room(Engine.room, self.page)
    end
  }
}

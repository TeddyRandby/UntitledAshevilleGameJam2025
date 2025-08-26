return {
	{
		type = "player",
		position_x = 4,
		position_y = 3,
		speed = 3,
		create = function(self)
			self.anim = UI.anim.create_player()
		end,
	},
	{
		type = "enemy_butter",
    spritename = "ButterEnemy.png",
		speed = 5,
		position_x = nil,
		position_y = nil,
		collision = function(self)
			Engine:setup_combat(self)
			Engine:scene_push("combat")
		end,
    remove = function(self)
      local corpse = Entity.create("butter_corpse")
      corpse.position_x = self.position_x
      corpse.position_y = self.position_y
      Room.insert_into_room(Engine.room, corpse)
    end
  },
  {
    type = "butter_corpse",
    spritename = "ButterDead.png",
		speed = 5,
		position_x = nil,
		position_y = nil,
    walkable = true
  },
	{
		type = "enemy_milk",
    -- spritename = "MilkEnemy.png",
    spritename = "ButterEnemy.png",
		speed = 5,
		position_x = nil,
		position_y = nil,
		collision = function(self)
			Engine:setup_combat(self)
			Engine:scene_push("combat")
		end,
    remove = function(self)
      local corpse = Entity.create("milk_corpse")
      corpse.position_x = self.position_x
      corpse.position_y = self.position_y
      Room.insert_into_room(Engine.room, corpse)
    end
	},
  {
    type = "milk_corpse",
    spritename = "MilkDead.png",
		speed = 5,
		position_x = nil,
		position_y = nil,
    w = 1,
    h = 0.5,
    walkable = true,
  },
	{
		type = "enemy_flour",
    -- spritename = "FlourEnemy.png",
		speed = 5,
    spritename = "ButterEnemy.png",
		position_x = nil,
		position_y = nil,
		collision = function(self)
			Engine:setup_combat(self)
			Engine:scene_push("combat")
		end,
    remove = function(self)
      local corpse = Entity.create("flour_corpse")
      corpse.position_x = self.position_x
      corpse.position_y = self.position_y
      Room.insert_into_room(Engine.room, corpse)
    end
  },
  {
    type = "flour_corpse",
    spritename = "FlourDead.png",
		speed = 5,
		position_x = nil,
		position_y = nil,
    walkable = true
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
		end,
	},
	{
		type = "health_shrine",
    spritename = "Shrine.png",
		position_x = nil,
		position_y = nil,
		w = 1,
		h = 2,
		collision = function(self)
			Engine:heal(1)
			Room.remove_from_room(Engine.room, self)
		end,
	},
	{
		type = "letter_shrine",
    spritename = "Shrine.png",
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
		end,
	},
	{
		type = "enemy",
		create = function(self)
			local depth = Engine.room.depth or 0
			if depth <= 5 then
				return Entity.create("enemy_milk")
			elseif depth <= 10 then
				return Entity.create("enemy_butter")
			else
				return Entity.create("enemy_flour")
			end
		end,
	},
	{
		type = "page_shrine",
    spritename = "Shrine.png",
		position_x = nil,
		position_y = nil,
		w = 1,
		h = 2,
		create = function(self)
			self.page = Entity.create("page_drop")
		end,
		collision = function(self)
			Room.remove_from_room(Engine.room, self)

			self.page.position_x = Engine.player.position_x
			self.page.position_y = Engine.player.position_y - 1

			Room.insert_into_room(Engine.room, self.page)
		end,
	},
}

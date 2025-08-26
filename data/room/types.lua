return {
  {
  type = "basic",
  layout = {"C###LR###C",
            "#--------#",
            "#--------#",
            "R--------L",
            "L--------R",
            "#--------#",
            "#--------#",
            "C###RL###C",
    },
    connects = {up=true, down=true, left=true, right=true},
    entities = {{2,"enemy"}, {1,"page_shrine"}},
    neighbors = {}
  },
  {
  type = "vert_hall",
  layout = {"C###LR###C",
            "#--------#",
            "#--------#",
            "#--------#",
            "#--------#",
            "#--------#",
            "#--------#",
            "C###RL###C",
    },
    connects = {up=true, down=true, left=false, right=false},
    entities = {{2,"enemy"}},
    neighbors = {}
  },
  {
  type = "horz_hall",
  layout = {"C########C",
            "#--------#",
            "#--------#",
            "R--------L",
            "L--------R",
            "#--------#",
            "#--------#",
            "C########C"
    },
      connects = {up=false, down=false, left=true, right=true},
      entities = {{2,"enemy"}},
      neighbors = {}
  }
}


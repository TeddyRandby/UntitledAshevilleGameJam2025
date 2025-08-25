return {
  {
  type = "basic",
  layout = {"###LR###",
            "#------#",
            "L------L",
            "R------R",
            "#------#",
            "###LR###",
    },
    connects = {up=true, down=true, left=true, right=true},
    entities = {{2,"enemy"}, {1,"page_shrine"}},
    neighbors = {}
  },
  {
  type = "vert_hall",
  layout = {"###LR###",
            "##----##",
            "##----##",
            "##----##",
            "##----##",
            "###LR###"
    },
    connects = {up=true, down=true, left=false, right=false},
    entities = {{2,"enemy"}},
    neighbors = {}
  },
  {
  type = "horz_hall",
  layout = {"########",
            "#------#",
            "L------L",
            "R------R",
            "#------#",
            "########",
    },
      connects = {up=false, down=false, left=true, right=true},
      entities = {{2,"enemy"}},
      neighbors = {}
  },
  {
  type = "crossway",
  layout = {"###LR###",
            "##----##",
            "L------L",
            "R------R",
            "##----##",
            "###LR###",
    },
    connects = {up=true, down=true, left=true, right=true},
    entities = {{2,"enemy"}, {1,"health_shrine"}},
    neighbors = {}
  },
}


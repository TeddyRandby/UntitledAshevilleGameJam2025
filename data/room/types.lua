return {
  {
  type = "basic",
  layout = {"###DD###",
            "#------#",
            "D------D",
            "D------D",
            "#------#",
            "###DD###",
    },
    connects = {up=true, down=true, left=true, right=true},
    entities = {{2,"enemy"}, {1,"letter_shrine"}},
    neighbors = {}
  },
  {
  type = "vert_hall",
  layout = {"###DD###",
            "##----##",
            "##----##",
            "##----##",
            "##----##",
            "###DD###"
    },
    connects = {up=true, down=true, left=false, right=false},
    entities = {{5,"enemy"}},
    neighbors = {}
  },
  {
  type = "horz_hall",
  layout = {"########",
            "#------#",
            "D------D",
            "D------D",
            "#------#",
            "########",
    },
      connects = {up=false, down=false, left=true, right=true},
      entities = {{2,"enemy"}},
      neighbors = {}
  },
  {
  type = "crossway",
  layout = {"###DD###",
            "##----##",
            "D------D",
            "D------D",
            "##----##",
            "###DD###",
    },
    connects = {up=true, down=true, left=true, right=true},
    entities = {{2,"enemy"}, {1,"health_shrine"}},
    neighbors = {}
  },
}


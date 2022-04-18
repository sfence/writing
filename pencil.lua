
local S = writing.translator

-- technic:graphite + clay + stick
-- lead, silver

-- kaucukova guma -> rubber tree

minetest.register_tool("writing:pencil_graphite", {
    description = S("Graphite Pencil"),
    inventory_image = "writing_pencil_graphite.png",
    
    _writing_tool = {
      cost_per_add = 10,
      cost_per_remove = 0,
      cost_per_change = 20,
      materials = {paper = 1, wood = 1},
    },
    
    on_use = writing.on_use_write_tool,
  })

minetest.register_tool("writing:pencil_lead", {
    description = S("Lead Pencil"),
    inventory_image = "writing_pencil_lead.png",
    
    _writing_tool = {
      cost_per_add = 3,
      cost_per_remove = 0,
      cost_per_change = 6,
      materials = {paper = 1, wood = 1},
    },
    
    on_use = writing.on_use_write_tool,
  })

minetest.register_tool("writing:pencil_silver", {
    description = S("Silver Pencil"),
    inventory_image = "writing_pencil_silver.png",
    
    _writing_tool = {
      cost_per_add = 1.5,
      cost_per_remove = 0,
      cost_per_change = 3,
      materials = {paper = 1, wood = 1},
    },
    
    on_use = writing.on_use_write_tool,
  })

minetest.register_tool("writing:rubber", {
    description = S("Rubber"),
    inventory_image = "writing_rubber.png",
    
    _writing_tool = {
      cost_per_add = 0,
      cost_per_remove = 5,
      cost_per_change = 0,
      materials = {paper = 1, wood = 1},
    },
    
    on_use = writing.on_use_write_tool,
  })

minetest.register_tool("writing:pencil_with_rubber", {
    description = S("Graphite Pencil with Rubber"),
    inventory_image = "writing_pencil_with_rubber.png",
    
    _writing_tool = {
      cost_per_add = 11,
      cost_per_remove = 25,
      cost_per_change = 0,
      materials = {paper = 1, wood = 1},
    },
    
    on_use = writing.on_use_write_tool,
  })


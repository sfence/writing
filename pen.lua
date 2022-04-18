
local S = writing.translator

-- from feather with ink
if writing.textures.feather then
  minetest.register_tool("writing:feather_with_oak_gall_ink", {
      description = S("Feather with oak Gall Ink"),
      inventory_image = "writing_ink_bottle.png^"..writing.textures.feather,
      
      _writing_tool = {
        cost_per_add = 1,
        cost_per_remove = 0,
        cost_per_change = 2,
        materials = {paper = 1, wood = 1},
        break_stack = writing.items.glass_bottle,
      },
      
      on_use = writing.on_use_write_tool,
    })

  minetest.register_tool("writing:feather_with_soot_ink", {
      description = S("Feather with Soot Ink"),
      inventory_image = "writing_ink_bottle.png^"..writing.textures.feather,
      
      _writing_tool = {
        cost_per_add = 3,
        cost_per_remove = 0,
        cost_per_change = 6,
        materials = {paper = 1, wood = 1},
        break_stack = writing.items.glass_bottle,
      },
      
      on_use = writing.on_use_write_tool,
    })
  
  minetest.register_tool("writing:feather_with_soot_glue", {
      description = S("Feather with Soot Glue"),
      inventory_image = "writing_glue_glass.png^"..writing.textures.feather,
      
      _writing_tool = {
        cost_per_add = 1,
        cost_per_remove = 0,
        cost_per_change = 2,
        materials = {wood = 1, metal = 1, glass = 1},
        break_stack = writing.items.drinking_glass,
      },
      
      on_use = writing.on_use_write_tool,
    })
end


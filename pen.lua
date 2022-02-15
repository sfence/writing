
local S = writing.translator

-- from feather with ink
if writing.textures.feather then
  minetest.register_tool("writing:feather_with_oak_gall_ink", {
      description = S("Feather with oak Gall Ink"),
      inventory_image = "writing_ink_bottle.png^"..writing.textures.feather,
      
      _cost_per_character = 10,
      
      on_use = writing.on_use_write_tool,
    })

  minetest.register_tool("writing:feather_with_soot_ink", {
      description = S("Feather with Soot Ink"),
      inventory_image = "writing_ink_bottle.png^"..writing.textures.feather,
      
      _cost_per_character = 30,
      
      on_use = writing.on_use_write_tool,
    })
end


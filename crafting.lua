
local items = writing.items

minetest.register_craft({
    output = "writing:soot_ink_bottle",
    recipe = {
      {items.honey, items.egg, "writing:soot_glass"},
      {"", items.water_bottle, ""},
      {"", items.glass_bottle, ""},
    },
    replacements = {
      {"writing:soot_glass", items.drinking_glass},
      {items.water_bottle, items.empty_bottle},
    },
  })

for _,feather in pairs(items.feathers) do
  minetest.register_craft({
      output = "writing:feather_with_soot_ink",
      recipe = {
        {feather,},
        {"writing:soot_ink_bottle"},
      },
    })
end

minetest.register_craft({
    output = "writing:bucket_water_with_oak_gall_dust",
    recipe = {
      {"writing:dust_oak_ball", "writing:dust_oak_ball", "writing:dust_oak_ball"},
      {"writing:dust_oak_ball", "writing:dust_oak_ball", "writing:dust_oak_ball"},
      {"writing:dust_oak_ball", "group:water_bucket", "writing:dust_oak_ball"},
    },
  })

minetest.register_craft({
    output = "writing:soot_glue_glass",
    recipe = {
      {items.glue},
      {items.water_bottle},
      {"writing:soot_glass"},
    },
    replacements = {{items.water_bottle, items.empty_bottle}},
  })

for _,feather in pairs(items.feathers) do
  minetest.register_craft({
      output = "writing:feather_with_soot_glue",
      recipe = {
        {feather,},
        {"writing:soot_glue_glass"},
      },
    })
end

--[[
-- requires specialized machine
for _,oil in pairs(items.oils) do
  minetest.register_craft({
      type = "cooking",
      output = "writing:soot",
      recipe = oil,
      cooktime = 60,
    })
end
--]]
minetest.register_craft({
    type = "cooking",
    output = "writing:singed_steel_strip",
    recipe = "basic_materials:steel_strip",
    cooktime = 6000,
  })
minetest.register_craft({
    output = "writing:soot_glass",
    recipe = {
      {"writing:singed_steel_strip", "writing:singed_steel_strip", "writing:singed_steel_strip"},
      {"writing:singed_steel_strip", "writing:singed_steel_strip", "writing:singed_steel_strip"},
      {"writing:singed_steel_strip", items.drinking_glass, "writing:singed_steel_strip"},
    },
    replacements = {
      {"writing:singed_steel_strip", "basic_materials:steel_strip"},
      {"writing:singed_steel_strip", "basic_materials:steel_strip"},
      {"writing:singed_steel_strip", "basic_materials:steel_strip"},
      {"writing:singed_steel_strip", "basic_materials:steel_strip"},
      {"writing:singed_steel_strip", "basic_materials:steel_strip"},
      {"writing:singed_steel_strip", "basic_materials:steel_strip"},
      {"writing:singed_steel_strip", "basic_materials:steel_strip"},
      {"writing:singed_steel_strip", "basic_materials:steel_strip"},
    },
  })

minetest.register_craft({
    output = "writing:paper_written",
    recipe = {
      {items.paper},
    },
  })

minetest.register_craft({
    output = "writing:pencil_lead",
    recipe = {
      {items.lead},
      {"group:stick"},
    },
  })

minetest.register_craft({
    output = "writing:pencil_silver",
    recipe = {
      {items.silver},
      {"group:stick"},
    },
  })

minetest.register_craft({
    output = "writing:pencil_graphite",
    recipe = {
      {items.clay, items.graphite, items.clay},
      {"", "group:stick", ""},
    },
  })

minetest.register_craft({
    output = "writing:pencil_with_rubber",
    recipe = {
      {items.clay, items.graphite, items.clay},
      {"", "group:stick", ""},
      {"", items.rubber, ""},
    },
  })

minetest.register_craft({
    output = "writing:rubber",
    recipe = {
      {items.rubber},
      {items.rubber},
    },
  })

minetest.register_craft({
    output = "writing:scissors",
    recipe = {
      {"", items.steel, ""},
      {items.plastic_strip, "", items.steel},
      {"", items.plastic_strip, ""},
    },
  })

minetest.register_craft({
    output = "writing:bookbinding_table",
    recipe = {
      {items.wood, items.wood, items.wood},
      {items.stick, items.needle, items.stick},
      {items.stick, "writing:scissors", items.stick},
    },
  })

-- colored desks
if minetest.get_modpath("painting") then
  for color, hex in pairs(painting.hexcolors) do
    minetest.register_craft({
        output = minetest.itemstring_with_color("writing:book_desk", "#"..hex),
        recipe = {
          {"painting:water_color_"..color},
          {"writing:book_desk"},
        },
        replacements = {{"painting:water_color_"..color, items.drinking_glass}},
      })
  end
end


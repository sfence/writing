
local items = writing.items

minetest.register_craft({
    output = "writing:soot_ink_bottle",
    recipe = {
      {items.honey, items.egg, "writing:soot"},
      {"", items.water_bottle, ""},
      {"", items.glass_bottle, ""},
    },
    replacements = {{items.water_bottle, items.empty_bottle}},
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
    output = "writing:soot_glue_glass",
    recipe = {
      {items.glue, "writing:soot", items.glue},
      {"", items.water_bottle, ""},
      {"", items.drinking_glass, ""},
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

for _,oil in pairs(items.oils) do
  minetest.register_craft({
      type = "cooking",
      output = "writing:soot",
      recipe = oil,
      cooktime = 60,
    })
end

minetest.register_craft({
    output = "writing:paper_written",
    recipe = {
      {items.paper},
    },
  })

minetest.register_craft({
    output = "writing:papertag_written 4",
    recipe = {
      {"writing:paper_written"},
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
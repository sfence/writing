
local adaptation = writing.adaptation

local N = adaptation_lib.get_item_name

if (not adaptation_lib.check_keys_aviable("[writing] Crafting:", adaptation, {"group_stick", "group_wood"})) then
  return
end

adaptation_lib.check_keys_aviable("[writing] Crafting:", adaptation, {"water_bottle", "glass_bottle", "drinking_glass", "feathers", "glue", "paper", "graphite"})


minetest.register_craft({
    output = "writing:soot_ink_bottle",
    recipe = {
      {"group:honey", "group:egg", "writing:soot_glass"},
      {"", N(adaptation.water_bottle), ""},
      {"", N(adaptation.glass_bottle), ""},
    },
    replacements = adaptation_lib.get_craft_replacements(
      {{"writing:soot_glass", N(adaptation.drinking_glass)}},
      {adaptation.water_bottle}),
  })

for _,feather in pairs(adaptation.feathers) do
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
      {N(adaptation.glue)},
      {N(adaptation.water_bottle)},
      {"writing:soot_glass"},
    },
    replacements = adaptation_lib.get_craft_replacements(
      nil, {adaptation.water_bottle}),
  })

for _,feather in pairs(adaptation.feathers) do
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
for _,oil in pairs(adaptation.oils) do
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
      {"writing:singed_steel_strip", N(adaptation.drinking_glass), "writing:singed_steel_strip"},
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
      {N(adaptation.paper)},
    },
  })

if adaptation.lead then
  minetest.register_craft({
      output = "writing:pencil_lead",
      recipe = {
        {N(adaptation.lead)},
        {adaptation.group_stick},
      },
    })
end

if adaptation.silver then
  minetest.register_craft({
      output = "writing:pencil_silver",
      recipe = {
        {N(adaptation.silver)},
        {adaptation.group_stick},
      },
    })
end

minetest.register_craft({
    output = "writing:pencil_graphite",
    recipe = {
      {N(adaptation.clay), N(adaptation.graphite), N(adaptation.clay)},
      {"", adaptation.group_stick, ""},
    },
  })

minetest.register_craft({
    output = "writing:pencil_with_rubber",
    recipe = {
      {N(adaptation.clay), N(adaptation.graphite), N(adaptation.clay)},
      {"", adaptation.group_stick, ""},
      {"", N(adaptation.rubber), ""},
    },
  })

minetest.register_craft({
    output = "writing:rubber",
    recipe = {
      {N(adaptation.rubber)},
      {N(adaptation.rubber)},
    },
  })

minetest.register_craft({
    output = "writing:scissors",
    recipe = {
      {"", N(adaptation.steel), ""},
      {N(adaptation.plastic_strip), "", N(adaptation.steel)},
      {"", N(adaptation.plastic_strip), ""},
    },
  })

minetest.register_craft({
    output = "writing:bookbinding_table",
    recipe = {
      {adaptation.group_wood, adaptation.group_wood, adaptation.group_wood},
      {adaptation.group_stick, N(adaptation.needle), adaptation.group_stick},
      {adaptation.group_stick, "writing:scissors", adaptation.group_stick},
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
        replacements = {{"painting:water_color_"..color, N(adaptation.drinking_glass)}},
      })
  end
end


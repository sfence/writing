
writing.items = {}
writing.textures = {}

local items = writing.items
local textures = writing.textures

items.feathers = {}
items.oils = {}

items.paper = "default:paper"
items.lead = "technic:lead_ingot"
items.silver = "moreores:silver_ingot"
items.clay = "default:clay_lump"
items.graphite = "technic:graphite"

items.glass_bottle = "vessels:glass_bottle"
items.drinking_glass = "vessels:drinking_glass"
items.water_bottle = "bucket:bucket_water"
items.empty_bottle = "bucket:bucket_empty"

items.egg = "--unknown--"
items.honey = "--unknown--"
items.glue = "mesecons_materials:glue"

if minetest.get_modpath("animalia") then
  table.insert(items.feathers, "animalia:feather")
  textures.feather = "animalia_feather.png"
elseif minetest.get_modpath("hades_animalia") then
  table.insert(items.feathers, "hades_animalia:feather")
  textures.feather = "animalia_feather.png"
end

if minetest.get_modpath("mobs_animal") or minetest.get_modpath("hades_animals") then
  table.insert(items.feathers, "mobs:chicken_feather")
  textures.feather = "mobs_chicken_feather.png"
  items.egg = "mobs:egg"
  items.honey = "mobs:honey"
end

if minetest.registered_items["farming:glass_water"] then
  items.glass_bottle = "vessels:glass_bottle"
  items.water_bottle = "farming:glass_water"
  items.empty_bottle = "vessels:drinking_glass"
  table.insert(items.oils, "farming:hemp_oil")
  table.insert(items.oils, "farming:sunflower_oil")
end

if minetest.get_modpath("hades_core") then
  items.paper = "hades_core:paper"
end

if minetest.get_modpath("hades_food") then
  table.insert(items.oils, "hades_food:bottle_olive_oil")
end

if minetest.get_modpath("hades_bucket") then
  items.water_bottle = "hades_bucket:bucket_water"
  items.empty_bottle = "hades_bucket:bucket_empty"
end

if minetest.registered_items["hades_extrafarming:glass_water"] then
  items.glass_bottle = "vessels:glass_bottle"
  items.water_bottle = "hades_extrafarming:glass_water"
  items.empty_bottle = "vessels:drinking_glass"
  table.insert(items.oils, "hades_extrafarming:hemp_oil")
  table.insert(items.oils, "hades_extrafarming:sunflower_oil")
end

if minetest.get_modpath("hades_technic") then
  items.lead = "hades_technic:lead_ingot"
end

if minetest.get_modpath("hades_extraores") then
  items.silver = "hades_extraores:silver_ingot"
end
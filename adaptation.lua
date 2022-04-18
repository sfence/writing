
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
items.rubber = "technic:rubber"

items.stick = "group:stick"
items.wood = "group:wood"
items.needle = "default:steel_ingot"
items.steel = "default:steel_ingot"
items.plastic_strip = "basic_materials:plastic_strip"

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
  items.clay = "hades_core:clay_lump"
  items.needle = "hades_core:steel_ingot"
  items.steel = "hades_core:steel_ingot"
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

if minetest.get_modpath("technic") then
  items.steel = "technic:carbon_steel_ingot"
end

if minetest.get_modpath("hades_technic") then
  items.lead = "hades_technic:lead_ingot"
  items.graphite = "hades_technic:graphite"
  items.rubber = "hades_technic:rubber"
  items.steel = "hades_technic:carbon_steel_ingot"
end

if minetest.get_modpath("hades_extraores") then
  items.silver = "hades_extraores:silver_ingot"
end

if minetest.get_modpath("clothing") then
  items.yarn = "clothing:yarn_spool_white"
  items.yarn_spool_empty = "clothing:yarn_spool_empty"
  items.needle = "clothing:bone_needle"
end
if minetest.get_modpath("hades_clothing") then
  items.yarn = "hades_clothing:yarn_spool_white"
  items.yarn_spool_empty = "hades_clothing:yarn_spool_empty"
  items.needle = "hades_clothing:bone_needle"
end


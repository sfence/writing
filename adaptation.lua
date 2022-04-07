
writing.items = {}
writing.textures = {}

local items = writing.items
local textures = writing.textures

items.feathers = {}

items.glass_bottle = "vessels:glass_bottle"
items.water_bottle = "bucket:bucket_water"
items.empty_bottle = "bucket:bucket_empty"

items.egg = "--unknown--"
items.honey = "--unknown--"

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
  items.empty_bottle = "vessels:glass_bottle"
end

if minetest.registered_items["hades_extrafarming:glass_water"] then
  items.glass_bottle = "vessels:glass_bottle"
  items.water_bottle = "hades_extrafarming:glass_water"
  items.empty_bottle = "vessels:glass_bottle"
end


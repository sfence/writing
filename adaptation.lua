
writing.items = {}
writing.textures = {}

local items = writing.items
local textures = writing.textures

items.feathers = {}

if minetest.get_modpath("animalia") then
  table.insert(items.feathers, "animalia:feather")
  textures.feather = "animalia_feather.png"
elseif minetest.get_modpath("hades_animalia") then
  table.insert(items.feathers, "hades_animalia:feather")
  textures.feather = "animalia_feather.png"
end

if minetest.get_modpath("mobs_animal") then
  table.insert(items.feathers, "mobs:chicken_feather")
  textures.feather = "mobs_chicken_feather.png"
elseif minetest.get_modpath("hades_animals") then
  table.insert(items.feathers, "mobs:chicken_feather")
  textures.feather = "mobs_chicken_feather.png"
end


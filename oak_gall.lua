
local S = writing.translator

if minetest.get_modpath("oak") or minetest.get_modpath("hades_oak") then
  -- leaves with oak gall

  minetest.register_node("writing:oak_leaves_gall_1", {
      description = S("Oak Leaves with Gall"),
      drawtype = "allfaces_optional",
      tiles = {"oak_leaves.png^writing_oak_gall_1.png"},
      paramtype = "light",
      walkable = true,
      waving = 1,
      groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2, not_in_creative_inventory = 1, oak_gall = 1},
      drop = {
        max_items = 1,
        items = {
          {items = {"oak:sapling"}, rarity = 20},
          {items = {"oak:leaves"}}
        }
      },
      sounds = default.node_sound_leaves_defaults(),
    })

  minetest.register_node("writing:oak_leaves_gall_2", {
      description = S("Oak Leaves with Gall"),
      drawtype = "allfaces_optional",
      tiles = {"oak_leaves.png^writing_oak_gall_2.png"},
      paramtype = "light",
      walkable = true,
      waving = 1,
      groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2, not_in_creative_inventory = 1, oak_gall = 1},
      drop = {
        max_items = 1,
        items = {
          {items = {"oak:sapling"}, rarity = 20},
          {items = {"oak:leaves"}}
        }
      },
      sounds = default.node_sound_leaves_defaults(),
    })

  minetest.register_node("writing:oak_leaves_gall_3", {
      description = S("Oak Leaves with Gall"),
      drawtype = "allfaces_optional",
      tiles = {"oak_leaves.png^writing_oak_gall_3.png"},
      paramtype = "light",
      walkable = true,
      waving = 1,
      groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2, not_in_creative_inventory = 1, oak_gall = 1},
      drop = {
        max_items = 1,
        items = {
          {items = {"oak:sapling"}, rarity = 20},
          {items = {"oak:leaves","writing:oak_gall"}}
        }
      },
      sounds = default.node_sound_leaves_defaults(),
    })
  
  minetest.register_craftitem("writing:oak_gall", {
      description = S("Oak Gall"),
      inventory_image = "writing_oak_gall.png",
    }}
  
  minetest.register_abm({
      name = "Create oak gall",
      nodes = {"oak:leaves"},
      interval = 370,
      chance = 47,
      action = function (pos)
        minetest.set_node(pos, {name="writing:oak_leaves_gall_1"})
      end,
    })
  minetest.register_abm({
      name = "Kill oak gall",
      nodes = {"group:oak_gall"},
      interval = 410,
      chance = 127,
      action = function (pos)
        minetest.swap_node(pos, {name="oak:leaves"})
      end,
    })
end

local S = writing.translator

if minetest.get_modpath("oak") or minetest.get_modpath("hades_oak") then
  -- leaves with oak gall
  
  local leaves_sounds = nil
  
  if minetest.get_modpath("sounds") then
  elseif minetest.get_modpath("default") then
    leaves_sounds = default.node_sound_leaves_defaults()
  elseif minetest.get_modpath("hades_sounds") then
    leaves_sounds = hades_sounds.node_sound_leaves_defaults()
  end
  
  local gall_on_punch = function (pos, node, puncher)
    local def = minetest.registered_nodes[node.name]
    node.name = "oak:leaves"
    minetest.swap_node(pos, node)
    if def._next_grow_node==node.name then
      -- drop oak gall
      local drop = ItemStack("writing:oak_gall")
      if puncher then
        local inv = puncher:get_inventory()
        drop = inv:add_item("main", drop)
      end
      if drop:get_count()>0 then
        minetest.add_item(pos, drop)
      end
    end
  end

  minetest.register_node("writing:oak_leaves_gall_1", {
      description = S("Oak Leaves with Gall"),
      drawtype = "allfaces_optional",
      tiles = {"oak_leaves.png^writing_oak_gall_1.png"},
      paramtype = "light",
      walkable = true,
      waving = 1,
      groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2, not_in_creative_inventory = 1, oak_gall = 1},
      _hades_trees_trunk = "oak:trunk",
      drop = {
        max_items = 1,
        items = {
          {items = {"oak:sapling"}, rarity = 20},
          {items = {"oak:leaves"}}
        }
      },
      sounds = leaves_sounds,
      on_punch = gall_on_punch,
      _next_grow_node = "writing:oak_leaves_gall_2",
    })

  minetest.register_node("writing:oak_leaves_gall_2", {
      description = S("Oak Leaves with Gall"),
      drawtype = "allfaces_optional",
      tiles = {"oak_leaves.png^writing_oak_gall_2.png"},
      paramtype = "light",
      walkable = true,
      waving = 1,
      groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2, not_in_creative_inventory = 1, oak_gall = 1},
      _hades_trees_trunk = "oak:trunk",
      drop = {
        max_items = 1,
        items = {
          {items = {"oak:sapling"}, rarity = 20},
          {items = {"oak:leaves"}}
        }
      },
      sounds = leaves_sounds,
      on_punch = gall_on_punch,
      _next_grow_node = "writing:oak_leaves_gall_3",
    })

  minetest.register_node("writing:oak_leaves_gall_3", {
      description = S("Oak Leaves with Gall"),
      drawtype = "allfaces_optional",
      tiles = {"oak_leaves.png^writing_oak_gall_3.png"},
      paramtype = "light",
      walkable = true,
      waving = 1,
      groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2, not_in_creative_inventory = 1, oak_gall = 1},
      _hades_trees_trunk = "oak:trunk",
      drop = {
        max_items = 1,
        items = {
          {items = {"oak:sapling"}, rarity = 20},
          {items = {"oak:leaves"}},
        }
      },
      sounds = leaves_sounds,
      on_punch = gall_on_punch,
      _next_grow_node = "oak:leaves",
    })
  
  minetest.register_craftitem("writing:oak_gall", {
      description = S("Oak Gall"),
      inventory_image = "writing_oak_gall.png",
    })
  
  minetest.register_abm({
      label = "Create oak gall",
      nodenames = {"oak:leaves"},
      interval = 370,
      chance = 127,
      action = function (pos)
        -- check light level?
        minetest.set_node(pos, {name="writing:oak_leaves_gall_1"})
      end,
    })
  minetest.register_abm({
      label = "Grow and kill oak gall",
      nodenames = {"group:oak_gall"},
      interval = 410,
      chance = 13,
      action = function (pos)
        local node = minetest.get_node(pos)
        if (node.param2==0) then
          local def = minetest.registered_nodes[node.name]
          node.name = def._next_grow_node
          minetest.swap_node(pos, node)
        end
      end,
    })
end

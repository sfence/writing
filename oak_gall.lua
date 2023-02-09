
local S = writing.translator

-- leaves with oak gall

local gall_on_punch = function (pos, node, puncher)
  local def = minetest.registered_nodes[node.name]
  node.name = def._no_gall_node
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

minetest.register_alias("writing:oak_leaves_gall_1", "oak:leaves_gall_1")
minetest.register_alias("writing:oak_leaves_gall_2", "oak:leaves_gall_2")
minetest.register_alias("writing:oak_leaves_gall_3", "oak:leaves_gall_3")

for _,oak_leaves in pairs(writing.adaptation.oak_leaves) do
  local odef = minetest.registered_nodes[oak_leaves]
  local ndef = table.copy(odef)
  
  local gall = oak_leaves.."_gall_"
  
  ndef.description = S("Oak Leaves with Gall")
  ndef.tiles[1] = odef.tiles[1].."^writing_oak_gall_1.png"
  ndef.groups = ndef.groups or {}
  ndef.groups.not_in_creative_inventory = 1
  ndef.groups.oak_gall = 1
  ndef.on_punch = gall_on_punch
  ndef._next_grow_node = gall.."2"
  ndef._no_gall_node = oak_leaves..""
  minetest.register_node(":"..gall.."1", table.copy(ndef))

  ndef.tiles[1] = odef.tiles[1].."^writing_oak_gall_2.png"
  ndef._next_grow_node = gall.."3"
  minetest.register_node(":"..gall.."2", table.copy(ndef))

  ndef.tiles[1] = odef.tiles[1].."^writing_oak_gall_2.png"
  ndef._next_grow_node = oak_leaves..""
  minetest.register_node(":"..gall.."3", table.copy(ndef))
end

minetest.register_craftitem("writing:oak_gall", {
    description = S("Oak Gall"),
    inventory_image = "writing_oak_gall.png",
  })

minetest.register_abm({
    label = "Create oak gall",
    nodenames = writing.adaptation.oak_leaves,
    interval = 370,
    chance = 233,
    action = function (pos, node)
      -- check light level?
      minetest.set_node(pos, {name=node.name.."_gall_1"})
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


local wooden_tub_oak_gall_ink_def = clothing_machines.base_node_def_wooden_tub_fill()

wooden_tub_oak_gall_ink_def.description = S("Wooden Tub Filled With Oak Gall Ink")
wooden_tub_oak_gall_ink_def.short_description = wooden_tub_oak_gall_ink_def.description
wooden_tub_oak_gall_ink_def.tiles[2] = "writing_fill_oak_gall_ink.png"

wooden_tub_oak_gall_ink_def = appliances.item_def_with_help(wooden_tub_oak_gall_ink_def, S("Empty it by empty bucket."))

wooden_tub_oak_gall_ink_def.can_dig = function() return false; end
wooden_tub_oak_gall_ink_def.on_punch = function(pos, node, puncher, pointed_thing)
  clothing_machines.wooden_tub_empty_on_punch(pos, node, puncher, pointed_thing, adaptation.bucket_empty, "clothing_machines:bucket_dirty_water")
end
wooden_tub_oak_gall_ink_def.allow_metadata_inventory_move = function() return 0; end
wooden_tub_oak_gall_ink_def.allow_metadata_inventory_put = function() return 0; end
wooden_tub_oak_gall_ink_def.on_metadata_inventory_take = function(pos)
  local meta = minetest.get_meta(pos);
  meta:set_string("formspec", "");
end

minetest.register_node("writing:wooden_tub_oak_gall_ink", wooden_tub_oak_gall_ink_def)


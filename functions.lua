
-- some sharable functions 

writing.on_use_write_tool = function(itemstack, user, pointed_thing)
  local index = user:get_wield_index()
  index = index + writing.next_inv_row
  local inv = user:get_inventory()
  local under = inv:get_stack("main", index)
  local def = under:get_definition()
  if def and def._get_writing_formspec then
    local formspec = def._get_writing_formspec(under)
    minetest.show_formspec(user:get_player_name(), "writing:write", formspec)
  end
end

minetest.register_on_player_receive_fields(function(player, formname, field)
  if formname ~= "writing:write" then return end
  print(dump(field))
  local itemstack = player:get_wielded_item()
  local index = player:get_wield_index()
  index = index + writing.next_inv_row
  local inv = player:get_inventory()
  local under = inv:get_stack("main", index)
  local def = under:get_definition()
  if def and def._writing_receive_fields then
    def._writing_receive_fields(itemstack, under, field)
    inv:set_stack("main", index, under)
    print(dump(under:to_table()))
    player:set_wielded_item(itemstack)
  else
    minetest.log("error", "Missing _writing_receive_fields callback for item "..under:get_name()..".")
  end
end)

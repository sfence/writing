
-- some sharable functions 

writing.on_use_write_tool = function(itemstack, user, pointed_thing)
  local index = user:get_wield_index()
  index = index + writing.next_inv_row
  local inv = user:get_inventory()
  local under = inv:get_stack("main", index)
  local def = under:get_definition()
  if def and def._writable then
    local formspec = def._writable.get_writing_formspec(under)
    minetest.show_formspec(user:get_player_name(), "writing:write", formspec)
  end
end

minetest.register_on_player_receive_fields(function(player, formname, field)
  if formname ~= "writing:write" then return end
  --minetest.log("warning", dump(field))
  local itemstack = player:get_wielded_item()
  local index = player:get_wield_index()
  index = index + writing.next_inv_row
  local inv = player:get_inventory()
  local under = inv:get_stack("main", index)
  local def = under:get_definition()
  if def and def._writable then
    def._writable.writing_receive_fields(itemstack, under, field)
    inv:set_stack("main", index, under)
    --print(dump(under:to_table()))
    player:set_wielded_item(itemstack)
    if not field.quit then
      local formspec = def._writable.get_writing_formspec(under)
      minetest.show_formspec(player:get_player_name(), "writing:write", formspec)
    end
  else
    minetest.log("error", "Missing _writing_receive_fields callback for item "..under:get_name()..".")
  end
end)

local emptyChars = {[" "]=true, ["\n"]=true}

function writing.smartTextUpdate(textA, textB, doAdd, doRemove, doChange)
  local added = 0
  local removed = 0
  local changed = 0
  local out_text = ""
  local lenA = string.len(textA)
  local lenB = string.len(textB)
  local lenUse = lenA
  if lenA > lenB then
    lenUse = lenB
  end
  for ia = 0, lenUse do
    local a = textA:sub(ia, ia)
    local b = textB:sub(ia, ia)
    if a==b then
      out_text = out_text..a
    else
      if doChange or doRemove then
        if a==" " then
          if doChange then
            out_text = out_text..b
            changed = changed + 1
          else
            out_text = out_text..a
          end
        else
          if doRemove and doChange then
            out_text = out_text..b
            removed = removed + 1
            changed = changed + 1
          elseif doRemove then
            out_text = out_text.." "
            removed = removed + 1
          else--if doChange then
            out_text = out_text..utf8.char(0x338)..a
            -- may be \U334 or \U335 or \U336 or \U337 or \U338
            --out_text = out_text .. utf8.char(0x25AE) -- black rectange
            --out_text = out_text .. utf8.char(0x2573) -- cross
            changed = changed + 1
          end
        end
      else
        out_text = out_text..a
      end
    end
  end
  if (lenB > lenA) and doAdd then
    for ia = lenA+1, lenB do
      local b = textB:sub(ia, ia)
      if not emptyChars[b] then
        added = added + 1
      end
      out_text = out_text..b
    end
  end
  if (lenA > lenB) then
    for ia = lenB+1, lenA do
      local a = textA:sub(ia, ia)
      if doRemove then
        if not emptyChars[a] then
          removed = removed + 1
        end
      else
        out_text = out_text..a
      end
    end
  end
  return {
      added = added,
      removed = removed,
      changed = changed,
      out_text = out_text,
    }
end

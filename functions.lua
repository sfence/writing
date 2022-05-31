
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
    minetest.log("error", "Missing _writable in definition for item "..under:get_name()..".")
  end
end)

local emptyChars = {[" "]=true, ["\n"]=true}
local endLineChars = {["\n"]=true}

function writing.trimText(text, max_lines, max_line_chars)
  local lenUse = string.len(text)
  local out_text = ""
  local line_chars = 0
  local lines = 0
  
  for i = 0, lenUse do
    local ch = text:sub(i, i)
    if endLineChars[ch] then
      line_chars = 0
      lines = lines + 1
      if lines >= max_lines then
        return out_text
      end
      out_text = out_text..ch
    else
      if line_chars<max_line_chars then
        out_text = out_text..ch
      end
      line_chars = line_chars + 1
      -- 0xxxxxxx
      -- 10xxxxxx -> end of UTF8 character
    end
  end
  
  return out_text
end


writing.change_char = nil

if writing.settings.change_char~="" then
  writing.change_char = function (ch)
    --return "\u{338}"..ch
    --return "\u{25AE}"
    return writing.settings.change_char
  end
end

function writing.smartTextUpdate(textA, textB, doAdd, doRemove, doChange)
  local added = 0
  local removed = 0
  local changed = 0
  local out_text = ""
  local lenA = string.len(textA)
  local lenB = string.len(textB)
  local ia = 0
  local ib = 0
  while (ia<lenA) and (ib<lenB) do
    ia = ia + 1
    ib = ib + 1
    local a = textA:sub(ia, ia)
    local b = textB:sub(ib, ib)
    if a==b then
      out_text = out_text..a
    else
      if endLineChars[a] then
        if doAdd then
          out_text = out_text..b
          if endLineChars[b] then
            added = added + 1
          end
        end
        while (ib<lenB) do
          ib = ib + 1
          b = textB:sub(ib, ib)
          if doAdd then
            out_text = out_text..b
            if endLineChars[b] then
              added = added + 1
            end
          end
          if endLineChars[b] then
            break
          end
        end
      elseif endLineChars[b] then
        if doRemove then
          out_text = out_text..b
          if not emptyChars[a] then
            removed = removed + 1
          end
        else
          out_text = out_text..a
        end
        while (ia<lenA) do
          ia = ia + 1
          a = textA:sub(ia, ia)
          if doRemove then
            if not emptyChars[a] then
              removed = removed + 1
            end
          else
            out_text = out_text..a
          end
          if endLineChars[a] then
            break
          end
        end
      elseif emptyChars[a] then
        if doAdd then
          out_text = out_text..b
          added = added + 1
        else
          out_text = out_text..a
        end
      else
        if doChange and writing.change_char then
          --out_text = out_text..utf8.char(0x338)..a
          -- may be \U334 or \U335 or \U336 or \U337 or \U338
          --out_text = out_text .. utf8.char(0x25AE) -- black rectange
          --out_text = out_text .. utf8.char(0x2573) -- cross
          out_text = out_text..(writing.change_char(a))
          changed = changed + 1
        elseif doAdd and doRemove then
          out_text = out_text..b
          added = added + 1
          removed = removed + 1
        else
          out_text = out_text..a
        end
      end
    end
  end
  while ib < lenB do
    ib = ib + 1
    local b = textB:sub(ib, ib)
    if doAdd then
      if not emptyChars[b] then
        added = added + 1
      end
      out_text = out_text..b
    end
  end
  while ia < lenA do
    ia = ia + 1
    local a = textA:sub(ia, ia)
    if doRemove then
      if not emptyChars[a] then
        removed = removed + 1
      end
    else
      out_text = out_text..a
    end
  end
  return {
      added = added,
      removed = removed,
      changed = changed,
      out_text = out_text,
    }
end
function writing.smartCharCount(text)
  local chars = 0
  local lenUse = string.len(text)
  for ia = 0, lenUse do
    local a = text:sub(ia, ia)
    if not emptyChars[a] then
      chars = chars + 1
    end
  end
  return chars
end

function writing.toolIsUsable(writing_tool, writable_item)
  local tool_def = writing_tool:get_definition()
  local item_def
  
  if type(writable_item)=="string" then
    item_def = minetest.registered_items[writable_item]
  else
    item_def = writable_item:get_definition()
  end
  
  if not tool_def._writing_tool then
    return false
  end
  if not item_def._writable then
    return false
  end
  for material,level in pairs(tool_def._writing_tool.materials) do
    local check = item_def._writable.materials[material]
    if check and (check<=level) then
      return true
    end
  end
  return false
end
function writing.toolTextUpdate(writing_tool, old_text, new_text)
  local def = writing_tool:get_definition()
  local doAdd = false
  local doRemove = false
  local doChange = false
  if def._writing_tool.cost_per_add>0 then
    doAdd = true
  end
  if def._writing_tool.cost_per_remove>0 then
    doRemove = true
    --minetest.log("warning","Enable remove: "..dump(def._writing_tool))
  end
  if def._writing_tool.cost_per_change>0 then
    doChange = true
  end
  local updated_text = writing.smartTextUpdate(old_text, new_text, doAdd, doRemove, doChange)
  --minetest.log("warning","Smart update: "..dump(updated_text))
  --meta:set_string("infotext", updated_text.out_text)
  if updated_text.added>0 then
    writing_tool:add_wear(math.ceil(def._writing_tool.cost_per_add*updated_text.added))
  end
  if updated_text.removed>0 then
    writing_tool:add_wear(math.ceil(def._writing_tool.cost_per_remove*updated_text.removed))
  end
  if updated_text.changed>0 then
    writing_tool:add_wear(math.ceil(def._writing_tool.cost_per_change*updated_text.changed))
  end
  if (writing_tool:get_count()==0) and def._writing_tool.break_stack then
    writing_tool:replace(def._writing_tool.break_stack)
  end
  return updated_text.out_text
end
function writing.toolTextRewrite(writing_tool, text)
  local def = writing_tool:get_definition()
  if not def._writing_tool then
    return false
  end
  local doAdd = false
  local doRemove = false
  if def._writing_tool.cost_per_add>0 then
    doAdd = true
  end
  if def._writing_tool.cost_per_remove>0 then
    doRemove = true
  end
  if doAdd and doRemove then
    rewrite = writing.smartCharCount(text)
    if new_text.added>0 then
      writing_tool:add_wear(math.ceil(def._writing_tool.cost_per_add*rewrite))
    end
    if new_text.removed>0 then
      writing_tool:add_wear(math.ceil(def._writing_tool.cost_per_remove*rewrite))
    end
    if (writing_tool:get_count()==0) and def._writing_tool.break_stack then
      writing_tool:replace(def._writing_tool.break_stack)
    end
    return true
  else
    return false
  end
end

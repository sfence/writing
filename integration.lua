
local function update_sign(name)
  local def = minetest.registered_nodes[name]
  if def then
    minetest.override_item(name, {
        on_receive_fields = function(pos, formname, fields, sender)
          local player_name = sender:get_player_name()
          if minetest.is_protected(pos, player_name) then
            minetest.record_protection_violation(pos, player_name)
            return
          end
          local text = fields.text
          if not text then
            return
          end
          local old_text = meta:get_string("infotext")
          if string.cmp(text, old_text)==0 then
            return
          end
          local itemstack = sender:get_wielded_item()
          local def = itemstack:get_definition()
          if not def._writing_tool then
            minetest.chat_send_player(player_name, S("Ops. I have nothing to write!"))
            return
          end
          if string.len(text) > 512 then
            minetest.chat_send_player(player_name, S("Text too long"))
            return
          end
          local doAdd = false
          local doRemove = false
          if def._writing_tool._cost_per_add>0 then
            doAdd = true
          end
          if def._writing_tool._cost_per_remove>0 then
            doRemove = true
            --minetest.log("warning","Enable remove: "..dump(def._writing_tool))
          end
          local doChange = doAdd and doRemove
          local new_text = writing.smartTextUpdate(old_text, text, doAdd, doRemove, doChange)
          --minetest.log("warning","Smart update: "..dump(new_text))
          meta:set_string("infotext", new_text.out_text)
          if new_text.added>0 then
            itemstack:add_wear(def._writing_tool._cost_per_add*new_text.added)
          end
          if new_text.removed>0 then
            itemstack:add_wear(def._writing_tool._cost_per_remove*new_text.removed)
          end
          minetest.log("action", player_name .. " wrote \"" .. text ..
            "\" to the sign at " .. minetest.pos_to_string(pos))
          local meta = minetest.get_meta(pos)
          meta:set_string("text", text)
        end,
      })
  end
end

if minetest.get_modpath("default") then
  update_sign("default:sign_wall_wood")
  update_sign("default:sign_wall_steel")
end
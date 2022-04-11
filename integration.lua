
local S = writing.translator

-- signs integration
if minetest.get_modpath("signs_lib") then
  if not minetest.get_modpath("hades_core") then
    -- common signs lib
    local function get_sign_formspec(pos, nodename)

    local meta = minetest.get_meta(pos)
    local txt = meta:get_string("text")
      local state = meta:get_int("unifont") == 1 and "on" or "off"

      local formspec = {
        "size[6,4]",
        "background[-0.5,-0.5;7,5;signs_lib_sign_bg.png]",
        "image[0.1,2.4;7,1;signs_lib_sign_color_palette.png]",
        "textarea[0.15,-0.2;6.3,2.8;text;;" .. minetest.formspec_escape(txt) .. "]",
        "button_exit[3.7,3.4;2,1;ok;" .. S("Write") .. "]",
        "label[0.3,3.4;Unicode font]",
        "image_button[0.6,3.7;1,0.6;signs_lib_switch_" .. state .. ".png;uni_"
          .. state .. ";;;false;signs_lib_switch_interm.png]",
      }

      if minetest.registered_nodes[nodename].allow_widefont then
        state = meta:get_int("widefont") == 1 and "on" or "off"
        formspec[#formspec+1] = "label[2.1,3.4;Wide font]"
        formspec[#formspec+1] = "image_button[2.3,3.7;1,0.6;signs_lib_switch_" .. state .. ".png;wide_"
            .. state .. ";;;false;signs_lib_switch_interm.png]"
      end

      return table.concat(formspec, "")
    end
    
    minetest.register_on_player_receive_fields(function(player, formname, fields)

      if formname ~= "writing:sign" then return end

      local pos_string = player:get_meta():get_string("signslib:pos")
      local pos = minetest.string_to_pos(pos_string)
      local playername = player:get_player_name()
      local itemstack = player:get_wielded_item()

      if fields.text and fields.ok then
        local node = minetest.get_node(pos)
        if writing.toolIsUsable(itemstack, node.name) then
          local meta = minetest.get_meta(pos)
          fields.text = writing.toolTextUpdate(itemstack, meta:get_string("text"), fields.text)
          minetest.log("action", S("@1 wrote \"@2\" to sign at @3",
            (playername or ""),
            fields.text:gsub('\\', '\\\\'):gsub("\n", "\\n"),
            pos_string
          ))
          signs_lib.update_sign(pos, fields)
        else
          minetest.chat_send_player(playername, S("Ops. I need something to write!"))
        end
      elseif fields.wide_on or fields.wide_off or fields.uni_on or fields.uni_off then
        local node = minetest.get_node(pos)
        local meta = minetest.get_meta(pos)
        local change_wide
        local change_uni
        local new_wide
        local new_uni

        if fields.wide_on and meta:get_int("widefont") == 1 then
          --meta:set_int("widefont", 0)
          change_wide = true
          new_wide = 0
        elseif fields.wide_off and meta:get_int("widefont") == 0 then
          --meta:set_int("widefont", 1)
          change_wide = true
          new_wide = 1
        end
        if fields.uni_on and meta:get_int("unifont") == 1 then
          --meta:set_int("unifont", 0)
          change_uni = true
          new_uni = 0
        elseif fields.uni_off and meta:get_int("unifont") == 0 then
          --meta:set_int("unifont", 1)
          change_uni = true
          new_uni = 1
        end

        if change_wide then
          if writing.toolTextRewrite(itemstack, meta:get_string("text")) then
            minetest.log("action", S("@1 flipped the wide-font switch to \"@2\" at @3",
              (playername or ""),
              (fields.wide_on and "off" or "on"),
              minetest.pos_to_string(pos)
            ))
            meta:set_int("widefont", new_wide)
            signs_lib.update_sign(pos, fields)
            minetest.show_formspec(playername, "signs_lib:sign", get_sign_formspec(pos, node.name))
          else
            minetest.chat_send_player(playername, S("I need something what can write and erase."))
          end
        end
        if change_uni then
          if writing.toolTextRewrite(itemstack, meta:get_string("text")) then
            minetest.log("action", S("@1 flipped the unicode-font switch to \"@2\" at @3",
              (playername or ""),
              (fields.uni_on and "off" or "on"),
              minetest.pos_to_string(pos)
            ))
            meta:set_int("unifont", new_uni)
            signs_lib.update_sign(pos, fields)
            minetest.show_formspec(playername, "signs_lib:sign", get_sign_formspec(pos, node.name))
          else
            minetest.chat_send_player(playername, S("I need something what can write and erase."))
          end
        end
      end
    end)
    
    local function rightclick_sign(pos, node, player, itemstack, pointed_thing)

      if not player or not signs_lib.can_modify(pos, player) then return end
      if not player.get_meta then return end

      player:get_meta():set_string("signslib:pos", minetest.pos_to_string(pos))
      minetest.show_formspec(player:get_player_name(), "writing:sign", get_sign_formspec(pos, node.name))
    end
    
    local function update_sign(name, writable)
      local def = minetest.registered_nodes[name]
      if def then
        minetest.override_item(name, {
            on_rightclick = rightclick_sign,
            _writable = writable,
          })
      end
    end
    local function update_signs(prefix, base, writable)
      local ubase = ""
      if base~="" then
        ubase = "_"..base
      end
      update_sign(prefix.."_wall"..ubase, writable)
      update_sign(prefix..ubase.."_onpole", writable)
      update_sign(prefix..ubase.."_onpole_horiz", writable)
      update_sign(prefix..ubase.."_hanging", writable)
      update_sign(prefix..ubase.."_yard", writable)
    end
    
    update_signs("default:sign", "wood", {materials={wood=1}})
    update_signs("default:sign", "steel", {materials={steel=1}})
    
    if minetest.get_modpath("basic_signs") then
      update_signs("basic_signs:sign", "locked", {materials={wood=1}})
      
      update_signs("basic_signs:sign", "steel_green", {materials={steel=1}})
      update_signs("basic_signs:sign", "steel_yellow", {materials={steel=1}})
      update_signs("basic_signs:sign", "steel_red", {materials={steel=1}})
      update_signs("basic_signs:sign", "steel_white_red", {materials={steel=1}})
      update_signs("basic_signs:sign", "steel_white_black", {materials={steel=1}})
      update_signs("basic_signs:sign", "steel_orange", {materials={steel=1}})
      update_signs("basic_signs:sign", "steel_blue", {materials={steel=1}})
      update_signs("basic_signs:sign", "steel_brown", {materials={steel=1}})
      
      update_signs("basic_signs:sign", "glass", {materials={glass=1}})
      update_signs("basic_signs:sign", "obsidian_glass", {materials={glass=1}})
      update_signs("basic_signs:sign", "plastic", {materials={plastic=1}})
    end
    
    --[[
    update_signs("signs_lib:sign", "", {materials={wood=1}})
    update_signs("signs_lib:sign", "locked", {materials={wood=1}})
    update_signs("signs_lib:sign", "steel_green", {materials={steel=1}})
    update_signs("signs_lib:sign", "steel_yellow", {materials={steel=1}})
    update_signs("signs_lib:sign", "steel_red", {materials={steel=1}})
    update_signs("signs_lib:sign", "steel_white_red", {materials={steel=1}})
    update_signs("signs_lib:sign", "steel_white_black", {materials={steel=1}})
    --]]
  else
    -- hades signs_lib version  
    function signs_lib.receive_fields(pos, formname, fields, sender, lock)
      if minetest.is_protected(pos, sender:get_player_name()) and not minetest.check_player_privs(sender:get_player_name(), "protection_bypass") then
        minetest.record_protection_violation(pos,
          sender:get_player_name())
        return
      end
      local lockstr = lock and "locked " or ""
      if fields and fields.text and fields.ok then
        local node = minetest.get_node(pos)
        local itemstack = sender:get_wielded_item()
        if writing.toolIsUsable(itemstack, node.name) then
          local meta = minetest.get_meta(pos)
          fields.text = writing.toolTextUpdate(itemstack, meta:get_string("text"), fields.text)
          minetest.log("action", ("%s wrote \"%s\" to "..lockstr.."sign at %s"):format(
            (sender:get_player_name() or ""),
            fields.text,
            minetest.pos_to_string(pos)
          ))
          if lock then
            signs_lib.update_sign(pos, fields, sender:get_player_name())
          else
            signs_lib.update_sign(pos, fields)
          end
          sender:set_wielded_item(itemstack)
        else
          minetest.chat_send_player(sender:get_player_name(), S("Ops. I need something to write!"))
        end
        
      end
    end
    
    local function update_sign(name, writable)
      local def = minetest.registered_nodes[name]
      if def then
        minetest.override_item(name, {
            _writable = writable,
          })
      end
    end
    local function update_signs(prefix, base, writable)
      local ubase = ""
      if base~="" then
        ubase = "_"..base
      end
      update_sign(prefix.."_wall"..ubase, writable)
      --update_sign(prefix..ubase.."_onpole", writable)
      --update_sign(prefix..ubase.."_onpole_horiz", writable)
      update_sign(prefix..ubase.."_hanging", writable)
      update_sign(prefix..ubase.."_yard", writable)
    end
    
    update_signs("signs_lib:sign", "", {materials={wood=1}})
    update_signs("signs_lib:sign", "locked", {materials={wood=1}})
    update_signs("signs_lib:sign", "steel_green", {materials={steel=1}})
    update_signs("signs_lib:sign", "steel_yellow", {materials={steel=1}})
    update_signs("signs_lib:sign", "steel_red", {materials={steel=1}})
    update_signs("signs_lib:sign", "steel_white_red", {materials={steel=1}})
    update_signs("signs_lib:sign", "steel_white_black", {materials={steel=1}})
  end
elseif minetest.get_modpath("default") then
  local function update_sign(name, writable)
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
            local meta = minetest.get_meta(pos)
            local old_text = meta:get_string("infotext")
            if text==old_text then
              return
            end
            local itemstack = sender:get_wielded_item()
            local def = itemstack:get_definition()
            if not def._writing_tool then
              minetest.chat_send_player(player_name, S("Ops. I need something to write!"))
              return
            end
            if string.len(text) > 512 then
              minetest.chat_send_player(player_name, S("Text too long"))
              return
            end
            local new_text = writing.toolTextUpdate(itemstack, old_text, text)
            meta:set_string("infotext", new_text)
            minetest.log("action", player_name .. " wrote \"" .. text ..
              "\" to the sign at " .. minetest.pos_to_string(pos))
            local meta = minetest.get_meta(pos)
            meta:set_string("text", text)
          end,
          _writable = writable,
        })
    end
  end
  
  update_sign("default:sign_wall_wood", {materials={wood=1}})
  update_sign("default:sign_wall_steel", {materials={steel=1}})
end

-- default book integration
if minetest.get_modpath("default") then
  local esc = minetest.formspec_escape
  local formspec_size = "size[8,8]"

  local function formspec_read(owner, title, string, text, page, page_max)
    return "label[0.5,0.5;" .. esc(S("by @1", owner)) .. "]" ..
      "tablecolumns[color;text]" ..
      "tableoptions[background=#00000000;highlight=#00000000;border=false]" ..
      "table[0.4,0;7,0.5;title;#FFFF00," .. esc(title) .. "]" ..
      "textarea[0.5,1.5;7.5,7;;" ..
        esc(string ~= "" and string or text) .. ";]" ..
      "button[2.4,7.6;0.8,0.8;book_prev;<]" ..
      "label[3.2,7.7;" .. esc(S("Page @1 of @2", page, page_max)) .. "]" ..
      "button[4.9,7.6;0.8,0.8;book_next;>]"
  end

  local function formspec_string(lpp, page, lines, string)
    for i = ((lpp * page) - lpp) + 1, lpp * page do
      if not lines[i] then break end
      string = string .. lines[i] .. "\n"
    end
    return string
  end

  local tab_number
  local lpp = 14 -- Lines per book's page
  local function book_on_use(itemstack, user)
    local player_name = user:get_player_name()
    local meta = itemstack:get_meta()
    local title, text, owner = "", "", player_name
    local page, page_max, lines, string = 1, 1, {}, ""

    -- Backwards compatibility
    local old_data = minetest.deserialize(itemstack:get_metadata())
    if old_data then
      meta:from_table({ fields = old_data })
    end

    local data = meta:to_table().fields

    if data.owner then
      title = data.title or ""
      text = data.text or ""
      owner = data.owner

      for str in (text .. "\n"):gmatch("([^\n]*)[\n]") do
        lines[#lines+1] = str
      end

      if data.page then
        page = data.page
        page_max = data.page_max
        string = formspec_string(lpp, page, lines, string)
      end
    end

    local formspec = formspec_read(owner, title, string, text, page, page_max)

    minetest.show_formspec(player_name, "writing:default_book", formspec_size .. formspec)
    return itemstack
  end
  
  minetest.register_on_player_receive_fields(function(player, formname, fields)
      if formname ~= "writing:default_book" then return end
      local player_name = player:get_player_name()
      local inv = player:get_inventory()
      local stack = player:get_wielded_item()
      local data = stack:get_meta():to_table().fields

      local title = data.title or ""
      local text = data.text or ""

      if fields.book_next or fields.book_prev then
        if not data.page then
          return
        end

        data.page = tonumber(data.page)
        data.page_max = tonumber(data.page_max)

        if fields.book_next then
          data.page = data.page + 1
          if data.page > data.page_max then
            data.page = 1
          end
        else
          data.page = data.page - 1
          if data.page == 0 then
            data.page = data.page_max
          end
        end

        stack:get_meta():from_table({fields = data})
        stack = book_on_use(stack, player)
      end
      
      -- Update stack
      player:set_wielded_item(stack)
    end)
  
  minetest.override_item("default:book", {
      on_use = nil,
    })
  
  minetest.override_item("default:book_written", {
      on_use = book_on_use,
    })
end

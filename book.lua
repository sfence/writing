
local S = writing.translator

-- make written book from written lists

-- make book writtable?

local book_on_use = function(itemstack, user, pointed_thing)
  local meta = itemstack:get_meta()
  local lpage_text = "page_"..meta:get_int("page")
  local rpage_text = "page_"..(meta:get_int("page")+1)
  local def = itemstack:get_definition()
  local written_paper = "formspec_version[3]" .. "size[16,12.5]"
    .. "background[-0.5,-0.5;17,13.5;"..(def._writable.background).."]"
    --.. "style["..paper_text..";font=mono;textcolor=#000000;border=false]"
    --.. "textarea[0.5,0.5;7,11;"..paper_text..";;"..minetest.formspec_escape(meta:get_string(paper_text)).."]"
    .. "style_type[textarea;font=mono;textcolor=#000000;border=false]"
    .. "textarea[0.5,0.5;7,10;;;"..minetest.formspec_escape(meta:get_string(lpage_text)).."]"
    .. "textarea[8.5,0.5;7,10;;;"..minetest.formspec_escape(meta:get_string(rpage_text)).."]"
    .. "button[3.5,11.75;1,0.8;prev;<<]"
    .. "button[11.5,11.75;1,0.8;next;>>]"
  minetest.show_formspec(user:get_player_name(), "writing:written_book", written_paper)
  itemstack:add_wear(def._writable.wear_per_read)
  return itemstack
end

minetest.register_on_player_receive_fields(function(player, formname, field)
  if formname ~= "writing:written_book" then return end
  if field.prev then
    local itemstack = player:get_wielded_item()
    local meta = itemstack:get_meta()
    local page = meta:get_int("page")
    if page>1 then
      meta:set_int("page", page-2)
    end
    book_on_use(itemstack, player, nil)
    player:set_wielded_item(itemstack)
    return
  end
  if field.next then
    local itemstack = player:get_wielded_item()
    local meta = itemstack:get_meta()
    local page = meta:get_int("page")
    local lists = meta:get_int("lists")
    if lists==0 then
      lists = 3
      meta:set_int("lists", 3)
    end
    if (page+2) < (2*lists) then
      meta:set_int("page", page+2)
    end
    book_on_use(itemstack, player, nil)
    player:set_wielded_item(itemstack)
    return
  end
end)

local book_get_writing_formspec = function(itemstack)
  local meta = itemstack:get_meta()
  local lpage_text = "page_"..meta:get_int("page")
  local rpage_text = "page_"..(meta:get_int("page")+1)
  local def = itemstack:get_definition()
  return "formspec_version[3]" .. "size[16,12.5]"
    .. "background[-0.5,-0.5;17,13.5;"..(def._writable.background).."]"
    .. "style_type[label;font=mono;textcolor=#000000;border=false]"
    .. "label[0.5,0.25;Max lines: "..def._writable.max_lines..", max line chars: "..def._writable.max_line_chars.."]"
    --.. "style["..paper_text..";font=mono;textcolor=#000000;border=false]"
    .. "style_type[textarea;font=mono;textcolor=#000000;border=false]"
    .. "textarea[0.5,0.5;7,11;"..lpage_text..";;"..minetest.formspec_escape(meta:get_string(lpage_text)).."]"
    .. "textarea[8.5,0.5;7,11;"..rpage_text..";;"..minetest.formspec_escape(meta:get_string(rpage_text)).."]"
    .. "button[3.5,11.75;1,0.8;prev;<<]"
    .. "button[11.5,11.75;1,0.8;next;>>]"
    .. "button[7.5,11.75;1,0.8;write;Write]"
end
local book_writing_receive_fields = function(itemstack, under, field)
  if field.prev then
    local meta = under:get_meta()
    local page = meta:get_int("page")
    if page>1 then
      meta:set_int("page", page-2)
    end
    return
  end
  if field.next then
    local meta = under:get_meta()
    local page = meta:get_int("page")
    local lists = meta:get_int("lists")
    if (page+2) < (2*lists) then
      meta:set_int("page", page+2)
    end
    return
  end
  if field.write and writing.toolIsUsable(itemstack, under) then
    local def = itemstack:get_definition()
    local under_def = under:get_definition()
    local meta = under:get_meta()
    local lpage_text = "page_"..meta:get_int("page")
    local rpage_text = "page_"..(meta:get_int("page")+1)
    
    -- left page
    local old_text = meta:get_string(lpage_text)
    field[lpage_text] = writing.trimText(field[lpage_text], under_def._writable.max_lines, under_def._writable.max_line_chars)
    local new_text = writing.toolTextUpdate(itemstack, old_text, field[lpage_text])
    --minetest.log("warning","Smart update: "..dump(new_text))
    meta:set_string(lpage_text, new_text)
    
    under:add_wear(under_def._writable.wear_per_write)
    
    -- right page
    if writing.toolIsUsable(itemstack, under) then
      local old_text = meta:get_string(rpage_text)
      field[rpage_text] = writing.trimText(field[rpage_text], under_def._writable.max_lines, under_def._writable.max_line_chars)
      local new_text = writing.toolTextUpdate(itemstack, old_text, field[rpage_text])
      --minetest.log("warning","Smart update: "..dump(new_text))
      meta:set_string(rpage_text, new_text)
      
      under:add_wear(under_def._writable.wear_per_write)
    end
  end
end

minetest.register_tool("writing:book_glued_written", {
    description = S("Book with Written Text (Glued Binding)"),
    inventory_image = "writing_book_written_desks.png",
    inventory_overlay = "writing_book_written_body.png",
    on_use = book_on_use,
    
    _writable = {
      materials = {paper=1}, 
      background = "writing_book_formspec.png",
      get_writing_formspec = book_get_writing_formspec,
      writing_receive_fields = book_writing_receive_fields,
      wear_per_read = 20,
      wear_per_write = 100,
      max_lines = writing.settings.paper_lines,
      max_line_chars = writing.settings.paper_line_chars,
    }
  })

minetest.register_tool("writing:book_sewn_written", {
    description = S("Book with Written Text (Sewn Binding)"),
    inventory_image = "writing_book_written_desks.png",
    inventory_overlay = "writing_book_written_body.png",
    on_use = book_on_use,
    
    _writable = {
      materials = {paper=1}, 
      background = "writing_book_formspec.png",
      get_writing_formspec = book_get_writing_formspec,
      writing_receive_fields = book_writing_receive_fields,
      wear_per_read = 2,
      wear_per_write = 50,
      max_lines = writing.settings.paper_lines,
      max_line_chars = writing.settings.paper_line_chars,
    }
  })


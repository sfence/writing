
local S = writing.translator

-- make written book from written lists

-- make book writtable?

local book_on_use = function(itemstack, user, pointed_thing)
  local meta = itemstack:get_meta()
  local lpage_text = "page_"..meta:get_int("page")
  local rpage_text = "page_"..(meta:get_int("page")+1)
  local written_paper = "formspec_version[3]" .. "size[16,12.75]"
    .. "background[-0.5,-0.5;17,13;writing_book_formspec.png]"
    --.. "style["..paper_text..";font=mono;textcolor=#000000;border=false]"
    --.. "textarea[0.5,0.5;7,11;"..paper_text..";;"..minetest.formspec_escape(meta:get_string(paper_text)).."]"
    .. "style_type[textarea;font=mono;textcolor=#000000;border=false]"
    .. "textarea[0.5,0.5;7,10;;;"..minetest.formspec_escape(meta:get_string(lpage_text)).."]"
    .. "textarea[8.5,0.5;7,10;;;"..minetest.formspec_escape(meta:get_string(rpage_text)).."]"
    .. "button[3.5,11.75;1,0.8;prev;<<]"
    .. "button[11.5,11.75;1,0.8;next;>>]"
  minetest.show_formspec(user:get_player_name(), "writing:written_book", written_paper)
  local def = itemstack:get_definition()
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
  return "formspec_version[3]" .. "size[16,12.5]"
    .. "background[-0.5,-0.5;17,13.5;writing_book_formspec.png]"
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
  if field.write then
    local def = itemstack:get_definition()
    local meta = under:get_meta()
    local lpage_text = "page_"..meta:get_int("page")
    local rpage_text = "page_"..(meta:get_int("page")+1)
    
    -- left page
    local old_text = meta:get_string(lpage_text)
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
    local new_text = writing.smartTextUpdate(old_text, field[lpage_text], doAdd, doRemove, doChange)
    --minetest.log("warning","Smart update: "..dump(new_text))
    meta:set_string(lpage_text, new_text.out_text)
    if new_text.added>0 then
      itemstack:add_wear(def._writing_tool.cost_per_add*new_text.added)
    end
    if new_text.removed>0 then
      itemstack:add_wear(def._writing_tool.cost_per_remove*new_text.removed)
    end
    
    local under_def = under:get_definition()
    under:add_wear(under_def._wear_per_write)
    
    -- right page
    if (under:get_count()>0) and (itemstack:get_count()>0) then
      local old_text = meta:get_string(rpage_text)
      local doAdd = false
      local doRemove = false
      if def._writing_tool.cost_per_add>0 then
        doAdd = true
      end
      if def._writing_tool.cost_per_remove>0 then
        doRemove = true
        --minetest.log("warning","Enable remove: "..dump(def._writing_tool))
      end
      local doChange = doAdd and doRemove
      local new_text = writing.smartTextUpdate(old_text, field[rpage_text], doAdd, doRemove, doChange)
      --minetest.log("warning","Smart update: "..dump(new_text))
      meta:set_string(rpage_text, new_text.out_text)
      if new_text.added>0 then
        itemstack:add_wear(def._writing_tool._cost_per_add*new_text.added)
      end
      if new_text.removed>0 then
        itemstack:add_wear(def._writing_tool._cost_per_remove*new_text.removed)
      end
      
      local under_def = under:get_definition()
      under:add_wear(under_def._writable.wear_per_write)
    end
    
    if (itemstack:get_count()==0) and def._writing_tool.break_stack then
      itemstack:replace(def._writing_tool.break_stack)
    end
  end
end

minetest.register_tool("writing:book_written", {
    description = S("Book with written text"),
    inventory_image = "writing_book_written.png",
    on_use = book_on_use,
    
    _writable = {
      materials = {paper=1}, 
      background = "writing_book_formspec.png",
      get_writing_formspec = book_get_writing_formspec,
      writing_receive_fields = book_writing_receive_fields,
      wear_per_read = 2,
      wear_per_write = 50,
    }
  })

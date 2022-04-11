
local S = writing.translator

-- make paper writable

writing.next_line_offset = 8
 
local paper_on_use = function(itemstack, user, pointed_thing)
  local meta = itemstack:get_meta()
  local def = itemstack.get_definition()
  local written_paper = "formspec_version[3]" .. "size[8,12]"
    .. "background[-0.5,-0.5;9,13;"..(def._writable.background).."]"
    --.. "style[paper_text;font=mono;textcolor=#000000;border=false]"
    --.. "textarea[0.5,0.5;7,11;paper_text;;"..minetest.formspec_escape(meta:get_string("paper_text")).."]"
    .. "style_type[textarea;font=mono;textcolor=#000000;border=false]"
    .. "textarea[0.5,0.5;7,11;;;"..minetest.formspec_escape(meta:get_string("paper_text")).."]"
  minetest.show_formspec(user:get_player_name(), "writing:written_paper", written_paper)
  itemstack:add_wear(def._writable.wear_per_read)
  return itemstack
end
local paper_get_writing_formspec = function(itemstack, user)
  local meta = itemstack:get_meta()
  local def = itemstack.get_definition()
  return "formspec_version[3]" .. "size[8,12.5]"
    .. "background[-0.5,-0.5;9,13.5;"..(def._writable.background).."]"
    .. "style[paper_text;font=mono;textcolor=#000000;border=false]"
    .. "textarea[0.5,0.5;7,11;paper_text;;"..minetest.formspec_escape(meta:get_string("paper_text")).."]"
    .. "button[3.5,11.75;1,0.8;write;Write]"
end
local paper_writing_receive_fields = function(itemstack, under, field)
  if field.write and writing.toolIsUsable(itemstack, under) then
    local def = itemstack:get_definition()
    local under_def = under:get_definition()
    local meta = under:get_meta()
    local old_text = meta:get_string("paper_text")
    
    --minetest.log("warning","pretrim: "..dump(field.paper_text))
    field.paper_text = writing.trimText(field.paper_text, under_def._writable.max_lines, under_def._writable.max_line_chars)
    --minetest.log("warning","preupdate: "..dump(field.paper_text))
    local new_text = writing.toolTextUpdate(itemstack, old_text, field.paper_text)
    --minetest.log("warning","tool update: "..dump(new_text))
    meta:set_string("paper_text", new_text)
    
    under:add_wear(under_def._writable.wear_per_write)
  end
end
minetest.register_tool("writing:paper_written", {
    description = S("Paper with written text"),
    inventory_image = "writing_paper_written.png",
    on_use = paper_on_use,
    
    _writable = {
      materials = {paper=1},
      background = "writing_paper_formspec.png",
      get_writing_formspec = paper_get_writing_formspec,
      writing_receive_fields = paper_writing_receive_fields,
      wear_per_read = 100,
      wear_per_write = 200,
      max_lines = writing.settings.paper_lines,
      max_line_chars = writing.settings.paper_line_chars,
    },
  })

minetest.register_tool("writing:papertag_written", {
    description = S("Paper tag with written text"),
    inventory_image = "writing_papertag_written.png",
    on_use = paper_on_use,
    
    _writable = {
      materials = {paper=1},
      background = "writing_paper_formspec.png",
      get_writing_formspec = paper_get_writing_formspec,
      writing_receive_fields = paper_writing_receive_fields,
      wear_per_read = 50,
      wear_per_write = 100,
      max_lines = math.max(1, math.floor(writing.settings.paper_lines/6)),
      max_line_chars = math.floor(writing.settings.paper_line_chars*0.67),
    },
  })

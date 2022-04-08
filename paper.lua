
local S = writing.translator

-- make paper writable

writing.next_line_offset = 8
 
local paper_on_use = function(itemstack, user, pointed_thing)
  local meta = itemstack:get_meta()
  local written_paper = "formspec_version[3]" .. "size[8,12]"
    .. "background[-0.5,-0.5;9,13;writing_paper_formspec.png]"
    --.. "style[paper_text;font=mono;textcolor=#000000;border=false]"
    --.. "textarea[0.5,0.5;7,11;paper_text;;"..minetest.formspec_escape(meta:get_string("paper_text")).."]"
    .. "style_type[textarea;font=mono;textcolor=#000000;border=false]"
    .. "textarea[0.5,0.5;7,11;;;"..minetest.formspec_escape(meta:get_string("paper_text")).."]"
  minetest.show_formspec(user:get_player_name(), "writing:written_paper", written_paper)
  local def = itemstack:get_definition()
  itemstack:add_wear(def._writable.wear_per_read)
  return itemstack
end
local paper_get_writing_formspec = function(itemstack, user)
  local meta = itemstack:get_meta()
  return "formspec_version[3]" .. "size[8,12.5]"
    .. "background[-0.5,-0.5;9,13.5;writing_paper_formspec.png]"
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
      max_lines = 36,
      max_line_chars = 39,
    },
  })


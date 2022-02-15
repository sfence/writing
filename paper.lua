
local S = writing.translator

-- make paper writable
 
local paper_on_use = function(itemstack, user, pointed_thing)
  local meta = itemstack:get_meta()
  local written_paper = "formspec_version[3]" .. "size[8,12]"
    .. "background[-0.5,-0.5;9,13;writing_paper_formspec.png]"
    .. "style[paper_text;font=mono;textcolor=#000000;border=false]"
    .. "textarea[0.5,0.5;7,11;paper_text;;"..minetest.formspec_escape(meta:get_string("paper_text")).."]"
  minetest.show_formspec(user:get_player_name(), "writing:written_paper", written_paper)
  local def = itemstack:get_definition()
  itemstack:add_wear(def._wear_per_read)
  return itemstack
end
local paper_get_writting_formspec = function(itemstack)
  local meta = itemstack:get_meta()
  return "formspec_version[3]" .. "size[8,12.5]"
    .. "background[-0.5,-0.5;9,13.5;writing_paper_formspec.png]"
    .. "style[paper_text;font=mono;textcolor=#000000;border=false]"
    .. "textarea[0.5,0.5;7,11;paper_text;;"..minetest.formspec_escape(meta:get_string("paper_text")).."]"
    .. "button[3.5,11.75;1,0.8;write;Write]"
end
local paper_writing_receive_fields = function(itemstack, under, field)
  if field.write then
    local meta = under:get_meta()
    meta:set_string("paper_text", field.paper_text)
    itemstack:add_wear(string.len(field.paper_text))
  end
end
minetest.register_tool("writing:paper_written", {
    description = S("Paper with written text"),
    inventory_image = "writing_paper_written.png",
    on_use = paper_on_use,
    _get_writing_formspec = paper_get_writting_formspec,
    _writing_receive_fields = paper_writing_receive_fields,
    _wear_per_read = 100,
  })


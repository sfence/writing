-----------------------
-- Bookbinding Table --
-----------------------
-------- Ver 1.0 ------
-----------------------
-- Initial Functions --
-----------------------
local S = writing.translator;

local items = writing.items

writing.bookbinding_table = appliances.appliance:new(
    {
      node_name_inactive = "writing:bookbinding_table",
      node_name_active = "writing:bookbinding_table_active",
      
      node_description = S("Bookbinding Table"),
    	node_help = S("Powered by punching."),
      
      input_stack = "input",
      input_stack_size = 6,
      input_stack_width = 3,
      use_stack = "usage",
      use_stack_size = 1,
    })

local bookbinding_table = writing.bookbinding_table;

bookbinding_table:power_data_register(
  {
    ["punch_power"] = {
        run_speed = 1,
      },
  })

--------------
-- Formspec --
--------------

-- formspec
local player_inv = "list[current_player;main;1.5,4;8,4;]";
if minetest.get_modpath("hades_core") then
  player_inv = "list[current_player;main;0.5,4;10,4;]";
end

function bookbinding_table:get_formspec(meta, production_percent, consumption_percent)
  local progress = "image[5.1,0.5;4,1.5;appliances_production_progress_bar.png^[transformR270]]";
  if production_percent then
    progress = "image[5.1,0.5;4,1.5;appliances_production_progress_bar.png^[lowpart:" ..
            (production_percent) ..
            ":appliances_production_progress_bar_full.png^[transformR270]]";
  end
  if consumption_percent then
    progress = progress.."image[5.1,1.5;4,1.5;appliances_production_progress_bar.png^[lowpart:" ..
            (consumption_percent) ..
            ":appliances_production_progress_bar_full.png^[transformR270]]";
  else
    progress = progress.."image[5.1,1.5;4,1.5;appliances_production_progress_bar.png^[transformR270]]";
  end
  
  local formspec =  "formspec_version[3]" .. "size[12.75,9.5]" ..
                    "background[-1.25,-1.25;15,11;appliances_appliance_formspec.png]" ..
                    progress..
                    player_inv..
                    "list[context;input;1,0;3,2;]" ..
                    "list[context;usage;1,2.5;3,1;]" ..
                    "list[context;output;9.75,0.75;2,2;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;input]" ..
                    "listring[current_player;main]" ..
                    "listring[context;output]" ..
                    "listring[current_player;main]";
  return formspec;
end

--------------------
-- Node callbacks --
--------------------

----------
-- Node --
----------
  
-- node box {x=0, y=0, z=0}
local node_box = {
    type = "fixed",
    fixed = {
      {-0.5,-0.5,-0.5,-0.375,0.1875,-0.375},
      {0.4375,-0.5,-0.5,0.5,0.1875,-0.375},
      {-0.375,0.125,-0.5,0.4375,0.1875,0.5},
      {-0.3125,0.1875,-0.4375,-0.25,0.25,-0.375},
      {-0.5,0.125,-0.375,-0.375,0.1875,0.5},
      {0.4375,0.125,-0.375,0.5,0.25,0.3125},
      {-0.375,0.1875,-0.375,-0.3125,0.25,-0.25},
      {-0.25,0.1875,-0.375,0.4375,0.25,-0.25},
      {-0.5,-0.5,-0.3125,-0.1875,0.0625,0.0625},
      {-0.125,0.25,-0.3125,0.125,0.3125,0.25},
      {0.1875,0.25,-0.3125,0.4375,0.3125,0.25},
      {-0.3125,0.1875,-0.25,-0.25,0.25,0.1875},
      {-0.1875,0.1875,-0.25,0.4375,0.25,0.3125},
      {-0.5,-0.25,0.0625,-0.1875,-0.125,0.1875},
      {-0.5,-0.3125,0.125,-0.1875,-0.25,0.3125},
      {-0.5,-0.375,0.1875,-0.1875,-0.3125,0.375},
      {-0.5,-0.25,0.1875,-0.1875,-0.1875,0.25},
      {-0.5,-0.4375,0.25,-0.1875,-0.375,0.4375},
      {-0.5,-0.5,0.3125,-0.1875,-0.4375,0.5},
      {0.4375,0.125,0.3125,0.5,0.1875,0.5},
      {-0.4375,0.1875,0.375,-0.3125,0.5,0.5},
      {0.4375,-0.5,0.4375,0.5,0.125,0.5},
      {-0.5,-0.4375,0.4375,-0.375,0.125,0.5},
    },
  }

local node_sounds
if minetest.get_modpath("default") then
  node_sounds = default.node_sound_wood_defaults()
elseif minetest.get_modpath("hades_sounds") then
  node_sounds = hades_sounds.node_sound_wood_defaults()
end

local node_def = {
    paramtype2 = "facedir",
    groups = {cracky = 2},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = node_sounds,
    drawtype = "mesh",
    mesh = "writing_bookbinding_table.obj",
    selection_box = node_box,
    collision_box = node_box,
    tiles = {
      "writing_bookbinding_table_wood.png",
      "writing_bookbinding_table_page.png",
      "writing_bookbinding_table_book_1.png",
      "writing_bookbinding_table_book_2.png",
      "writing_bookbinding_table_book_3.png",
      "writing_bookbinding_table_book_4.png"
    },
  }

bookbinding_table:register_nodes(node_def, nil, nil)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("writing_bookbinding_table", {
    description = S("Bookbinding"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("writing_bookbinding_table_use", {
    description = S("Use for Bookbinding"),
    width = 1,
    height = 1,
  })

local items = writing.items

bookbinding_table:recipe_register_input(
  "",
  {
    inputs = {items.paper, "", "",
              "", "", "",
             },
    outputs = {{"writing:papertag_written","writing:papertag_written","writing:papertag_written","writing:papertag_written",}},
    require_usage = {[""]=true},
    production_time = 20,
    consumption_step_size = 1,
  });

local function desktag_on_done(self, timer_step, outputs)
  local tag_stack = timer_step.inv:get_stack(self.input_stack, 1)
  local tag_meta = tag_stack:get_meta()
  local desk_stack = timer_step.inv:get_stack(self.input_stack, 4)
  local desk_meta = desk_stack:get_meta()
  
  outputs[1] = ItemStack(outputs[1])
  local out_meta = outputs[1]:get_meta()
  out_meta:set_string("description", S("Book desk with title @1", tag_meta:get_string("paper_text")))
  out_meta:set_string("text", tag_meta:get_string("paper_text"))
  out_meta:set_string("color", desk_meta:get_string("color"))
  
  return outputs
end

bookbinding_table:recipe_register_input(
  "",
  {
    inputs = {"writing:papertag_written", "", "",
              "writing:book_desk", "", "",
             },
    outputs = {"writing:book_desktag"},
    require_usage = {[items.glue]=true},
    production_time = 20,
    consumption_step_size = 5,
    on_done = desktag_on_done,
  });

local function book_on_done(self, timer_step, outputs)
  local tag_stack = timer_step.inv:get_stack(self.input_stack, 1)
  local paper_stack = timer_step.inv:get_stack(self.input_stack, 2)
  --local desk_stack = timer_step.inv:get_stack(self.input_stack, 3)
  
  local tag_meta = tag_stack:get_meta()
  --local desk_meta = desk_stack:get_meta()
  
  outputs[1] = ItemStack(outputs[1])
  local out_meta = outputs[1]:get_meta()
  out_meta:set_string("description", S("Book with title @1", tag_meta:get_string("text")))
  out_meta:set_string("title", tag_meta:get_string("text"))
  out_meta:set_int("lists", paper_stack:get_count())
  out_meta:set_string("color", tag_meta:get_string("color"))
  --out_meta:set_string("color", desk_meta:get_string("color"))
  paper_stack:set_count(1)
  timer_step.inv:set_stack(self.input_stack, 2, paper_stack)
  
  return outputs
end

bookbinding_table:recipe_register_input(
  "",
  {
    inputs = {"writing:book_desktag", items.paper, "writing:book_desk", 
              "", "", "",
             },
    outputs = {"writing:book_glued_written"},
    require_usage = {[items.glue]=true},
    production_time = 200,
    consumption_step_size = 1,
    on_done = book_on_done,
  });

local function booknametag_on_done(self, timer_step, outputs)
  local tag_stack = timer_step.inv:get_stack(self.input_stack, 1)
  local book_stack = timer_step.inv:get_stack(self.input_stack, 2)
  
  local tag_meta = tag_stack:get_meta()
  local book_meta = book_stack:get_meta()
  
  outputs[1] = ItemStack(outputs[1])
  local out_meta = outputs[1]:get_meta()
  out_meta:set_string("description", S("Book with title @1", tag_meta:get_string("text")))
  out_meta:set_string("title", tag_meta:get_string("text"))
  local lists = book_meta:get_int("lists")
  out_meta:set_int("lists", lists)
  out_meta:set_string("color", book_meta:get_string("color"))
  
  for page=0,(2*lists),1 do
    local meta_name = "page_"..page
    out_meta:set_string(meta_name, book_meta:get_string(meta_name))
  end
  
  return outputs
end

bookbinding_table:recipe_register_input(
  "",
  {
    inputs = {"writing:papertag_written", "", "",
              "writing:book_sewn_written", "", "",
             },
    outputs = {"writing:book_sewn_written"},
    require_usage = {[items.glue]=true},
    production_time = 25,
    consumption_step_size = 4,
    on_done = booknametag_on_done,
  });

if items.yarn then
  bookbinding_table:recipe_register_input(
    "",
    {
      inputs = {"writing:book_desktag", items.paper, "writing:book_desk",
                "", "", "",
               },
      outputs = {"writing:book_sewn_written"},
      require_usage = {[items.yarn]=true},
      production_time = 400,
      consumption_step_size = 1,
      on_done = book_on_done,
    });
end


if not writing.have_papermill then

  bookbinding_table:recipe_register_input(
    "",
    {
      inputs = {items.paper, items.paper, items.paper,
                items.paper, items.paper, items.paper,
               },
      outputs = {"writing:book_desk"},
      require_usage = {[items.glue]=true},
      production_time = 300,
      consumption_step_size = 2,
    });
end

bookbinding_table:recipe_register_usage(
  items.glue,
  {
    outputs = {""},
    consumption_time = 100,
    production_step_size = 1,
  });

if items.yarn then
  bookbinding_table:recipe_register_usage(
    items.yarn,
    {
      outputs = {items.yarn_spool_empty},
      consumption_time = 200,
      production_step_size = 1,
    });
end

bookbinding_table:recipe_register_usage(
  "",
  {
    outputs = {""},
    consumption_time = 20,
    production_step_size = 1,
  });

bookbinding_table:register_recipes("writing_bookbinding_table", "writing_bookbinding_table_use")


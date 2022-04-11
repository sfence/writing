-----------------------
-- Bookbinding Table --
-----------------------
-------- Ver 1.0 ------
-----------------------
-- Initial Functions --
-----------------------
local S = writing.translator;

writing.bookbinding_table = appliances.appliance:new(
    {
      node_name_inactive = "writing:bookbinding_table",
      node_name_active = "writing:bookbinding_table_active",
      
      node_description = S("Bookbinding Table"),
    	node_help = S("Powered by punching.")
      
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

function bookbinding_table:get_formspec(meta, production_percent, consumption_percent)
  local progress = "image[5.1,1;4,1.5;appliances_production_progress_bar.png^[transformR270]]";
  if production_percent then
    progress = "image[5.1,1;4,1.5;appliances_production_progress_bar.png^[lowpart:" ..
            (production_percent) ..
            ":appliances_production_progress_bar_full.png^[transformR270]]";
  end
  
  local formspec =  "formspec_version[3]" .. "size[12.75,9.5]" ..
                    "background[-1.25,-1.25;15,11;appliances_appliance_formspec.png]" ..
                    progress..
                    "list[current_player;main;1.5,4;8,4;]" ..
                    "list[context;input;1,0;3,2;]" ..
                    "list[context;usage;1,2;3,1;]" ..
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

local node_def = {
    paramtype2 = "facedir",
    groups = {cracky = 2},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "mesh",
    mesh = "writing_bookbinding_table.obj",
  }

local node_inactive = {
    tiles = {
      "writing_bookbinding_table_top.png",
      "writing_bookbinding_table_bottom.png",
      "writing_bookbinding_table_side.png",
      "writing_bookbinding_table_side.png",
      "writing_bookbinding_table_side.png",
      "writing_bookbinding_table_front.png"
    },
  }

local node_active = {
    tiles = {
      "writing_bookbinding_table_top.png",
      "writing_bookbinding_table_bottom.png",
      "writing_bookbinding_table_side.png",
      "writing_bookbinding_table_side.png",
      "writing_bookbinding_table_side.png",
      {
        image = "writing_bookbinding_table_front_active.png",
        backface_culling = true,
        animation = {
          type = "vertical_frames",
          aspect_w = 16,
          aspect_h = 16,
          length = 1.5
        }
      }
    },
  }

bookbinding_table:register_nodes(node_def, node_inactive, node_active)

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
    inputs = {"writing:papertag_written", "", "",
              "writing:book_desk", "", "",
             },
    outputs = {"writing:book_desktag"},
    production_time = 180,
    consumption_step_size = 1,
  });

bookbinding_table:recipe_register_input(
  "",
  {
    inputs = {"writing:book_desktag", items.glue, "",
              "writing:book_desk", "", "",
             },
    outputs = {"writing:book_written"},
    production_time = 180,
    consumption_step_size = 1,
  });

if items.yarn then
  bookbinding_table:recipe_register_input(
    "",
    {
      inputs = {"writing:book_desktag", items.yarn, "",
                "writing:book_desk", "", "",
               },
      outputs = {"writing:book_written"},
      production_time = 180,
      consumption_step_size = 1,
    });
end


if not writing.have_papermill then

  bookbinding_table:recipe_register_input(
    "",
    {
      inputs = {items.paper, items.paper, items.paper,
                items.paper, items.glue, items.paper,
               },
      outputs = {"writing:book_desk"},
      production_time = 180,
      consumption_step_size = 1,
    });
end

bookbinding_table:register_recipes("writing_bookbinding_table", "writing_bookbinding_table_use")


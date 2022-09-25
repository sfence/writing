-----------------------
-- Oak Gall Dust Tub --
-----------------------
------- Ver 1.0 -------
-----------------------
-- Initial Functions --
-----------------------
local S = writing.translator;

writing.oak_gall_dust_tub = appliances.appliance:new(
    {
      node_name_inactive = "writing:oak_gall_dust_tub",
      node_name_active = "writing:oak_gall_dust_tub_active",
      
      node_description = S("Oak Gall Dust Tub"),
    	node_help = S("Powered by time."),
      
      input_stack_size = 0,
      have_input = false,
      use_stack = "usage",
      use_stack_size = 1,
      output_stack = "usage",
      output_stack_size = 0,
    })

local oak_gall_dust_tub = writing.oak_gall_dust_tub;

oak_gall_dust_tub:power_data_register(
  {
    ["time_power"] = {
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

function oak_gall_dust_tub:get_formspec(meta, production_percent, consumption_percent)
  local progress = "image[3.1,2;6,1.5;appliances_production_progress_bar.png^[transformR270]]";
  if consumption_percent then
    progress = "image[3.1,2;6,1.5;appliances_production_progress_bar.png^[lowpart:" ..
            (consumption_percent) ..
            ":appliances_production_progress_bar_full.png^[transformR270]]";
  end
  
  local formspec =  "formspec_version[3]" .. "size[12.75,9.5]" ..
                    "background[-1.25,-1.25;15,11;appliances_appliance_formspec.png]" ..
                    progress..
                    player_inv..
                    "list[context;usage;5.4,0.8;3,2;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;usage]" ..
                    "listring[current_player;main]" ..
                    "listring[context;output]" ..
                    "listring[current_player;main]";
  return formspec;
end

--------------------
-- Node callbacks --
--------------------

function oak_gall_dust_tub:after_timer_step(timer_step)
  local use_input, use_usage = self:recipe_aviable_input(timer_step.inv)
  if use_usage then
    self:running(timer_step.pos, timer_step.meta);
    return true
  else
    self:deactivate(timer_step.pos, timer_step.meta);
    local node = minetest.get_node(timer_step.pos);
    local formspec =  "formspec_version[3]" .. "size[12.75,8.5]" ..
                       "background[-1.25,-1.25;15,10;appliances_appliance_formspec.png]" ..
                       player_inv ..
                       "list[context;"..self.output_stack..";6.0,0.8;1,1;]" ..
                       "listring[current_player;main]" ..
                       "listring[context;"..self.output_stack.."]";
    
    timer_step.meta:set_string("infotext", S("Wooden tub filled by oak gall ink"));
    timer_step.meta:set_string("formspec", formspec);
    node.name = "writing:wooden_tub_oak_gall_ink"
    minetest.swap_node(timer_step.pos, node);
    return false
  end
end

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

local node_def = clothing_machines.base_node_def_wooden_tub_fill()
node_def.tiles[2] = "writing_oak_gall_dust_tub_wood.png"

oak_gall_dust_tub:register_nodes(node_def, nil, nil)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("writing_oak_gall_dust_tub_use", {
    description = S("Use for oak ink"),
    width = 1,
    height = 1,
  })

oak_gall_dust_tub:recipe_register_usage(
  "basic_materials:steel_strip",
  {
    outputs = {"writing:etched_steel_strip"},
    consumption_time = 100,
    production_step_size = 1,
  });

local function etched_steel_strip_on_done(self, timer_step, outputs)
  local use_stack = timer_step.inv:get_stack(self.use_stack, 1)
  
  outputs[1] = ItemStack(outputs[1])
  
  outputs[1]:set_wear(use_stack:get_wear())
  outputs[1]:add_wear(64)
  
  return outputs
end

oak_gall_dust_tub:recipe_register_usage(
  "writing:etched_steel_strip",
  {
    outputs = {"writing:etched_steel_strip"},
    consumption_time = 100,
    production_step_size = 1,
    on_done = etched_steel_strip_on_done,
  });

oak_gall_dust_tub:register_recipes("", "writing_oak_gall_dust_tub_use")

-- create it from empty wooden tub

clothing_machines.tub_empty_punch_items["writing:bucket_water_with_oak_gall_dust"] = {
    new_node_name = "writing:oak_gall_dust_tub",
    replace_item = clothing_machines.adaptation.bucket_empty,
  }


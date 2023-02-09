
minetest.log("action", "[MOD] Writing loading...")

writing = {
  translator = minetest.get_translator("writting")
}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

writing.next_inv_row = 8
if minetest.get_modpath("hades_core") then
  writing.next_inv_row = 10
end

dofile(modpath.."/settings.lua")

dofile(modpath.."/functions.lua")
dofile(modpath.."/adaptation.lua")

if writing.adaptation.oak_leaves then
  dofile(modpath.."/oak_gall.lua")
  dofile(modpath.."/oak_ink_tub.lua")
end

dofile(modpath.."/ink.lua")
dofile(modpath.."/glue.lua")

dofile(modpath.."/pencil.lua")
dofile(modpath.."/pen.lua")

dofile(modpath.."/paper.lua")
dofile(modpath.."/book.lua")

dofile(modpath.."/bookbinding_table.lua")

dofile(modpath.."/integration.lua")

dofile(modpath.."/craftitems.lua")
dofile(modpath.."/crafting.lua")

minetest.log("action", "[MOD] Writing loaded.")


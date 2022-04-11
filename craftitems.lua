
local S = writing.translator


minetest.register_craftitem("writing:soot_glass", {
    description = S("Glass of Soot"),
    inventory_image = "writing_soot_glass.png",
  })

minetest.register_craftitem("writing:steel_strip_with_soot", {
    description = S("Ocouzeny Steel Strip"),
    inventory_image = "writing_steel_strip.png",
  })

minetest.register_craftitem("writing:book_desk", {
    description = S("Book Desk"),
    inventory_image = "writing_book_desk.png",
    -- can by colored
  })

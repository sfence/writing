
local S = writing.translator


minetest.register_craftitem("writing:soot_glass", {
    description = S("Glass of Soot"),
    inventory_image = "writing_soot_glass.png",
  })

minetest.register_craftitem("writing:scissors", {
    description = S("Scissors"),
    inventory_image = "writing_scissors.png",
  })

minetest.register_craftitem("writing:singed_steel_strip", {
    description = S("Singed Steel Strip"),
    inventory_image = "writing_singed_steel_strip.png",
  })

minetest.register_craftitem("writing:book_desk", {
    description = S("Book Desk"),
    inventory_image = "writing_book_desk.png",
    -- can by colored
  })

minetest.register_craftitem("writing:book_desktag", {
    description = S("Book Desk"),
    inventory_image = "writing_book_desk.png",
    inventory_overlay = "writing_book_desktag.png",
    -- can by colored
  })

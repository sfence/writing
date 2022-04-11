


writing.settings = {}


writing.settings.change_char = minetest.settings:get("writing_changed_char") or ""

writing.settings.paper_lines = tonumber(minetest.settings:get("writing_paper_lines") or "36")
writing.settings.paper_line_chars = tonumber(minetest.settings:get("writing_paper_line_chars") or "39")

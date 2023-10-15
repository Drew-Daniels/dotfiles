---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s("ex", fmt([[ <%= {} %> ]], { i(1) }, { desc = "eRuby expression" })),
	s("sc", fmt([[ <% {} %> ]], { i(1) }), { desc = "eRuby scriptlet" }),
	s("sce", { t("<% end %>") }),
}

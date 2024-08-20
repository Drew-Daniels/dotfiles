---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")

return {
  s("ex", fmt([[ <%= {} %> ]], { i(1) }, { desc = "eRuby expression" })),
  s("sc", fmt([[ <% {} %> ]], { i(1) }), { desc = "eRuby scriptlet" }),
  s("sce", { t("<% end %>") }),
}

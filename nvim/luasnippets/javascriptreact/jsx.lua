---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("rli", fmt([[ <li key={{{}}}>{{{}}}</li>]], { i(1), i(2) })),
  s(
    "gd",
    fmta([[ {<> && <>}]], { c(1, { sn(nil, { i(1) }), sn(nil, { t("!"), i(1) }) }), i(2) }),
    { desc = "Guard Clause" }
  ),
}

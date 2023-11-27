---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("tn", fmta([[ <> ? <> : <> ]], { i(1, "cond"), i(2, "then"), i(3, "else") })),
}

---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("od", fmta("const {<>} = <>", { i(2), i(1) }), { desc = "Object Destructure" }),
  s("ad", fmta("const [<>] = <>", { i(2), i(1) }), { desc = "Array Destructure" }),
}

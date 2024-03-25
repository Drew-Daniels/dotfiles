---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s("do", fmta("const {<>} = <>", { i(2), i(1) }), { desc = "Object Destructure" }),
	s("da", fmta("const [<>] = <>", { i(2), i(1) }), { desc = "Array Destructure" }),
}

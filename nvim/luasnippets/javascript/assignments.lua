---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s("do", fmta("const {<>} = <>", { i(2), i(1) }), { desc = "Destructure Object" }),
	s("da", fmta("const [<>] = <>", { i(2), i(1) }), { desc = "Destructure Array" }),
}

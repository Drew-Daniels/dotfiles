---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s("db", fmta("debugger;", {}), { desc = "debugger statement" }),
}

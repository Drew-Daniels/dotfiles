---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"kv",
		fmta([[{ <> }]], {
      i(1),
		}, { desc = "Key Value" })
	),
	s(
		"ls",
		fmta("[ <> ]", {
      i(1),
		}, { desc = "List" })
	),
}

---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"q",
		fmta([["<>"]], {
			d(1, get_visual),
		})
	),
	s(
		"b",
		fmta([[{ <> }]], {
			d(1, get_visual),
		})
	),
	s(
		"p",
		fmta([[(<>)]], {
			d(1, get_visual),
		})
	),
}

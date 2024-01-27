---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"cl",
		fmta(
			[[ 
        class <>{<>}
      ]],
			{ i(1), i(2) },
			{ desc = "Class" }
		)
	),
}

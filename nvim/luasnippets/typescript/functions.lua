---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"nf",
		fmta(
			[[ 
        <>function <>() {
          <>     
        }
      ]],
			{ c(1, { t(""), t("async ") }), i(2), i(3) },
			{ desc = "Named Fn" }
		)
	),
	s(
		">>",
		fmta(
			[[
        (<>) =>> {<>}
      ]],
			{ i(1), i(2) },
			{ desc = "Anonymous Arrow Fn" }
		)
	),
}

---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"in",
		fmta(
			[[
        interface <> {
          <>: <>
        }
      ]],
			{
        i(1), i(2), i(3)
			}
		)
	),
	s(
		"ty",
		fmta(
			[[
        type <> = {
          <>: <>
        }
      ]],
			{
        i(1), i(2), i(3)
			}
		)
	),
}

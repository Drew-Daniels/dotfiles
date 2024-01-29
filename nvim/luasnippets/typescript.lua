---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s(
		"in",
		fmta(
			[[
        <>interface <> {
          <>: <>
        }
      ]],
			{
				c(1, { t(""), t("export ") }),
				i(2),
				i(3),
				i(4),
			}
		)
	),
	s(
		"ty",
		fmta(
			[[
        <>type <> = {
          <>: <>
        }
      ]],
			{
				c(1, { t(""), t("export ") }),
				i(2),
				i(3),
				i(4),
			}
		)
	),
}

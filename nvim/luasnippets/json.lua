---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")

return {
	s("jp", fmta([[ "<>": <> ]], { i(1), c(2, { sn(nil, { t'"', i(1), t'"' }), t"" } ) }), { desc = "JSON Property" } ),
}

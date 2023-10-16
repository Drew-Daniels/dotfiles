---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")

return {
	s("kv", fmta([[ "<>": <> ]], { i(1), c(2, { sn(nil, { t'"', i(1), t'"' }), t"" } ) }), { desc = "key, value JSON pair" } ),
}

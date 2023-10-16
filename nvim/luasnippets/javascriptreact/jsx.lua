---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
	s("rli", fmt([[ <li key={{{}}}>{{{}}}</li> ]], { i(1), i(2) })),
  --TODO: Create a snippet for mapping over an array of things, creating an <li> for each thing
}

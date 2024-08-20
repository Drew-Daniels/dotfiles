---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("td", fmta("# TODO: <>", { i(1) }), { desc = "TODO" }),
  s("sh", fmta("#!/usr/bin/env <>", { i(1, "bash") }), { desc = "Shebang" }),
}

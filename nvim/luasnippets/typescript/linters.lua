---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "ee",
    fmta([[// @ts-expect-error <>]], {
      i(1),
    }, { desc = "TypeScript Expect Error" })
  ),
}

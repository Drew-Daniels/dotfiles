---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("ese", fmta([[ export <><> ]], { c(1, { t(""), t("default ") }), i(2) }), { desc = "ES Module export" }),
  s(
    "cje",
    fmta(
      [[
        module.exports = {
          <>,
        }
      ]],
      { i(1) },
      { desc = "CommonJS Export" }
    )
  ),
}

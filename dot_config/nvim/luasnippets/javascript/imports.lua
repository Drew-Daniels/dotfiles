---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "esi",
    fmta(
      [[
        import <> from "<>";
      ]],
      { c(2, { sn(nil, { t("{ "), i(1), t(" }") }), t("") }), i(1) },
      { desc = "ES Module Import" }
    )
  ),
  s(
    "cji",
    fmta(
      [[
        const <> = require("<>");
      ]],
      { c(2, { sn(nil, { t("{ "), i(1), t(" }") }), t("") }), i(1) },
      { desc = "CommonJS Module Import" }
    )
  ),
}

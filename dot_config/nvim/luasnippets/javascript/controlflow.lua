---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("if", fmta([[ if (<>) {<>}]], { i(1, "cond"), i(2, "then") }, { desc = "If" })),
  s("tn", fmta([[ <> ? <> : <> ]], { i(1, "cond"), i(2, "then"), i(3, "else") }, { desc = "Ternary" })),
  s(
    "tc",
    fmta(
      [[
        try {
          <>
        } catch (<>) {
          <>
        }<>
      ]],
      { i(1), i(2, "e"), i(3), c(4, { t(""), { t([[ finally {]]), i(1), t("}") } }) },
      { desc = "Try Catch" }
    )
  ),
}

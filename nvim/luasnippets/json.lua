---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")

return {
  s(
    "pr",
    fmta([[ "<>": <>]], { i(1), c(2, { sn(nil, { t('"'), i(1), t('"') }), t("") }) }),
    { desc = "JSON Property" }
  ),
}

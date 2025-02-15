---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "ru",
    fmta(
      [[
        <> {
          <>: <><>;
        }
      ]],
      --TODO: Update last node to be choice node that can enable '!important' rule if required
      {
        c(1, { sn(nil, { t("."), i(1, "class-name") }), sn(nil, { t("#"), i(1, "id") }), i(2, "element") }),
        i(2, "attr"),
        i(3, "value"),
        c(4, { t(""), t(" !important") }),
      }
    )
  ),
  s("td", fmta("// TODO: <>", { i(1) }), { desc = "TODO" }),
}

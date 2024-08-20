---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("rc", fmta([[{/* <> */}]], { i(1) }), { desc = "React Comment" }),
  s("rcs", t("{/*"), { desc = "React Comment START" }),
  s("rce", t("*/}"), { desc = "React Comment END" }),
}

---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("ft", fmta("Feature: <>", { i(1) }, { desc = "Cucumber Feature" })),
  s("ex", fmta("<>: <>", { c(1, { t("Example"), t("Scenario") }), i(1) }), { desc = "Cucumber Example/Scenario" }),
  s(
    "ex",
    fmta("<>: <>", { c(1, { t("Scenario Outline"), t("Scenario Template") }), i(1) }),
    { desc = "Cucumber Scenario Outline/Template" }
  ),
  s("ex", fmta("<>: <>", { c(1, { t("Examples"), t("Scenarios") }), i(1) }), { desc = "Cucumber Examples/Scenarios" }),
  s("ru", fmta("Rule: <>", { i(1) }), { desc = "Cucumber Rule" }),
  s("bg", fmta("Background: <>", { i(1) }), { desc = "Cucumber Background" }),
  s("gi", fmta("Given <>", { i(1) }), { desc = "Cucumber Given" }),
  s("wh", fmta("When <>", { i(1) }), { desc = "Cucumber When" }),
  s("&", fmta("And <>", { i(1) }), { desc = "Cucumber And" }),
  s("bu", fmta("But <>", { i(1) }), { desc = "Cucumber But" }),
  s("th", fmta("Then <>", { i(1) }), { desc = "Cucumber Then" }),
}

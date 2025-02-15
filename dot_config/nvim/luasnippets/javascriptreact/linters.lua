---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s("red", t("{{/* eslint-disable */}}"), { desc = "React ESLint Disable" }),
  s("rei", fmt("{{/* eslint-ignore {} */}}", { i(1) }), { desc = "React ESLint Ignore" }),
}

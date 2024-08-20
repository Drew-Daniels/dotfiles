---@diagnostic disable: undefined-global

local helpers = require("luasnip-helpers")
local get_visual = helpers.get_visual

return {
  s(
    "pt",
    fmta(
      [[ 
        <>.propTypes = {
          <>: PropTypes.<>,
        }
      ]],
      { i(1), i(2), i(3) }
    )
  ),
  s(
    "dpt",
    fmta(
      [[ 
        <>.defaultProps = {
          <>: <>,
        }
      ]],
      { i(1), i(2), i(3) }
    )
  ),
}

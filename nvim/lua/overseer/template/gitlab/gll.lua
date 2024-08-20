-- local parser = require("overseer.parser")
--
-- local defn = {
-- 	errors = {
-- 		{ "skip_until", { regex = true }, "[" },
-- 		{ "loop", { "sequence", { "extract", "([a-zA-Z0-9]+)", "error" } } },
-- 	},
-- }
--
-- local output_parser = parser.new(defn)

return {
  name = "gll",
  builder = function()
    return {
      cmd = { "gll.sh" },
      name = "GitLab CI Config Lint",
      -- components = { "on_output_parse", parser = output_parser },
    }
  end,
  desc = "Lints GitLab CI Configuration file in PWD",
}

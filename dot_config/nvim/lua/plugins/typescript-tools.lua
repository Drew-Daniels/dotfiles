-- https://www.npbee.me/posts/deno-and-typescript-in-a-monorepo-neovim-lsp
---Specialized root pattern that allows for an exclusion
---@param opt { root: string[], exclude: string[] }
---@return fun(file_name: string): string | nil
local function root_pattern_exclude(opt)
	local lsputil = require("lspconfig.util")

	return function(fname)
		local excluded_root = lsputil.root_pattern(opt.exclude)(fname)
		local included_root = lsputil.root_pattern(opt.root)(fname)

		if excluded_root then
			return nil
		else
			return included_root
		end
	end
end

return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
    settings = {
      root_dir = root_pattern_exclude({
        root = { "package.json" },
        exclude = { "deno.json", "deno.jsonc" },
      }),
      single_file_support = false,
      tsserver_plugins = {
        "@vue/typescript-plugin",
      },
      completions = {
        completeFunctionCalls = false,
      },
    },
  },
}

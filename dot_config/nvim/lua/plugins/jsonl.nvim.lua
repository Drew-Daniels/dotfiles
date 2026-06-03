local parser_dir = vim.fn.stdpath("data") .. "/tree-sitter-jsonl"

local function ensure_parser_repo()
	if vim.fn.isdirectory(parser_dir) == 0 then
		vim.fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://codeberg.org/kristoferssolo/tree-sitter-jsonl",
			parser_dir,
		})
	end
end

return {
	"https://codeberg.org/kristoferssolo/jsonl.nvim",
	dependencies = { "Drew-Daniels/nvim-treesitter" },
	ft = { "jsonl" },
	init = function()
		-- jsonl.nvim only supports the old nvim-treesitter API
		-- (parsers.get_parser_configs). Stub it before plugin/jsonl.lua runs.
		package.preload["jsonl.treesitter"] = function()
			return { setup = function() end }
		end

		ensure_parser_repo()

		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
				require("nvim-treesitter.parsers").jsonl = {
					install_info = { path = parser_dir },
				}
			end,
		})

		vim.treesitter.language.register("jsonl", "jsonl")
	end,
	config = function()
		ensure_parser_repo()
		require("nvim-treesitter").install({ "jsonl" })
	end,
}

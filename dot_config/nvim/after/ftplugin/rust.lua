local bufnr = vim.api.nvim_get_current_buf()
-- TODO: create other keybindings for other rustaceanvim features:
-- https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#books-usage--features
vim.keymap.set("n", "<leader>lc", function()
	vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
	-- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr, desc = "Code Action" })
vim.keymap.set(
	"n",
	"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
	function()
		vim.cmd.RustLsp({ "hover", "actions" })
	end,
	{ silent = true, buffer = bufnr, desc = "Hover Actions" }
)

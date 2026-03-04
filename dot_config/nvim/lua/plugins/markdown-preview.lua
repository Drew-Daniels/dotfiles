return {
	-- "iamcco/markdown-preview.nvim",
	"Drew-Daniels/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	cond = function()
		-- Only run on macos
		return vim.fn.has("macunix") == 1
	end,
	build = "cd app && yarn install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
}

return {
	"iamcco/markdown-preview.nvim",
	-- forked because of recurring build issues when running ':Lazy sync'
	-- "Drew-Daniels/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
}

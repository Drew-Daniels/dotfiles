return {
	"shumphrey/fugitive-gitlab.vim",
	dependencies = "tpope/vim-fugitive",
	init = function()
		-- NOTE: Should be able to use ssh format, but this does not work for some reason
		-- vim.g.fugitive_gitlab_domains = { ["git@gitlab.webpt.com"] = "https://gitlab.webpt.com" }
		vim.g.fugitive_gitlab_domains = { "https://gitlab.webpt.com" }
	end,
}

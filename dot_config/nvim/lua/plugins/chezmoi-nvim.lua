return {
	"xvzc/chezmoi.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		fzf_chezmoi = function()
			require("fzf-lua").fzf_exec(require("chezmoi.commands").list(), {
				actions = {
					["default"] = function(selected, opts)
						require("chezmoi.commands").edit({
							targets = { "~/" .. selected[1] },
							args = { "--watch" },
						})
					end,
				},
			})
		end

		vim.api.nvim_command("command! ChezmoiFzf lua fzf_chezmoi()")
	end,
}

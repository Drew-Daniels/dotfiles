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
	-- Commenting out bc this function makes it difficult to make partial/incomplete changes to source files
	-- init = function()
	-- 	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	-- 		pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
	-- 		callback = function(ev)
	-- 			local bufnr = ev.buf
	-- 			local edit_watch = function()
	-- 				require("chezmoi.commands.__edit").watch(bufnr)
	-- 			end
	-- 			vim.schedule(edit_watch)
	-- 		end,
	-- 	})
	-- end,
}

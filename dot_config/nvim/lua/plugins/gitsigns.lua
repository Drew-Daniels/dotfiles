return {
	"lewis6991/gitsigns.nvim",
	opts = {
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]h", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Next Hunk" })

			map("n", "[h", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Prev Hunk" })

			map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
			map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
			map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Stage Hunk" })
			map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Reset Hunk" })
			--TODO: Determine better buffer-wide actions
			map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
			map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
			map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
			map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
			--TODO: Deteremine better keymap for this
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, { desc = "Blame Line" })

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
		end,
	},
	config = function(_, opts)
		require("gitsigns").setup(opts)
	end,
}

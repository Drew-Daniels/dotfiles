return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = { "Drew-Daniels/nvim-treesitter" },
	config = function()
		local ts_textobjects = require("nvim-treesitter-textobjects")
		local select = require("nvim-treesitter-textobjects.select")
		local move = require("nvim-treesitter-textobjects.move")
		local swap = require("nvim-treesitter-textobjects.swap")
		local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

		ts_textobjects.setup({
			select = {
				lookahead = true,
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "V", -- blockwise
				},
			},
			move = {
				set_jumps = true,
			},
		})

		-- Select keymaps
		local select_maps = {
			["of"] = { "@function.outer", "textobjects", "Select outer function" },
			["if"] = { "@function.inner", "textobjects", "Select inner function" },
			["oc"] = { "@class.outer", "textobjects", "Select outer class" },
			["ic"] = { "@class.inner", "textobjects", "Select inner class" },
			["os"] = { "@scope", "locals", "Select language scope" },
			["is"] = { "@scope.inner", "locals", "Select inner language scope" },
			["ol"] = { "@loop.outer", "textobjects", "Select outer loop" },
			["il"] = { "@loop.inner", "textobjects", "Select inner loop" },
			["ob"] = { "@block.outer", "textobjects", "Select outer block" },
			["ib"] = { "@block.inner", "textobjects", "Select inner block" },
			["od"] = { "@conditional.outer", "textobjects", "Select outer conditional" },
			["id"] = { "@conditional.inner", "textobjects", "Select inner conditional" },
			["op"] = { "@parameter.outer", "textobjects", "Select outer parameter" },
			["ip"] = { "@parameter.inner", "textobjects", "Select inner parameter" },
			["o/"] = { "@comment.outer", "textobjects", "Select outer comment" },
			["i/"] = { "@comment.inner", "textobjects", "Select inner comment" },
		}
		for key, mapping in pairs(select_maps) do
			vim.keymap.set({ "x", "o" }, key, function()
				select.select_textobject(mapping[1], mapping[2])
			end, { desc = mapping[3] })
		end

		-- Move keymaps
		--TODO: Figure out why go-tos for conditionals don't work in .rb files?
		local move_maps = {
			-- goto_next_start
			{ "]f", "goto_next_start", "@function.outer", "textobjects", "Next function (start)" },
			{ "]c", "goto_next_start", "@class.outer", "textobjects", "Next class (start)" },
			{ "]s", "goto_next_start", "@scope", "locals", "Next scope (start)" },
			{ "]z", "goto_next_start", "@fold", "folds", "Next fold (start)" },
			{ "]d", "goto_next_start", "@conditional.outer", "textobjects", "Next Conditional (start)" },
			-- goto_next_end
			{ "]F", "goto_next_end", "@function.outer", "textobjects", "Next function (end)" },
			{ "]C", "goto_next_end", "@class.outer", "textobjects", "Next class (end)" },
			{ "]S", "goto_next_end", "@scope", "locals", "Next scope (end)" },
			{ "]Z", "goto_next_end", "@fold", "folds", "Next fold (end)" },
			{ "]D", "goto_next_end", "@conditional.outer", "textobjects", "Next Conditional (end)" },
			-- goto_previous_start
			{ "[f", "goto_previous_start", "@function.outer", "textobjects", "Previous function (start)" },
			{ "[c", "goto_previous_start", "@class.outer", "textobjects", "Previous class (start)" },
			{ "[s", "goto_previous_start", "@scope", "locals", "Previous scope (start)" },
			{ "[z", "goto_previous_start", "@fold", "folds", "Previous fold (start)" },
			{ "[d", "goto_previous_start", "@conditional.outer", "textobjects", "Previous Conditional (start)" },
			-- goto_previous_end
			{ "[F", "goto_previous_end", "@function.outer", "textobjects", "Previous function (end)" },
			{ "[C", "goto_previous_end", "@class.outer", "textobjects", "Previous class (end)" },
			{ "[S", "goto_previous_end", "@scope", "locals", "Previous scope (end)" },
			{ "[Z", "goto_previous_end", "@fold", "folds", "Previous fold (end)" },
			{ "[D", "goto_previous_end", "@conditional.outer", "textobjects", "Previous Conditional (end)" },
		}
		for _, m in ipairs(move_maps) do
			vim.keymap.set({ "n", "x", "o" }, m[1], function()
				move[m[2]](m[3], m[4])
			end, { desc = m[5] })
		end

		-- Swap keymaps
		vim.keymap.set("n", "<leader>a", function()
			swap.swap_next("@parameter.inner")
		end, { desc = "Swap next parameter" })
		vim.keymap.set("n", "<leader>A", function()
			swap.swap_previous("@parameter.inner")
		end, { desc = "Swap previous parameter" })

		-- Repeatable move keymaps
		-- TODO: Need to find a better key for repeat_last_move_previous than , since , is my localleader
		-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
		-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat last move previous" })

		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

		-- This repeats the last query with always previous direction and to the start of the range.
		vim.keymap.set({ "n", "x", "o" }, "<home>", function()
			ts_repeat_move.repeat_last_move({ forward = false, start = true })
		end, { desc = "Repeat last move (backward, start)" })

		-- This repeats the last query with always next direction and to the end of the range.
		vim.keymap.set({ "n", "x", "o" }, "<end>", function()
			ts_repeat_move.repeat_last_move({ forward = true, start = false })
		end, { desc = "Repeat last move (forward, end)" })
	end,
}

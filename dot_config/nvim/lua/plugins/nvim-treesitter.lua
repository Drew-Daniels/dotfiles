return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	opts = {
		ensure_installed = {
			"c",
			"lua",
			"luadoc",
			"vim",
			"vimdoc",
			"query",
			"bash",
			"css",
			"clojure",
			"dockerfile",
			"embedded_template",
			"fish",
			"html",
			"http",
			"javascript",
			"jq",
			"json",
			"jsonc",
			"markdown",
			"markdown_inline",
			"ruby",
			"scheme",
			"scss",
			"sql",
			"terraform",
			"toml",
			"tsx",
			"typescript",
			"yaml",
			"prisma",
			"vue",
			"nix",
			"ssh_config",
			"editorconfig",
			"git_config",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"graphql",
			"hurl",
			"nginx",
			"passwd",
			"smithy",
			"svelte",
			"swift",
			"tmux",
		},
		-- required by 'nvim-ts-autotag'
		autotag = {
			enable = true,
		},
		-- required by 'nvim-treesitter-endwise'
		endwise = {
			enable = true,
		},
		--       ╭───────────────────────────────────────────────────────────────╮
		--       │                  NVIM-TREESITTER-TEXTOBJECTS                  │
		--       │https://github.com/nvim-treesitter/nvim-treesitter-textobjects │
		--       ╰───────────────────────────────────────────────────────────────╯
		textobjects = {
			lsp_interop = {
				enable = true,
				border = "none",
				floating_preview_opts = {},
				peek_definition_code = {
					["<leader>vf"] = "@function.outer",
					["<leader>vc"] = "@class.outer",
				},
			},
			move = {
				--TODO: Figure out why go-tos for conditionals don't work in .rb files?
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]f"] = { query = "@function.outer", desc = "Next function (start)" },
					["]c"] = { query = "@class.outer", desc = "Next class (start)" },
					["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope (start)" },
					["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold (start)" },
					["]d"] = { query = "@conditional.outer", desc = "Next Conditional (start)" },
				},
				goto_next_end = {
					["]F"] = { query = "@function.outer", desc = "Next function (end)" },
					["]C"] = { query = "@class.outer", desc = "Next class (end)" },
					["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope (end)" },
					["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold (end)" },
					["]D"] = { query = "@conditional.outer", desc = "Next Conditional (end)" },
				},
				goto_previous_start = {
					["[f"] = { query = "@function.outer", desc = "Previous function (start)" },
					["[c"] = { query = "@class.outer", desc = "Previous class (start)" },
					["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope (start)" },
					["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold (start)" },
					["[d"] = { query = "@conditional.outer", desc = "Previous Conditional (start)" },
				},
				goto_previous_end = {
					["[F"] = { query = "@function.outer", desc = "Previous function (end)" },
					["[C"] = { query = "@class.outer", desc = "Previous class (end)" },
					["[S"] = { query = "@scope", query_group = "locals", desc = "Previous scope (end)" },
					["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold (end)" },
					["[D"] = { query = "@conditional.outer", desc = "Previous Conditional (end)" },
				},
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["of"] = { query = "@function.outer", desc = "Select outer function" },
					["if"] = { query = "@function.inner", desc = "Select inner function" },
					["oc"] = { query = "@class.outer", desc = "Select outer class" },
					["ic"] = { query = "@class.inner", desc = "Select inner class" },
					["os"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					["is"] = {
						query = "@scope.inner",
						query_group = "locals",
						desc = "Select inner language scope",
					},
					["ol"] = { query = "@loop.outer", desc = "Select outer loop" },
					["il"] = { query = "@loop.inner", desc = "Select inner loop" },
					["ob"] = { query = "@block.outer", desc = "Select outer block" },
					--TODO: Figure out how to select blocks without the curly braces
					["ib"] = { query = "@block.inner", desc = "Select inner block", kind = "exclusive" },
					["od"] = { query = "@conditional.outer", desc = "Select outer conditional" },
					["id"] = { query = "@conditional.inner", desc = "Select inner conditional" },
					["op"] = { query = "@parameter.outer", desc = "Select outer parameter" },
					["ip"] = { query = "@parameter.inner", desc = "Select inner parameter" },
					["oP"] = { query = "@parameter.outer", mode = "a", desc = "Select outer parameter (inclusive)" },
					["iP"] = { query = "@parameter.inner", mode = "a", desc = "Select inner parameter (inclusive)" },
					["o,"] = { query = "@parameter.outer", mode = "i", desc = "Select outer parameter (exclusive)" },
					["i,"] = { query = "@parameter.inner", mode = "i", desc = "Select inner parameter (exclusive)" },
					["o;"] = {
						query = "@parameter.outer",
						mode = "a",
						kind = "inclusive",
						desc = "Select outer parameter (inclusive)",
					},
					["i;"] = {
						query = "@parameter.inner",
						mode = "a",
						kind = "inclusive",
						desc = "Select inner parameter (inclusive)",
					},
					["o:"] = {
						query = "@parameter.outer",
						mode = "i",
						kind = "exclusive",
						desc = "Select outer parameter (exclusive)",
					},
					["i:"] = {
						query = "@parameter.inner",
						mode = "i",
						kind = "exclusive",
						desc = "Select inner parameter (exclusive)",
					},
					["o/"] = { query = "@comment.outer", desc = "Select outer comment" },
					["i/"] = { query = "@comment.inner", desc = "Select inner comment" },
					["o#"] = {
						query = "@comment.outer",
						mode = "i",
						kind = "inclusive",
						desc = "Select outer comment (inclusive)",
					},
					["i#"] = {
						query = "@comment.inner",
						mode = "i",
						kind = "inclusive",
						desc = "Select inner comment (inclusive)",
					},
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "V", -- blockwise
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
		highlight = {
			enable = true,
			-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1352#issuecomment-1449638327
			disable = function()
				if string.find(vim.bo.filetype, "chezmoitmpl") or vim.bo.filetype == "embedded_template" then
					return true
				end
			end,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				--TODO: how to inform whichkey that <leader>s should be used for this?
				init_selection = "<leader>si", -- select start
				node_incremental = "<leader>sn", -- select node (incremental)
				scope_incremental = "<leader>ss", -- select scope
				node_decremental = "<leader>sd", -- select node (decremental)
			},
		},
		indent = {
			enable = true,
		},
	},
	config = function(_, options)
		require("nvim-treesitter.configs").setup(options)

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { unpack(opts), desc = "declaration" })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { unpack(opts), desc = "definition" })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = "hover" })
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { unpack(opts), desc = "implementation" })
				vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { unpack(opts), desc = "signature help" })
				vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { unpack(opts), desc = "type definition" })
				-- vim.keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, { unpack(opts), desc = "Code Actions" })
				vim.keymap.set("n", "gr", vim.lsp.buf.references, { unpack(opts), desc = "references" })
				vim.keymap.set("n", "gR", vim.lsp.buf.rename, { unpack(opts), desc = "rename" })
				-- conform.nvim should handle formatting
				-- vim.keymap.set("n", "<space>f", function()
				-- 	vim.lsp.buf.format({ async = true })
				-- end, { unpack(opts), desc = "format" })
			end,
			desc = "Initialize LSP on LspAttach event",
		})

		require("ts_context_commentstring").setup()

		-- custom file associations
		require("vim.treesitter.language").register("http", "hurl")

		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		-- Repeat movement with ; and ,
		-- ensure ; goes forward and , goes backward regardless of the last direction
		-- TODO: Need to find a better key for repeat_last_move_previous than , since , is my localleader
		-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
		-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat last move previous" })

		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

		-- This repeats the last query with always previous direction and to the start of the range.
		vim.keymap.set({ "n", "x", "o" }, "<home>", function()
			ts_repeat_move.repeat_last_move({ forward = false, start = true, desc = "Repeat last move" })
		end)

		-- This repeats the last query with always next direction and to the end of the range.
		vim.keymap.set({ "n", "x", "o" }, "<end>", function()
			ts_repeat_move.repeat_last_move({ forward = true, start = false, desc = "Repeat last move" })
		end)
	end,
}

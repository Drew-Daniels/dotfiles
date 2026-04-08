local parsers = {
	"angular",
	"bp",
	"c",
	-- NOTE: Seems like this is broken
	-- "make",
	"comment",
	-- TODO: Figure out how to get rainbow parens for lisp files for better readability
	-- TODO: Figure out how to automatically use this parser for .lisp files in ~/.config/nyxt
	"commonlisp",
	"cmake",
	"cpp",
	"css",
	"csv",
	"tsv",
	"typst",
	"dart",
	"desktop",
	"diff",
	-- TODO: Create an issue for this. Would be nice if this parser could be installed just by using nvim-treesitter, rather than having to install a separate plugin:
	-- https://github.com/nvim-treesitter/nvim-treesitter/issues
	-- https://github.com/ravsii/tree-sitter-d2
	-- "d2",
	"editorconfig",
	-- "latex",
	"bibtex",
	"lua",
	"luadoc",
	"luap", -- lua_patterns
	"vim",
	"vimdoc",
	"vhs",
	"query",
	"bash",
	"clojure",
	"dockerfile",
	"embedded_template",
	"fsh",
	"fish",
	"hcl",
	"hlsplaylist",
	"html",
	"http",
	"ini",
	"pem",
	"php",
	"phpdoc",
	"printf",
	"properties",
	"javascript",
	"jsdoc",
	"jq",
	"json",
	"jsonc",
	"json5",
	"just",
	"kotlin",
	"markdown",
	"markdown_inline",
	"mermaid",
	"meson",
	"muttrc",
	"ninja",
	"nu",
	"regex",
	"ruby",
	"rust",
	"scheme",
	"scss",
	"sql",
	"terraform",
	"toml",
	"tsx",
	"typescript",
	"yaml",
	"prisma",
	"python",
	"requirements", -- python_requirements
	"robots", -- robots.txt
	"vue",
	"nix",
	-- "nickel",
	"ssh_config",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gowork",
	"gosum",
	"gotmpl",
	"helm",
	-- TODO: Create issue in nvim-treesitter to add this to available TS parser list
	-- "smarty",
	"graphql",
	"groovy",
	"gpg",
	"hurl",
	"nginx",
	"passwd",
	"smithy",
	"svelte",
	-- "swift",
	"tmux",
	"xcompose",
	"xml",
	"zathurarc",
	"zig",
}

-- Filetypes where treesitter highlighting should be disabled
local highlight_disabled_fts = {
	chezmoitmpl = true,
	embedded_template = true,
}

return {
	{
		"Drew-Daniels/nvim-treesitter",
		dev = true,
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()

			-- Install parsers (replaces ensure_installed)
			require("nvim-treesitter").install(parsers)

			-- Enable treesitter highlighting and indent (replaces highlight/indent modules)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					if highlight_disabled_fts[ft] or string.find(ft, "chezmoitmpl") then
						return
					end
					local lang = vim.treesitter.language.get_lang(ft)
					if lang and vim.treesitter.language.add(lang) then
						vim.treesitter.start(args.buf, lang)
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
		-- https://mise.jdx.dev/mise-cookbook/neovim.html
		init = function()
			vim.treesitter.query.add_predicate("is-mise?", function(_match, _pattern, source, _pred, _metadata)
				local bufnr = type(source) == "number" and source or 0
				local filepath = vim.api.nvim_buf_get_name(bufnr)
				local filename = vim.fn.fnamemodify(filepath, ":t")
				return string.match(filename, ".*mise.*%.toml$") ~= nil
			end, { force = true })
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
	{
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
	},
	{
		-- LspAttach keymaps (moved out of nvim-treesitter config)
		"neovim/nvim-lspconfig",
		init = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { unpack(opts), desc = "declaration" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { unpack(opts), desc = "definition" })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = "hover" })
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { unpack(opts), desc = "implementation" })
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { unpack(opts), desc = "signature help" })
					vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { unpack(opts), desc = "type definition" })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { unpack(opts), desc = "references" })
					vim.keymap.set("n", "gR", vim.lsp.buf.rename, { unpack(opts), desc = "rename" })
				end,
				desc = "Initialize LSP on LspAttach event",
			})
		end,
	},
}

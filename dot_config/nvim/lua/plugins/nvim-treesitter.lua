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
	-- "jsonc",
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
	-- "robots", -- robots.txt
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
}

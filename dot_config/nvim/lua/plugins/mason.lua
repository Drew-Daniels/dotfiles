return {
	"williamboman/mason.nvim",
	opts = {
		ensure_installed = {
			"clang-format",
			"jsonlint",
			"stylua",
			"prettier",
			"nxls",
			"shfmt",
			"shellcheck",
			"sqlfmt",
			"reformat-gherkin",
			"yamlfmt",
		},
		max_concurrent_installers = 10,
	},
}

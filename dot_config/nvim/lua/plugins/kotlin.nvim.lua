return {
	"AlexandrosAlexiou/kotlin.nvim",
	ft = { "kotlin" },
	dependencies = {
		"oil.nvim",
		"trouble.nvim",
	},
	config = function()
		require("kotlin").setup({
			jvm_args = { "-Xmx4g" },
			inlay_hints = { enabled = true },
		})
	end,
}

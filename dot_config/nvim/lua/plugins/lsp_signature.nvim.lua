return {
	"ray-x/lsp_signature.nvim",
	event = "InsertEnter",
	-- Deactivating, because this can be kind of noisy
	cond = false,
	opts = {
		hint_prefix = {
			above = "↙ ",
			current = "← ",
			below = "↖ ",
		},
		floating_window = true,
		hint_enable = false,
	},
}

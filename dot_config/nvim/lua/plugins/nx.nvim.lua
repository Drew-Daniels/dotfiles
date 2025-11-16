return {
	{
		"Equilibris/nx.nvim",
    -- NOTE: Doesn't seem maintained anymore: https://github.com/Equilibris/nx.nvim/issues/25#issuecomment-2798509944
    cond = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			-- TODO: Figure out why this is failing to be found
			-- form_renderer = require("nx.form-renderers").telescope(),
		},
		-- Plugin will load when you use these keys
		keys = {
			-- { "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
			{ "<leader>ma", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
		},
	},
}
